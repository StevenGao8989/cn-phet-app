//
//  SignUpView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
// Views/SignUpView.swift
import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var code = ""

    var body: some View {
        Form {
            if auth.awaitingEmailOTP {
                Section("邮箱验证") {
                    Text("验证码已发送至：\(auth.pendingEmail ?? email)")
                        .font(.footnote)
                    TextField("输入 6 位验证码", text: $code)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.never)
                }
                if let err = auth.errorMessage, !err.isEmpty {
                    Text(err).foregroundColor(.red)
                }
                HStack {
                    Button("返回修改邮箱") { auth.cancelPendingSignup() }
                    Spacer()
                    Button("重发验证码") {
                        Task { await auth.resendForgotPasswordOTP() }
                    }
                    Button("验证并完成注册") {
                        Task { await auth.verifyEmailOTP(code.trimmingCharacters(in: .whitespaces)) }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(code.trimmingCharacters(in: .whitespaces).count < 6)
                }
            } else {
                Section("资料") {
                    TextField("昵称（可选）", text: $name)
                    TextField("邮箱", text: $email).textInputAutocapitalization(.never)
                    SecureField("密码（≥6 位）", text: $password)
                }
                if let err = auth.errorMessage, !err.isEmpty {
                    Text(err).foregroundColor(.red)
                }
                Button(auth.isBusy ? "提交中…" : "注册（将发送验证码）") {
                    Task { await auth.startSignUp(email: email, password: password, displayName: name) }
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.count < 6)
            }
        }
        .navigationTitle("注册")
    }
}
