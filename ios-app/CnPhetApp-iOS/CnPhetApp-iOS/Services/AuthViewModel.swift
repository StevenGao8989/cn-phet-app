//
//  AuthViewModel.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

// Services/AuthViewModel.swift
import Foundation
import Supabase
import SwiftUI   // ← 需要这行，withAnimation 才在作用域内

// 与 public.profiles 对齐的输入体
private struct NewProfile: Encodable {
    let id: UUID
    let email: String
    let display_name: String?
}

private struct UpdateProfileInput: Encodable {
    let display_name: String
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var profile: UserProfile?
    @Published var isBusy = false
    @Published var errorMessage: String?
    
    @Published var banner: String?
    // ⬇️ 为两步注册新增的状态
    @Published var awaitingEmailOTP = false
    @Published var pendingEmail: String?
    @Published var pendingPassword: String?
    @Published var pendingDisplayName: String?

    private let client = SupabaseService.shared.client
    private var authWatcher: Task<Void, Never>?

    init() {
        authWatcher = Task {
            for await state in self.client.auth.authStateChanges {
                switch state.event {
                case .initialSession, .signedIn, .tokenRefreshed:
                    try? await self.loadCurrentUserAndProfile()
                case .signedOut, .userDeleted:
                    self.user = nil
                    self.profile = nil
                default:
                    break
                }
            }
        }
        Task { try? await self.loadCurrentUserAndProfile() }
    }

    deinit { authWatcher?.cancel() }

    
    // MARK: - 步骤 1：注册并发送验证码（不自动登录）
    func startSignUp(email: String, password: String, displayName: String?) async {
        await run {
            self.errorMessage = nil

            // 把昵称预写进 metadata（Users 页面将显示）
            let meta: [String: AnyJSON]? =
                (displayName?.isEmpty == false) ? [
                    "display_name": .string(displayName!),
                    "full_name":    .string(displayName!)
                ] : nil

            // 发起注册（Confirm email 开启时，通常不会返回 session）
            _ = try await self.client.auth.signUp(email: email, password: password, data: meta)

            // 保存待验证信息，进入“输入验证码”步骤
            self.pendingEmail = email
            self.pendingPassword = password
            self.pendingDisplayName = displayName
            self.awaitingEmailOTP = true
            self.errorMessage = "我们已向 \(email) 发送 6 位验证码，请查收。"
        }
    }

    // MARK: - 步骤 2：校验验证码 → 登录 → 落库资料
    func verifyEmailOTP(_ code: String) async {
        await run {
            guard
                let email = self.pendingEmail,
                let pwd   = self.pendingPassword
            else {
                self.errorMessage = "验证码会话已过期，请返回重新注册。"
                self.awaitingEmailOTP = false
                return
            }

            // 1) 校验 6 位验证码（对应 signup 流程）
            _ = try await self.client.auth.verifyOTP(
                email: email,
                token: code,
                type: .signup
            )

            // 2) 通过后再登录
            _ = try await self.client.auth.signIn(email: email, password: pwd)

            // 3) upsert 到 profiles（触发器在也不冲突）
            if let u = try? await self.client.auth.session.user {
                let payload = NewProfile(id: u.id, email: email, display_name: self.pendingDisplayName)
                _ = try await self.client.database
                    .from("profiles")
                    .upsert(payload, onConflict: "id")
                    .execute()

                // 4) 可选：把昵称再同步一次到 user_metadata（确保 Users 页面显示）
                if let name = self.pendingDisplayName, !name.isEmpty {
                    try? await self.client.auth.update(user: .init(
                        data: ["display_name": AnyJSON.string(name), "full_name": AnyJSON.string(name)]
                    ))
                }
            }

            // 5) 清理并加载资料
            self.awaitingEmailOTP = false
            self.pendingEmail = nil
            self.pendingPassword = nil
            self.pendingDisplayName = nil
            try? await self.loadCurrentUserAndProfile()
        }
    }

    // 重发验证码
    func resendEmailOTP() async {
        await run {
            guard let email = self.pendingEmail else { return }
            try await self.client.auth.resend(email: email, type: .signup)
            self.errorMessage = "已重新发送验证码到 \(email)"
        }
    }

    // 取消两步注册，回到输入邮箱密码页
    func cancelPendingSignup() {
        awaitingEmailOTP = false
        pendingEmail = nil
        pendingPassword = nil
        pendingDisplayName = nil
        errorMessage = nil
    }

    // MARK: - 其他现有能力（保持不变）
    func signIn(email: String, password: String) async {
        await run {
            _ = try await self.client.auth.signIn(email: email, password: password)
            try await self.loadCurrentUserAndProfile()
        }
    }

    func signOut() async {
        await run {
            try await self.client.auth.signOut()
            self.user = nil
            self.profile = nil
        }
    }
    
    // 从按钮里调用这些同步方法即可，避免在 View 里直接用 Task
    @MainActor
    func signOutFromUI() {
        Task { await self.signOut() }
    }

    @MainActor
    func deleteAccountFromUI(confirmPassword: String) {
        Task { await self.deleteAccount(confirmPassword: confirmPassword) }
    }

    
    
    // MARK: - 用户信息（便于 UI 直接拿）
    var accountEmail: String { user?.email ?? "" }
    var accountDisplayName: String { profile?.display_name ?? "" }
    // 在 AuthViewModel 顶部属性区新增

    func showBanner(_ text: String, seconds: Double = 1.0) {
        banner = text
        Task {
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            await MainActor.run { self.banner = nil }
        }
    }

    /// 统一显示顶部提示，避免与任何同名属性冲突
    @MainActor
    func showToast(_ text: String, seconds: Double = 1.0) {
        withAnimation { banner = text }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            withAnimation { banner = nil }
        }
    }

    /// 简单错误构造器（替代 AuthError.message(...)）
    private func makeError(_ msg: String) -> Error {
        NSError(domain: "app.auth", code: -1, userInfo: [NSLocalizedDescriptionKey: msg])
    }

    
    // MARK: - 修改密码（校验原密码）
    func changePassword(current oldPassword: String, to newPassword: String) async {
        await run {
            guard let email = self.user?.email else {
                self.errorMessage = "未登录"; return
            }
            // 1) 先用原密码“再登录”校验（若开启 Secure password change，等价于 re-auth）
            _ = try await self.client.auth.signIn(email: email, password: oldPassword)
            // 2) 更新密码
            try await self.client.auth.update(user: .init(password: newPassword))
            // 3) 可选：用新密码再登录一次，确保会话最新
            _ = try? await self.client.auth.signIn(email: email, password: newPassword)
            // 原来：self.errorMessage = "密码已更新"
            await MainActor.run { self.showToast("密码已更新", seconds: 1) }


        }
    }

    // MARK: - 注销账号（推荐：走 Edge Function 真删）
    /// 真正执行"注销账户"的逻辑
    func deleteAccount(confirmPassword: String) async {
        do {
            print("🔍 开始注销账号流程...")
            
            // 1) 重新校验密码（避免越权/过期会话）
            guard let email = self.user?.email ?? self.profile?.email else {
                throw makeError("当前用户邮箱不存在")
            }
            print("📧 验证邮箱: \(email)")
            
            _ = try await self.client.auth.signIn(email: email, password: confirmPassword)
            print("✅ 密码验证成功")

            // 2) 调用 Edge Function 删除 supabase auth 用户
            let session = try await self.client.auth.session
            let jwt = session.accessToken
            guard !jwt.isEmpty else { throw makeError("会话失效，请重新登录") }
            print("🔑 获取到有效JWT")

            // 尝试调用Edge Function
            do {
                try await SupabaseService.shared.deleteCurrentUserViaEdge(jwt: jwt)
                print("✅ Edge Function 调用成功")
            } catch {
                print("⚠️ Edge Function 调用失败: \(error.localizedDescription)")
                // 如果Edge Function失败，尝试软删除
                print("🔄 尝试软删除...")
                try await self.softDeleteAccount(note: "Edge Function失败，使用软删除")
            }

            // 3) 先给出提示，再退出登录
            await MainActor.run { self.showToast("注销成功", seconds: 1.0) }
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1s

            try await self.client.auth.signOut()
            await MainActor.run {
                self.user = nil
                self.profile = nil
            }
            print("✅ 账号注销完成，已退出登录")
            
        } catch {
            print("❌ 注销账号失败: \(error.localizedDescription)")
            // 统一错误提示
            await MainActor.run { self.showToast(error.localizedDescription, seconds: 2) }
        }
    }
    
    

    // MARK: - 仅用于"开发期软删除"的便捷方法（不想立刻做 Edge Function 时可先用）
    func softDeleteAccount(note: String? = nil) async {
        await run {
            guard let uid = self.user?.id else {
                print("❌ 软删除失败：用户ID不存在")
                return
            }
            print("🔄 开始软删除用户: \(uid)")
            
            // 尝试更新profiles表
            do {
                // 使用结构体来确保类型安全
                struct SoftDeleteProfile: Encodable {
                    let display_name: String
                    let updated_at: String
                    let deleted_at: String
                }
                
                let updateData = SoftDeleteProfile(
                    display_name: "已注销",
                    updated_at: ISO8601DateFormatter().string(from: .init()),
                    deleted_at: ISO8601DateFormatter().string(from: .init())
                )
                
                _ = try await self.client.database
                    .from("profiles")
                    .update(updateData)
                    .eq("id", value: uid)
                    .execute()
                print("✅ profiles表更新成功")
            } catch {
                print("⚠️ profiles表更新失败: \(error.localizedDescription)")
                // 即使更新失败也继续执行
            }
            
            // 退出登录
            try? await self.client.auth.signOut()
            self.user = nil
            self.profile = nil
            print("✅ 软删除完成，已退出登录")
        }
    }


    func updateDisplayName(_ name: String) async {
        await run {
            guard let uid = self.user?.id else { return }
            _ = try await self.client.database
                .from("profiles")
                .update(UpdateProfileInput(display_name: name))
                .eq("id", value: uid)
                .execute()
            self.profile?.display_name = name
            try? await self.client.auth.update(user: .init(
                data: ["display_name": AnyJSON.string(name), "full_name": AnyJSON.string(name)]
            ))
        }
    }

    private func loadCurrentUserAndProfile() async throws {
        let session = try? await self.client.auth.session
        self.user = session?.user
        if let uid = session?.user.id {
            self.profile = try? await self.client.database
                .from("profiles")
                .select()
                .eq("id", value: uid)
                .single()
                .execute()
                .value
        } else {
            self.profile = nil
        }
    }

    // 通用 loading/错误包装
    private func run(_ work: @escaping () async throws -> Void) async {
        isBusy = true
        errorMessage = nil
        do { try await work() }
        catch {
            // 友好化常见错误提示
            let msg = error.localizedDescription.lowercased()
            if msg.contains("otp") || msg.contains("token") {
                self.errorMessage = "验证码无效或已过期，请重试或点击重发验证码。"
            } else if msg.contains("over email rate limit") || msg.contains("rate limit") {
                self.errorMessage = "请求太频繁，请稍后再试。"
            } else {
                self.errorMessage = error.localizedDescription
            }
            print("Auth error:", error)
        }
        isBusy = false
    }
}
