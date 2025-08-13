//
//  AuthViewModel.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

// Services/AuthViewModel.swift
import Foundation
import Supabase

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
