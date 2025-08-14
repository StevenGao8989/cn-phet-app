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
                    if selectedTab == 0 {
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
    
    var body: some View {
        VStack(spacing: 20) {
            // 输入字段
            VStack(spacing: 16) {
                TextField("用户名", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("密码", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
                            Task { await auth.resendEmailOTP() }
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

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
