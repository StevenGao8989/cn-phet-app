//
//  AuthView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var showForgotPasswordAlert = false
    @State private var forgotPasswordEmail = ""
    @State private var showRegistrationView = false
    
    var body: some View {
        ZStack {
            // 背景色
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 主登录表单
                VStack(spacing: 0) {
                    // 标题区域
                    VStack(spacing: 8) {
                        Text("理科实验室")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("登录您的账户")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 32)
                    
                    // 内容区域 - 根据状态显示不同界面
                    if auth.isForgotPasswordFlow {
                        ForgotPasswordOTPForm()
                    } else if auth.isResettingPassword {
                        PasswordResetForm()
                    } else {
                        // 登录表单
                        VStack(spacing: 24) {
                            // 账号输入框
                            VStack(alignment: .leading, spacing: 8) {
                                Text("账号")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundColor(.secondary)
                                        .frame(width: 20)
                                    
                                    TextField("输入用户名或邮箱", text: $auth.loginEmail)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .textInputAutocapitalization(.never)
                                        .keyboardType(.default)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                
                                // 提示文字
                                Text("支持用户名或邮箱登录")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // 密码输入框
                            VStack(alignment: .leading, spacing: 8) {
                                Text("密码")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.secondary)
                                        .frame(width: 20)
                                    
                                    if auth.showPassword {
                                        TextField("输入您的账户密码", text: $auth.loginPassword)
                                            .textFieldStyle(PlainTextFieldStyle())
                                    } else {
                                        SecureField("输入您的账户密码", text: $auth.loginPassword)
                                            .textFieldStyle(PlainTextFieldStyle())
                                    }
                                    
                                    Button(action: {
                                        auth.showPassword.toggle()
                                    }) {
                                        Image(systemName: auth.showPassword ? "eye.slash" : "eye")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            // 记住我和忘记密码
                            HStack {
                                Button(action: {
                                    auth.rememberMe.toggle()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: auth.rememberMe ? "checkmark.square.fill" : "square")
                                            .foregroundColor(auth.rememberMe ? .blue : .secondary)
                                        Text("记住我")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                    }
                                }
                                
                                Spacer()
                                
                                Button("忘记密码?") {
                                    forgotPasswordEmail = auth.loginEmail
                                    showForgotPasswordAlert = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            
                            // 登录按钮
                            Button(action: {
                                Task {
                                    await auth.signIn(email: auth.loginEmail, password: auth.loginPassword)
                                }
                            }) {
                                Text(auth.isBusy ? "登录中..." : "登录")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(auth.isLoginButtonEnabled ? Color.blue : Color.gray)
                                    .cornerRadius(12)
                            }
                            .disabled(!auth.isLoginButtonEnabled)
                            
                            // 错误提示
                            if let error = auth.errorMessage, !error.isEmpty {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // 注册链接
                            HStack {
                                Text("还没有账户?")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Button("立即注册") {
                                    showRegistrationView = true
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            
                            // 分割线和第三方登录
                            VStack(spacing: 20) {
                                HStack {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color(.systemGray4))
                                    
                                    Text("或使用以下方式登录")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 16)
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(Color(.systemGray4))
                                }
                                
                                // 第三方登录图标
                                HStack(spacing: 32) {
                                    // 微信
                                    Button(action: {
                                        Task {
                                            await auth.wechatLogin()
                                        }
                                    }) {
                                        Image(systemName: "message.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(Color.green)
                                            .clipShape(Circle())
                                    }
                                    
                                    // QQ
                                    Button(action: {
                                        Task {
                                            await auth.qqLogin()
                                        }
                                    }) {
                                        Image(systemName: "person.2.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(Color.blue)
                                            .clipShape(Circle())
                                    }
                                    
                                    // 微博
                                    Button(action: {
                                        Task {
                                            await auth.weiboLogin()
                                        }
                                    }) {
                                        Image(systemName: "globe")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(width: 50, height: 50)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
                .background(Color.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                
                Spacer()
            }
        }
        .alert("忘记密码", isPresented: $showForgotPasswordAlert) {
            TextField("请输入邮箱地址", text: $forgotPasswordEmail)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            
            Button("发送重置验证码") {
                Task {
                    await auth.resetPassword(email: forgotPasswordEmail)
                }
            }
            
            Button("取消", role: .cancel) { }
        } message: {
            Text("请输入您的邮箱地址，我们将发送密码重置验证码到您的邮箱。")
        }
        .sheet(isPresented: $showRegistrationView) {
            RegistrationView()
                .environmentObject(auth)
        }
        .onAppear {
            // 加载保存的登录信息
            auth.loadSavedLoginInfo()
        }
    }
}

// 注册界面
struct RegistrationView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var agreedToTerms = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 标题
                VStack(spacing: 8) {
                    Text("创建账户")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("请填写以下信息完成注册")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // 根据状态显示不同内容
                if auth.awaitingEmailOTP {
                    // 验证码输入界面
                    EmailVerificationView(
                        email: email,
                        displayName: displayName,
                        onBack: {
                            auth.cancelPendingSignup()
                        }
                    )
                } else {
                    // 注册表单界面
                    RegistrationFormView(
                        email: $email,
                        password: $password,
                        confirmPassword: $confirmPassword,
                        displayName: $displayName,
                        showPassword: $showPassword,
                        showConfirmPassword: $showConfirmPassword,
                        agreedToTerms: $agreedToTerms
                    )
                }
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !auth.awaitingEmailOTP {
                        Button("返回") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("注册中", isPresented: .constant(auth.errorMessage != nil)) {
            Button("确定") {
                auth.errorMessage = nil
            }
        } message: {
            if let error = auth.errorMessage {
                Text(error)
            }
        }
    }
}

// 注册表单视图
struct RegistrationFormView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var displayName: String
    @Binding var showPassword: Bool
    @Binding var showConfirmPassword: Bool
    @Binding var agreedToTerms: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // 输入表单
            VStack(spacing: 20) {
                // 昵称
                VStack(alignment: .leading, spacing: 8) {
                    Text("用户名")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("请输入用户名（唯一）", text: $displayName)
                        .textFieldStyle(ModernTextFieldStyle())
                        .textInputAutocapitalization(.never)
                    
                    // 提示文字
                    Text("用户名将用于登录，每个用户名都是唯一的")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 邮箱
                VStack(alignment: .leading, spacing: 8) {
                    Text("邮箱")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("请输入邮箱地址", text: $email)
                        .textFieldStyle(ModernTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                
                // 密码
                VStack(alignment: .leading, spacing: 8) {
                    Text("密码")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        if showPassword {
                            TextField("请输入密码", text: $password)
                                .textFieldStyle(ModernTextFieldStyle())
                        } else {
                            SecureField("请输入密码", text: $password)
                                .textFieldStyle(ModernTextFieldStyle())
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // 确认密码
                VStack(alignment: .leading, spacing: 8) {
                    Text("确认密码")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        if showConfirmPassword {
                            TextField("请再次输入密码", text: $confirmPassword)
                                .textFieldStyle(ModernTextFieldStyle())
                        } else {
                            SecureField("请再次输入密码", text: $confirmPassword)
                                .textFieldStyle(ModernTextFieldStyle())
                        }
                        
                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // 密码匹配提示
                    if !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("密码匹配")
                                    .foregroundColor(.green)
                                    .font(.caption)
                            }
                        } else {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("两次输入的密码不一致")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                // 用户协议
                HStack(spacing: 8) {
                    Button(action: {
                        agreedToTerms.toggle()
                    }) {
                        Image(systemName: agreedToTerms ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(agreedToTerms ? .blue : .gray)
                    }
                    
                    Text("我已阅读并同意")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button("《用户协议》") {
                        // TODO: 显示用户协议
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Button("《隐私政策》") {
                        // TODO: 显示隐私政策
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Button("《未成年人个人信息保护规则》") {
                        // TODO: 显示未成年人保护规则
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // 注册按钮
            Button(action: {
                Task {
                    await auth.startSignUp(email: email, password: password, displayName: displayName)
                }
            }) {
                Text(auth.isBusy ? "注册中..." : "注册")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(isSignUpButtonEnabled ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!isSignUpButtonEnabled)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
    
    private var isSignUpButtonEnabled: Bool {
        return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && 
               !displayName.isEmpty && password == confirmPassword && agreedToTerms && password.count >= 6
    }
}

// 邮箱验证视图
struct EmailVerificationView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    let email: String
    let displayName: String
    let onBack: () -> Void
    
    @State private var otpCode = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // 标题
            VStack(spacing: 8) {
                Text("验证邮箱")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("我们已向您的邮箱发送了验证码")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // 显示邮箱
                Text("邮箱: \(email)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            
            // 验证码输入
            VStack(spacing: 16) {
                Text("请输入6位验证码")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField("输入 6 位验证码", text: $otpCode)
                    .textFieldStyle(ModernTextFieldStyle())
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .frame(maxWidth: 200)
            }
            
            // 按钮
            VStack(spacing: 12) {
                Button(auth.isBusy ? "验证中..." : "验证并完成注册") {
                    Task {
                        await auth.verifyEmailOTP(otpCode.trimmingCharacters(in: .whitespaces))
                        // 如果验证成功，用户会自动登录，关闭注册页面
                        if auth.user != nil {
                            dismiss()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(otpCode.isEmpty || otpCode.count < 6 || auth.isBusy)
                
                Button("重发验证码") {
                    Task {
                        await auth.resendSignUpOTP()
                    }
                }
                .buttonStyle(.bordered)
                
                Button("返回修改") {
                    onBack()
                }
                .buttonStyle(.bordered)
            }
            
            // 错误提示
            if let error = auth.errorMessage, !error.isEmpty {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal, 24)
    }
}

// 扩展View以支持部分圆角
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 保持原有的其他表单（用于忘记密码等功能）
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
                    .textFieldStyle(ModernTextFieldStyle())
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
                    .textFieldStyle(ModernTextFieldStyle())
                
                SecureField("确认新密码", text: $confirmPassword)
                    .textFieldStyle(ModernTextFieldStyle())
                
                // 密码确认提示 - 只在第二次输入完成后才显示
                if !confirmPassword.isEmpty {
                    if newPassword == confirmPassword {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("密码匹配")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    } else {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("两次输入的新密码不一致")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
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

// 现代化输入框样式
struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
