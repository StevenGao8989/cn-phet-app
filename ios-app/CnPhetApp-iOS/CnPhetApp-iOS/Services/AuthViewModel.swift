//
//  AuthViewModel.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

// Services/AuthViewModel.swift
import Foundation
import Supabase
import SwiftUI

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
    
    // 密码重置状态
    @Published var isResettingPassword = false
    @Published var resetToken: String?
    @Published var resetEmail: String?
    
    // 忘记密码验证码状态
    @Published var isForgotPasswordFlow = false
    @Published var forgotPasswordEmail: String? = nil
    @Published var forgotPasswordOTP = ""
    
    // 登录界面状态
    @Published var loginEmail = ""
    @Published var loginPassword = ""
    @Published var showPassword = false
    @Published var rememberMe = false

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
    
    // MARK: - 计算属性
    var isLoginButtonEnabled: Bool {
        return !loginEmail.isEmpty && !loginPassword.isEmpty
    }

    
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

            // 保存待验证信息，进入"输入验证码"步骤
            self.pendingEmail = email
            self.pendingPassword = password
            self.pendingDisplayName = displayName
            self.awaitingEmailOTP = true
            
            // 显示成功提示
            await MainActor.run {
                self.showToast("✅ 验证码已发送到 \(email)", seconds: 3)
            }
            
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
                self.errorMessage = "注册信息丢失，请重新开始。"
                return
            }

            do {
                // 1️⃣ 校验验证码（这一步会建立 session）
                let result = try await self.client.auth.verifyOTP(
                email: email,
                token: code,
                type: .signup
            )

                // 验证码验证成功后，直接使用 result.user
                let user = result.user

                // 2️⃣ 登录（确保 session 建立）
            _ = try await self.client.auth.signIn(email: email, password: pwd)

                // 3️⃣ 落库用户资料
                let newProfile = NewProfile(
                    id: user.id,
                    email: user.email ?? email,
                    display_name: self.pendingDisplayName
                )
                
                _ = try await self.client.database
                    .from("profiles")
                    .insert(newProfile)
                    .execute()

                // 4️⃣ 加载用户信息
                try await self.loadCurrentUserAndProfile()
                
                // 5️⃣ 清理状态
            self.awaitingEmailOTP = false
            self.pendingEmail = nil
            self.pendingPassword = nil
            self.pendingDisplayName = nil
                self.errorMessage = nil
                
                // 6️⃣ 显示成功提示
                await MainActor.run {
                    self.showToast("🎉 注册成功！正在自动登录...", seconds: 3)
                }
                
                print("✅ 注册完成，用户已登录")
                
            } catch let error as NSError {
                print("❌ 验证码校验失败: \(error.localizedDescription)")
                
                // 根据错误类型提供更具体的提示
                let errorMsg = error.localizedDescription.lowercased()
                if errorMsg.contains("invalid") || errorMsg.contains("expired") {
                    self.errorMessage = "验证码无效或已过期，请重试或点击重发验证码。"
                } else if errorMsg.contains("over email rate limit") || errorMsg.contains("rate limit") {
                    self.errorMessage = "请求太频繁，请稍后再试。"
                } else {
                    self.errorMessage = "验证码发送失败，请稍后重试。"
                }
            }
        }
    }

    // MARK: - 忘记密码功能
    func resetPassword(email: String) async {
        await run {
            print("🔄 开始忘记密码流程，邮箱: \(email)")
            
            do {
                // 方法1：尝试使用密码重置功能（如果可用）
                do {
                    try await self.client.auth.resetPasswordForEmail(email)
                    print("✅ 密码重置验证码发送成功（方法1）")
                    
                    // 设置忘记密码流程状态
                    await MainActor.run {
                        self.forgotPasswordEmail = email
                        self.isForgotPasswordFlow = true
                        self.errorMessage = "验证码已发送到 \(email)，请查收邮件并输入验证码。"
                    }
                    
                    // 显示成功提示
                    await MainActor.run {
                        self.showToast("验证码已发送", seconds: 3)
                    }
                    return
                    
                } catch let error as NSError {
                    print("⚠️ 方法1失败，尝试方法2: \(error.localizedDescription)")
                }
                
                // 方法2：使用注册流程发送验证码
                print("🔄 尝试方法2：使用注册流程发送验证码")
                
                // 先尝试登出当前用户（如果有的话）
                do {
                    try await self.client.auth.signOut()
                    print("✅ 已登出当前用户")
                } catch let error as NSError {
                    print("⚠️ 登出失败或用户未登录: \(error.localizedDescription)")
                }
                
                // 发送新的验证码
                let signUpResult = try await self.client.auth.signUp(email: email, password: "temp_password_123")
                print("✅ 注册流程验证码发送成功")
                
                // 检查结果
                let user = signUpResult.user
                print("📧 用户ID: \(user.id.uuidString)")
                print("📧 验证码已发送到邮箱，请尽快输入")
                print("📧 注意：验证码有效期较短，请尽快输入")
                
                // 设置忘记密码流程状态
                await MainActor.run {
                    self.forgotPasswordEmail = email
                    self.isForgotPasswordFlow = true
                    self.errorMessage = "验证码已发送到 \(email)，请查收邮件并输入验证码。"
                }
                
                // 显示成功提示
                await MainActor.run {
                    self.showToast("验证码已发送", seconds: 3)
                }
                
            } catch let error as NSError {
                print("❌ 发送验证码失败: \(error.localizedDescription)")
                print("❌ 错误详情: \(error)")
                
                // 根据错误类型提供更具体的提示
                let errorMsg = error.localizedDescription.lowercased()
                if errorMsg.contains("user not found") || errorMsg.contains("does not exist") {
                    self.errorMessage = "该邮箱地址未注册，请检查邮箱地址是否正确。"
                } else if errorMsg.contains("rate limit") || errorMsg.contains("too many requests") {
                    self.errorMessage = "请求过于频繁，请稍后再试。"
                } else if errorMsg.contains("invalid email") {
                    self.errorMessage = "邮箱地址格式不正确，请检查后重试。"
                } else if errorMsg.contains("email not confirmed") {
                    self.errorMessage = "邮箱未确认，请先确认邮箱。"
                } else if errorMsg.contains("already registered") {
                    self.errorMessage = "该邮箱已注册，请直接登录。"
                } else {
                    self.errorMessage = "发送失败，请稍后重试。"
                }
                
                // 显示错误提示
                await MainActor.run {
                    self.showToast("发送失败，请重试", seconds: 2)
                }
            }
        }
    }

    // 验证忘记密码的验证码
    func verifyForgotPasswordOTP(_ code: String) async {
        await run {
            guard let email = self.forgotPasswordEmail else {
                self.errorMessage = "邮箱信息丢失，请重新开始。"
                return
            }
            
            print("🔄 验证忘记密码验证码，邮箱: \(email)")
            print("📝 验证码: \(code)")
            
            do {
                print("🔄 开始验证验证码...")
                print("📝 邮箱: \(email)")
                print("📝 验证码: \(code)")
                print("📝 验证类型: .signup")
                
                // 方法1：尝试验证注册验证码
                do {
                    print("🔄 尝试方法1：验证注册验证码")
                    let result = try await self.client.auth.verifyOTP(
                        email: email,
                        token: code,
                        type: .signup
                    )
                    print("✅ 验证码验证成功（方法1）")
                    print("📝 验证结果: \(result)")
                    
                    // 验证成功后，进入密码重置界面
                    await MainActor.run {
                        self.resetEmail = email
                        self.resetToken = code
                        self.isResettingPassword = true
                        self.isForgotPasswordFlow = false
                        self.errorMessage = nil
                        print("🔄 进入密码重置界面")
                    }
                    return
                    
                } catch let error as NSError {
                    print("⚠️ 方法1失败: \(error.localizedDescription)")
                }
                
                // 方法2：尝试用验证码重新注册（建立会话）
                print("🔄 尝试方法2：用验证码重新注册建立会话")
                do {
                    // 先尝试登出当前用户
                    do {
                        try await self.client.auth.signOut()
                        print("✅ 已登出当前用户")
                    } catch let signOutError as NSError {
                        print("⚠️ 登出失败或用户未登录: \(signOutError.localizedDescription)")
                    }
                    
                    // 重新注册以建立会话
                    let result = try await self.client.auth.signUp(email: email, password: "temp_password_123")
                    print("✅ 重新注册成功，建立会话")
                    print("📝 注册结果: \(result)")
                    
                    // 验证成功后，进入密码重置界面
                    await MainActor.run {
                        self.resetEmail = email
                        self.resetToken = code
                        self.isResettingPassword = true
                        self.isForgotPasswordFlow = false
                        self.errorMessage = nil
                        print("🔄 进入密码重置界面")
                    }
                    return
                    
                } catch let error as NSError {
                    print("⚠️ 方法2失败: \(error.localizedDescription)")
                }
                
                // 如果两种方法都失败，提供具体错误信息
                print("❌ 所有验证方法都失败了")
                
                // 设置通用错误信息
                self.errorMessage = "验证码验证失败，请重试或重新发送验证码。"
                
                // 显示错误提示
                await MainActor.run {
                    self.showToast("验证失败，请重试", seconds: 2)
                }
            }
        }
    }

    // 重发忘记密码验证码
    func resendForgotPasswordOTP() async {
        await run {
            guard let email = self.forgotPasswordEmail else { return }
            
            print("🔄 重新发送验证码到: \(email)")
            
            do {
                // 先尝试登出当前用户
                do {
                    try await self.client.auth.signOut()
                    print("✅ 已登出当前用户")
                } catch let error as NSError {
                    print("⚠️ 登出失败或用户未登录: \(error.localizedDescription)")
                }
                
                // 重新发送注册验证码
                let result = try await self.client.auth.signUp(email: email, password: "temp_password_123")
                print("✅ 重新发送验证码成功")
                
                let user = result.user
                print("📧 新验证码已发送，用户ID: \(user.id.uuidString)")
                self.errorMessage = "新验证码已发送到 \(email)，请尽快输入。"
                
            } catch let error as NSError {
                print("❌ 重发验证码失败: \(error.localizedDescription)")
                self.errorMessage = "重发验证码失败，请重试。"
            }
        }
    }

    // 重发注册验证码
    func resendSignUpOTP() async {
        await run {
            guard let email = self.pendingEmail,
                  let password = self.pendingPassword,
                  let displayName = self.pendingDisplayName else {
                self.errorMessage = "注册信息丢失，请重新开始。"
                return
            }
            
            print("🔄 重新发送注册验证码到: \(email)")
            
            do {
                // 重新发送注册验证码
                let result = try await self.client.auth.signUp(email: email, password: password, data: [
                    "display_name": .string(displayName),
                    "full_name": .string(displayName)
                ])
                
                print("✅ 重新发送验证码成功")
                let user = result.user
                print("📧 新验证码已发送，用户ID: \(user.id.uuidString)")
                
                // 显示成功提示
                await MainActor.run {
                    self.showToast("✅ 新验证码已发送到 \(email)", seconds: 3)
                }
                
                self.errorMessage = "新验证码已发送到 \(email)，请尽快输入。"
                
            } catch let error as NSError {
                print("❌ 重发验证码失败: \(error.localizedDescription)")
                
                let errorMsg = error.localizedDescription.lowercased()
                if errorMsg.contains("rate limit") || errorMsg.contains("too many") {
                    self.errorMessage = "请求过于频繁，请稍后再试。"
                } else if errorMsg.contains("already registered") {
                    self.errorMessage = "该邮箱已注册，请直接登录。"
                } else {
                    self.errorMessage = "重发验证码失败，请重试。"
                }
            }
        }
    }

    // 取消忘记密码流程
    func cancelForgotPasswordFlow() {
        self.isForgotPasswordFlow = false
        self.forgotPasswordEmail = nil
        self.forgotPasswordOTP = ""
        self.errorMessage = nil
    }

    // 处理密码重置回调
    func handlePasswordReset(token: String, email: String) {
        print("🔄 开始处理密码重置回调")
        print("📝 Token: \(token)")
        print("📝 Email: \(email)")
        
        // 设置重置状态
        self.resetToken = token
        self.resetEmail = email
        self.isResettingPassword = true
        
        print("✅ 密码重置状态已设置")
        print("📝 isResettingPassword: \(self.isResettingPassword)")
        print("📝 resetEmail: \(self.resetEmail ?? "nil")")
        print("📝 resetToken: \(self.resetToken ?? "nil")")
    }

    // 提交新密码
    func updatePassword(newPassword: String) async {
        await run {
            guard let token = self.resetToken else {
                self.errorMessage = "重置令牌无效，请重新申请密码重置。"
                return
            }
            
            guard let email = self.resetEmail else {
                self.errorMessage = "重置邮箱信息丢失，请重新申请密码重置。"
                return
            }
            
            print("🔄 开始更新密码，邮箱: \(email)")
            print("📝 使用重置令牌: \(token)")
            
            do {
                // 步骤1：验证验证码并建立会话
                print("🔄 步骤1：验证验证码并建立会话")
                print("📝 验证码: \(token)")
                print("📝 邮箱: \(email)")
                
                var verificationSuccessful = false
                
                // 尝试多种验证方式
                do {
                    // 方式1：尝试 signup 类型验证
                    print("🔄 尝试方式1：signup 类型验证")
                    let result = try await self.client.auth.verifyOTP(
                        email: email,
                        token: token,
                        type: .signup
                    )
                    print("✅ 验证码验证成功（方式1）")
                    print("📝 验证结果: \(result)")
                    
                    // 检查是否有用户信息
                    let user = result.user
                    print("📧 用户ID: \(user.id.uuidString)")
                    verificationSuccessful = true
                    
                } catch let error as NSError {
                    print("⚠️ 方式1失败: \(error.localizedDescription)")
                    
                    // 方式2：尝试 recovery 类型验证（如果可用）
                    do {
                        print("🔄 尝试方式2：recovery 类型验证")
                        let result = try await self.client.auth.verifyOTP(
                            email: email,
                            token: token,
                            type: .recovery
                        )
                        print("✅ 验证码验证成功（方式2）")
                        print("📝 验证结果: \(result)")
                        
                        let user = result.user
                        print("📧 用户ID: \(user.id.uuidString)")
                        verificationSuccessful = true
                        
                    } catch let recoveryError as NSError {
                        print("⚠️ 方式2失败: \(recoveryError.localizedDescription)")
                        
                        // 方式3：尝试用验证码作为密码登录
                        do {
                            print("🔄 尝试方式3：用验证码作为密码登录")
                            _ = try await self.client.auth.signIn(email: email, password: token)
                            print("✅ 验证码登录成功（方式3）")
                            verificationSuccessful = true
                            
                        } catch let loginError as NSError {
                            print("⚠️ 方式3失败: \(loginError.localizedDescription)")
                            
                            // 所有方式都失败，提供详细错误信息
                            print("❌ 所有验证方式都失败了")
                            let errorMsg = error.localizedDescription.lowercased()
                            
                            if errorMsg.contains("expired") {
                                self.errorMessage = "验证码已过期，请重新申请密码重置。"
                            } else if errorMsg.contains("invalid") {
                                self.errorMessage = "验证码无效，请检查后重试。"
                            } else if errorMsg.contains("not found") {
                                self.errorMessage = "用户不存在，请检查邮箱地址。"
                            } else if errorMsg.contains("already used") {
                                self.errorMessage = "验证码已被使用，请重新申请。"
                            } else {
                                self.errorMessage = "验证码验证失败，请检查后重试。"
                            }
                            
                            await MainActor.run { self.showToast("验证失败，请重试", seconds: 2) }
                            return
                        }
                    }
                }
                
                // 如果验证失败，直接返回
                guard verificationSuccessful else {
                    print("❌ 验证码验证失败")
                    return
                }
                
                // 步骤2：检查当前会话状态
                print("🔄 步骤2：检查当前会话状态")
                do {
                    let currentSession = try await self.client.auth.session
                    print("✅ 当前会话有效，用户ID: \(currentSession.user.id.uuidString)")
                } catch {
                    print("⚠️ 当前会话无效，尝试建立新会话")
                    
                    // 尝试用临时密码登录建立会话
                    do {
                        print("🔄 尝试用临时密码登录建立会话")
                        _ = try await self.client.auth.signIn(email: email, password: "temp_password_123")
                        print("✅ 临时登录成功，会话已建立")
                    } catch let loginError as NSError {
                        print("❌ 临时登录失败: \(loginError.localizedDescription)")
                        
                        // 如果临时密码登录失败，尝试重新注册
                        do {
                            print("🔄 尝试重新注册建立会话")
                            try? await self.client.auth.signOut() // 确保清洁状态
                            
                            let signUpResult = try await self.client.auth.signUp(
                                email: email, 
                                password: "temp_password_123"
                            )
                            print("✅ 重新注册成功")
                            
                            let user = signUpResult.user
                            print("📧 新用户ID: \(user.id.uuidString)")
                            
                            // 提示用户需要重新输入验证码
                            self.errorMessage = "需要重新验证，请重新申请密码重置。"
                            await MainActor.run { 
                                self.showToast("需要重新验证", seconds: 2)
                            }
                            return
                            
                        } catch let signUpError as NSError {
                            print("❌ 重新注册失败: \(signUpError.localizedDescription)")
                            self.errorMessage = "无法建立认证会话，请重新申请密码重置。"
                            await MainActor.run { self.showToast("会话建立失败", seconds: 2) }
                            return
                        }
                    }
                }
                
                
                // 步骤3：更新密码
                print("🔄 步骤3：更新密码")
                
                do {
                    try await self.client.auth.update(user: .init(password: newPassword))
                    print("✅ 密码更新成功")
                    
                    await MainActor.run { self.showToast("密码重置成功！", seconds: 3) }
                    
                    // 步骤4：尝试用新密码登录
                    print("🔄 步骤4：尝试用新密码登录")
                    do {
                        _ = try await self.client.auth.signIn(email: email, password: newPassword)
                        try await self.loadCurrentUserAndProfile()
                        print("✅ 新密码登录成功")
                        
                        // 登录成功后，清理重置状态
                        await MainActor.run {
                            self.isResettingPassword = false
                            self.resetToken = nil
                            self.resetEmail = nil
                            self.errorMessage = nil
                            print("🔄 密码重置完成，已返回登录界面")
                        }
                        
                    } catch let loginError as NSError {
                        print("⚠️ 新密码登录失败: \(loginError.localizedDescription)")
                        
                        // 即使登录失败，也要清理重置状态并返回登录界面
                        await MainActor.run {
                            self.isResettingPassword = false
                            self.resetToken = nil
                            self.resetEmail = nil
                            self.errorMessage = "密码重置成功！请使用新密码登录。"
                            print("🔄 密码重置完成，返回登录界面")
                        }
                    }
                    
                } catch let updateError as NSError {
                    print("❌ 密码更新失败: \(updateError.localizedDescription)")
                    
                    // 根据错误类型提供更具体的提示
                    let errorMsg = updateError.localizedDescription.lowercased()
                    if errorMsg.contains("session") || errorMsg.contains("unauthorized") {
                        self.errorMessage = "认证会话问题，请重新申请密码重置。"
                    } else if errorMsg.contains("password") && errorMsg.contains("weak") {
                        self.errorMessage = "密码强度不够，请设置更强的密码。"
                    } else if errorMsg.contains("rate limit") || errorMsg.contains("too many") {
                        self.errorMessage = "请求过于频繁，请稍后再试。"
                    } else {
                        self.errorMessage = "密码更新失败，请检查后重试。"
                    }
                    
                    await MainActor.run { self.showToast("密码更新失败，请重试", seconds: 2) }
                }
                
            } catch let error as NSError {
                print("❌ 密码重置流程失败: \(error.localizedDescription)")
                self.errorMessage = "密码重置失败，请稍后重试。"
                await MainActor.run { self.showToast("重置失败，请重试", seconds: 2) }
            }
        }
    }

    // 取消密码重置
    func cancelPasswordReset() {
        self.isResettingPassword = false
        self.resetToken = nil
        self.resetEmail = nil
        self.errorMessage = nil
    }


    
    // 更新重置令牌（用于新验证码）
    func updateResetToken(newToken: String) {
        print("🔄 更新重置令牌")
        print("📝 旧令牌: \(self.resetToken?.prefix(10) ?? "nil")...")
        print("📝 新令牌: \(newToken.prefix(10))...")
        
        self.resetToken = newToken
        self.errorMessage = nil
        
        print("✅ 重置令牌更新完成")
    }
    
    // 调试方法：检查验证码状态
    func debugOTPStatus(email: String, token: String) async {
        print("🔍 开始调试验证码状态")
        print("📝 邮箱: \(email)")
        print("📝 验证码: \(token)")
        
        // 检查当前会话状态
        do {
            let session = try await self.client.auth.session
            print("✅ 当前会话状态: 已登录")
            print("📝 用户ID: \(session.user.id.uuidString)")
            print("📝 邮箱: \(session.user.email ?? "未知")")
        } catch {
            print("⚠️ 当前会话状态: 未登录")
        }
        
        // 尝试不同的验证方式
        let types: [String] = ["signup", "recovery", "magiclink", "email"]
        
        for typeString in types {
            do {
                print("🔄 尝试验证类型: \(typeString)")
                // 根据字符串类型选择对应的验证方式
                switch typeString {
                case "signup":
                    let result = try await self.client.auth.verifyOTP(
                        email: email,
                        token: token,
                        type: .signup
                    )
                    print("✅ 验证成功 - 类型: signup")
                    print("📝 结果: \(result)")
                    break
                case "recovery":
                    let result = try await self.client.auth.verifyOTP(
                        email: email,
                        token: token,
                        type: .recovery
                    )
                    print("✅ 验证成功 - 类型: recovery")
                    print("📝 结果: \(result)")
                    break
                default:
                    print("⚠️ 跳过不支持的验证类型: \(typeString)")
                    continue
                }
                break
            } catch let error as NSError {
                print("❌ 验证失败 - 类型: \(typeString), 错误: \(error.localizedDescription)")
            }
        }
        
        print("🔍 调试完成")
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
            print("🔐 开始登录流程，邮箱: \(email)")
            
            // 验证邮箱格式
            guard email.contains("@") else {
                self.errorMessage = "请输入有效的邮箱地址"
                print("❌ 登录失败: 邮箱格式不正确")
                return
            }
            
            // 直接使用邮箱登录
            _ = try await self.client.auth.signIn(email: email, password: password)
            try await self.loadCurrentUserAndProfile()
            
            // 登录成功后保存登录信息
            self.saveLoginInfo()
            print("🎉 登录成功！")
        }
    }

    func signOut() async {
        await run {
            try await self.client.auth.signOut()
            self.user = nil
            self.profile = nil
            
            // 登出时清除保存的登录信息
            self.clearSavedLoginInfo()
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
                self.errorMessage = "用户信息丢失，请重新登录。"
                return
            }
            
            do {
                // 先验证旧密码
            _ = try await self.client.auth.signIn(email: email, password: oldPassword)
                
                // 更新新密码
            try await self.client.auth.update(user: .init(password: newPassword))
                
                // 重新加载用户信息
                try await self.loadCurrentUserAndProfile()
                
                // 清除错误信息，设置成功消息
                self.errorMessage = nil
                self.showToast("密码修改成功！", seconds: 2)
                
            } catch let error as NSError {
                print("❌ 密码修改失败: \(error.localizedDescription)")
                
                let errorMsg = error.localizedDescription.lowercased()
                if errorMsg.contains("invalid") || errorMsg.contains("credentials") {
                    self.errorMessage = "当前密码错误，请检查后重试。"
                } else if errorMsg.contains("session") || errorMsg.contains("unauthorized") {
                    self.errorMessage = "认证会话已过期，请重新登录。"
                } else if errorMsg.contains("password") && errorMsg.contains("weak") {
                    self.errorMessage = "新密码强度不够，请使用更复杂的密码。"
                } else if errorMsg.contains("different") && errorMsg.contains("old") {
                    self.errorMessage = "新密码不能与当前密码相同，请设置不同的密码。"
                } else if errorMsg.contains("rate limit") || errorMsg.contains("too many") {
                    self.errorMessage = "请求过于频繁，请稍后再试。"
                } else {
                    // 对于其他英文错误，提供通用的中文提示
                    self.errorMessage = "密码修改失败，请检查输入信息后重试。"
                }
            }
        }
    }

    // MARK: - 删除账号
    func deleteAccount(confirmPassword: String) async {
        await run {
            guard let email = self.user?.email else {
                self.errorMessage = "用户信息丢失，请重新登录。"
                return
            }
            
            do {
                // 先验证密码
            _ = try await self.client.auth.signIn(email: email, password: confirmPassword)

                // 删除用户资料
                if let uid = self.user?.id {
                    _ = try await self.client.database
                        .from("profiles")
                        .delete()
                        .eq("id", value: uid)
                        .execute()
                    print("✅ profiles表删除成功")
                }
                
                // 删除用户账号
                try await self.client.auth.admin.deleteUser(id: self.user?.id ?? UUID())
                print("✅ 用户账号删除成功")
                
                // 退出登录
            try await self.client.auth.signOut()
                self.user = nil
                self.profile = nil
                
                self.errorMessage = "账号已成功删除。"
                self.showToast("账号已成功删除", seconds: 3)
                
            } catch let error as NSError {
                print("❌ 删除账号失败: \(error.localizedDescription)")
                
                let errorMsg = error.localizedDescription.lowercased()
                if errorMsg.contains("invalid") {
                    self.errorMessage = "密码错误，请重试。"
                } else {
                    self.errorMessage = "删除账号失败，请稍后重试。"
                }
            }
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
            } catch let error as NSError {
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
            let result = try? await self.client.database
                .from("profiles")
                .select("*")  // 选择所有字段
                .eq("id", value: uid)
                .execute()
            
            print("🔍 加载用户资料，UID: \(uid)")
            print("🔍 查询结果: \(result)")
            
            guard let result = result else {
                print("⚠️ 查询结果为空")
                self.profile = nil
                return
            }
            
            print("🔍 result.data 类型: \(type(of: result.data))")
            print("🔍 result.data 内容 (UTF8): \(String(data: result.data, encoding: .utf8) ?? "nil")")
            
            // 尝试从 result.data 解码为 [UserProfile]
            if let profiles = try? JSONDecoder().decode([UserProfile].self, from: result.data) {
                print("✅ 成功从 Data 解码为 [UserProfile]，共 \(profiles.count) 条记录")
                if let firstProfile = profiles.first {
                    self.profile = firstProfile
                    print("✅ 成功加载用户资料: \(firstProfile)")
                } else {
                    print("⚠️ 解码成功但数组为空")
                    self.profile = nil
                }
            } else {
                print("❌ 从 Data 解码为 [UserProfile] 失败。")
                // Fallback to dictionary parsing
                if let profiles = try? JSONSerialization.jsonObject(with: result.data, options: []) as? [[String: Any]] {
                    print("✅ 成功从 Data 解码为 [[String: Any]]，共 \(profiles.count) 条记录")
                    if let firstProfile = profiles.first {
                        // 从字典创建 UserProfile 对象
                        if let idString = firstProfile["id"] as? String,
                           let id = UUID(uuidString: idString) {
                            let profile = UserProfile(
                                id: id,
                                email: firstProfile["email"] as? String,
                                display_name: firstProfile["display_name"] as? String,
                                avatar_url: firstProfile["avatar_url"] as? String,
                                created_at: firstProfile["created_at"] as? Date,
                                updated_at: firstProfile["updated_at"] as? Date
                            )
                            self.profile = profile
                            print("✅ 成功加载用户资料 (字典): \(profile)")
                        } else {
                            print("⚠️ ID 转换失败")
                            self.profile = nil
                        }
                    } else {
                        print("⚠️ 字典解码成功但数组为空")
                        self.profile = nil
                    }
                } else {
                    print("❌ 从 Data 解码为 [[String: Any]] 失败。")
                    print("⚠️ result.data 内容: \(result.data)")
                    self.profile = nil
                }
            }
        } else {
            self.profile = nil
        }
    }

    // 通用 loading/错误包装
    private func run(_ work: @escaping () async throws -> Void) async {
        isBusy = true
        errorMessage = nil
        do { try await work() }
        catch let error as NSError {
            // 友好化常见错误提示
            let msg = error.localizedDescription.lowercased()
            if msg.contains("otp") || msg.contains("token") {
                self.errorMessage = "验证码无效或已过期，请重试或点击重发验证码。"
            } else if msg.contains("over email rate limit") || msg.contains("rate limit") {
                self.errorMessage = "请求太频繁，请稍后再试。"
            } else {
                self.errorMessage = "操作失败，请稍后重试。"
            }
            print("Auth error:", error)
        }
        isBusy = false
    }
    
    // MARK: - 第三方登录方法
    func wechatLogin() async {
        await run {
            // TODO: 实现微信登录
            print("微信登录功能待实现")
            self.errorMessage = "微信登录功能正在开发中，请稍后再试"
        }
    }
    
    func qqLogin() async {
        await run {
            // TODO: 实现QQ登录
            print("QQ登录功能待实现")
            self.errorMessage = "QQ登录功能正在开发中，请稍后再试"
        }
    }
    
    func weiboLogin() async {
        await run {
            // TODO: 实现微博登录
            print("微博登录功能待实现")
            self.errorMessage = "微博登录功能正在开发中，请稍后再试"
        }
    }
    
    // MARK: - 登录信息管理
    func loadSavedLoginInfo() {
        // 从UserDefaults加载保存的登录信息
        if let savedEmail = UserDefaults.standard.string(forKey: "savedLoginEmail") {
            loginEmail = savedEmail
        }
        
        if let savedPassword = UserDefaults.standard.string(forKey: "savedLoginPassword") {
            loginPassword = savedPassword
        }
        
        rememberMe = UserDefaults.standard.bool(forKey: "rememberMe")
    }
    
    func saveLoginInfo() {
        if rememberMe {
            UserDefaults.standard.set(loginEmail, forKey: "savedLoginEmail")
            UserDefaults.standard.set(loginPassword, forKey: "savedLoginPassword")
            UserDefaults.standard.set(true, forKey: "rememberMe")
        } else {
            UserDefaults.standard.removeObject(forKey: "savedLoginEmail")
            UserDefaults.standard.removeObject(forKey: "savedLoginPassword")
            UserDefaults.standard.set(false, forKey: "rememberMe")
        }
    }
    
    func clearSavedLoginInfo() {
        UserDefaults.standard.removeObject(forKey: "savedLoginEmail")
        UserDefaults.standard.removeObject(forKey: "savedLoginPassword")
        UserDefaults.standard.set(false, forKey: "rememberMe")
        loginEmail = ""
        loginPassword = ""
    }
    

    

    

    
    /// 测试数据库连接和查询（调试用）
    func testDatabaseConnection() async {
        print("🔍 开始测试数据库连接...")
        
        do {
            let result = try await self.client.database
                .from("profiles")
                .select("*")
                .execute()
            
            print("🔍 数据库查询结果: \(result)")
            print("🔍 result.data 类型: \(type(of: result.data))")
            print("🔍 result.data 内容 (UTF8): \(String(data: result.data, encoding: .utf8) ?? "nil")")
            
            // 尝试从 result.data 解码为 [UserProfile]
            if let profiles = try? JSONDecoder().decode([UserProfile].self, from: result.data) {
                print("✅ 成功从 Data 解码为 [UserProfile]，共 \(profiles.count) 条记录")
                for (index, profile) in profiles.enumerated() {
                    print("📋 记录 \(index + 1): \(profile)")
                }
            } else {
                print("❌ 从 Data 解码为 [UserProfile] 失败。")
                // Fallback to dictionary parsing
                if let profiles = try? JSONSerialization.jsonObject(with: result.data, options: []) as? [[String: Any]] {
                    print("✅ 成功从 Data 解码为 [[String: Any]]，共 \(profiles.count) 条记录")
                    for (index, profile) in profiles.enumerated() {
                        print("📋 记录 \(index + 1): \(profile)")
                    }
                } else {
                    print("❌ 从 Data 解码为 [[String: Any]] 失败。")
                    print("⚠️ result.data 内容: \(result.data)")
                }
            }
        } catch {
            print("❌ 数据库连接测试失败: \(error)")
        }
    }
}
