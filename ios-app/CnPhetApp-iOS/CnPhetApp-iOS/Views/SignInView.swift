//
//  SignInView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
// Views/SignInView.swift
import SwiftUI

struct SignInView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?

    var body: some View {
        Form {
            Section("账号") {
                TextField("邮箱", text: $email).textInputAutocapitalization(.never)
                SecureField("密码", text: $password)
            }
            if let err = error {
                Text(err).foregroundColor(.red)
            }
            Button("登录") {
                Task {
                    do {
                        try await auth.signIn(email: email, password: password)
                    } catch {
                        self.error = error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.count < 6)
        }
        
        .navigationTitle("登录")
        
    }
}
