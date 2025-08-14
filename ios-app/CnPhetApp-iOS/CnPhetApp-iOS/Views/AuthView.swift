//
//  AuthView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // 渐变背景
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 主卡片
                VStack(spacing: 24) {
                    // 标题
                    VStack(spacing: 8) {
                        Text("理科学习助手")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(selectedTab == 0 ? "登录" : "注册")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                    
                    // 标签页选择器
                    Picker("认证方式", selection: $selectedTab) {
                        Text("登录").tag(0)
                        Text("注册").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // 内容区域
                    if auth.isForgotPasswordFlow {
                        ForgotPasswordOTPForm()
                    } else if auth.isResettingPassword {
                        PasswordResetForm()
                    } else if selectedTab == 0 {
                        SignInForm()
                    } else {
                        SignUpForm()
                    }
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

// 登录表单
struct SignInForm: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showForgotPasswordAlert = false
    @State private var forgotPasswordEmail = ""
    @State private var showManualResetAlert = false
    @State private var manualResetEmail = ""
    @State private var manualResetToken = ""
    @State private var showLinkInputAlert = false
    @State private var linkInputText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // 输入字段
            VStack(spacing: 16) {
                TextField("邮箱", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("密码", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // 忘记密码链接
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Button("忘记密码？") {
                            showForgotPasswordAlert = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Button("手动重置密码") {
                            showManualResetAlert = true
                        }
                        .font(.caption2)
                        .foregroundColor(.orange)
                        
                        Button("从邮件复制链接") {
                            showLinkInputAlert = true
                        }
                        .font(.caption2)
                        .foregroundColor(.green)
                        

                    }
                }
            }
            
            // 登录按钮
            Button(action: {
                Task {
                    do {
                        try await auth.signIn(email: email, password: password)
                    } catch {
                        // 错误处理
                    }
                }
            }) {
                Text("登录")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(email.isEmpty || password.count < 6)
            
            // 错误提示
            if let error = auth.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            // 成功提示（用于忘记密码等操作）
            if let banner = auth.banner, !banner.isEmpty {
                Text(banner)
                    .foregroundColor(.green)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .alert("忘记密码", isPresented: $showForgotPasswordAlert) {
            TextField("请输入邮箱", text: $forgotPasswordEmail)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            Button("取消", role: .cancel) {
                forgotPasswordEmail = ""
            }
            
            Button(auth.isBusy ? "发送中..." : "发送重置链接") {
                Task {
                    await auth.resetPassword(email: forgotPasswordEmail)
                    forgotPasswordEmail = ""
                    showForgotPasswordAlert = false
                }
            }
            .disabled(forgotPasswordEmail.isEmpty || auth.isBusy)
        } message: {
            Text("请输入您的邮箱地址，我们将发送密码重置链接到您的邮箱。")
        }
        .alert("手动重置密码", isPresented: $showManualResetAlert) {
            TextField("邮箱地址", text: $manualResetEmail)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            TextField("重置令牌", text: $manualResetToken)
                .textInputAutocapitalization(.never)
                .textInputAutocapitalization(.never)
            
            Button("取消", role: .cancel) {
                manualResetEmail = ""
                manualResetToken = ""
            }
            
            Button("开始重置") {
                auth.manualTriggerPasswordReset(email: manualResetEmail, token: manualResetToken)
                manualResetEmail = ""
                manualResetToken = ""
                showManualResetAlert = false
            }
            .disabled(manualResetEmail.isEmpty || manualResetToken.isEmpty)
        } message: {
            Text("如果您收到了密码重置邮件，请从邮件中复制重置令牌，然后在这里手动输入邮箱和令牌来重置密码。")
        }
        .alert("从邮件复制链接", isPresented: $showLinkInputAlert) {
            TextField("粘贴完整链接", text: $linkInputText)
                .textInputAutocapitalization(.never)
            
            Button("取消", role: .cancel) {
                linkInputText = ""
            }
            
            Button("解析链接") {
                parsePasswordResetLink(linkInputText)
                linkInputText = ""
                showLinkInputAlert = false
            }
            .disabled(linkInputText.isEmpty)
        } message: {
            Text("请从邮件中复制完整的重置链接（包括 cnphetapp:// 开头的部分），粘贴到这里，我们将自动解析邮箱和令牌。")
        }
    }
    
    // 解析密码重置链接
    private func parsePasswordResetLink(_ link: String) {
        print("🔗 开始解析链接: \(link)")
        
        guard let url = URL(string: link) else {
            print("❌ 无效的链接格式")
            return
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            print("❌ 无法解析链接参数")
            return
        }
        
        var token: String?
        var email: String?
        
        for item in queryItems {
            if item.name == "token" {
                token = item.value
            } else if item.name == "email" {
                email = item.value
            }
        }
        
        if let token = token, let email = email {
            print("✅ 解析成功 - Token: \(token.prefix(10))..., Email: \(email)")
            auth.manualTriggerPasswordReset(email: email, token: token)
        } else {
            print("❌ 缺少必要的参数")
        }
    }
}

// 注册表单
struct SignUpForm: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var code = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if auth.awaitingEmailOTP {
                // 验证码输入阶段
                VStack(spacing: 16) {
                    Text("验证码已发送至：\(auth.pendingEmail ?? email)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    TextField("输入 6 位验证码", text: $code)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.never)
                    
                    HStack(spacing: 12) {
                        Button("返回修改") {
                            auth.cancelPendingSignup()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("重发验证码") {
                            Task { await auth.resendForgotPasswordOTP() }
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Button("验证并完成注册") {
                        Task { 
                            await auth.verifyEmailOTP(code.trimmingCharacters(in: .whitespaces)) 
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(code.trimmingCharacters(in: .whitespaces).count < 6)
                }
            } else {
                // 注册信息输入阶段
                VStack(spacing: 16) {
                    TextField("昵称（可选）", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("邮箱", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("密码（≥6 位）", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(auth.isBusy ? "提交中…" : "注册（将发送验证码）") {
                    Task { 
                        await auth.startSignUp(email: email, password: password, displayName: name) 
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.count < 6)
            }
            
            // 错误提示
            if let error = auth.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// 密码重置表单
struct PasswordResetForm: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            VStack(spacing: 8) {
                Text("重置密码")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("请输入您的新密码")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // 显示当前重置的邮箱
                if let email = auth.resetEmail {
                    Text("重置邮箱: \(email)")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // 输入字段
            VStack(spacing: 16) {
                SecureField("新密码（≥6 位）", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("确认新密码", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // 按钮
            VStack(spacing: 12) {
                Button(auth.isBusy ? "更新中..." : "更新密码") {
                    Task {
                        await auth.updatePassword(newPassword: newPassword)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(newPassword.isEmpty || confirmPassword.isEmpty || newPassword != confirmPassword || newPassword.count < 6 || auth.isBusy)
                
                Button("取消") {
                    auth.cancelPasswordReset()
                }
                .buttonStyle(.bordered)
            }
            
            // 错误提示
            if let error = auth.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            // 成功提示
            if let banner = auth.banner, !banner.isEmpty {
                Text(banner)
                    .foregroundColor(.green)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .onChange(of: auth.isResettingPassword) { newValue in
            if !newValue {
                print("🔄 检测到密码重置状态变为 false，应该返回登录界面")
            }
        }
    }
}

// 忘记密码验证码表单
struct ForgotPasswordOTPForm: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var otpCode = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            VStack(spacing: 8) {
                Text("忘记密码")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("请输入验证码")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // 显示邮箱
                if let email = auth.forgotPasswordEmail {
                    Text("邮箱: \(email)")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // 验证码输入
            VStack(spacing: 16) {
                TextField("输入 6 位验证码", text: $otpCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
            }
            
            // 按钮
            VStack(spacing: 12) {
                Button(auth.isBusy ? "验证中..." : "验证验证码") {
                    Task {
                        await auth.verifyForgotPasswordOTP(otpCode)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(otpCode.isEmpty || otpCode.count < 6 || auth.isBusy)
                
                Button("重发验证码") {
                    Task {
                        await auth.resendForgotPasswordOTP()
                    }
                }
                .buttonStyle(.bordered)
                
                Button("取消") {
                    auth.cancelForgotPasswordFlow()
                }
                .buttonStyle(.bordered)
            }
            
            // 错误提示
            if let error = auth.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
