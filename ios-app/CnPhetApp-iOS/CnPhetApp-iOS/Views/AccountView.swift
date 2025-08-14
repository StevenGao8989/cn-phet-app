//
//  AccountView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var newName = ""
    @State private var oldPwd = ""
    @State private var newPwd = ""
    @State private var newPwd2 = ""
    @State private var confirmPwdForDelete = ""
    @State private var showDeleteAlert = false

    var body: some View {
        Form {
            // 个人信息
            Section("个人信息") {
                HStack {
                    Text("邮箱")
                    Spacer()
                    Text(auth.accountEmail).foregroundStyle(.secondary)
                }
                HStack {
                    Text("昵称")
                    Spacer()
                    Text(auth.accountDisplayName.isEmpty ? "未设置" : auth.accountDisplayName)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    TextField("修改昵称", text: $newName)
                    Button("保存") {
                        Task { await auth.updateDisplayName(newName) }
                    }.disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }

            // 修改密码
            Section("修改密码") {
                SecureField("当前密码", text: $oldPwd)
                SecureField("新密码（≥6位）", text: $newPwd)
                SecureField("重复新密码", text: $newPwd2)
                Button(auth.isBusy ? "提交中…" : "确认修改") {
                    guard newPwd.count >= 6, newPwd == newPwd2 else { return }
                    Task { await auth.changePassword(current: oldPwd, to: newPwd) }
                }
                .disabled(oldPwd.isEmpty || newPwd.count < 6 || newPwd != newPwd2)
            }

            // 危险操作
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text("注销账号")
                }
            } footer: {
                Text("注销将删除你的登录账户（以及资料）。操作不可恢复。")
            }
        }
        .navigationTitle("账户")
        .alert("确认注销？", isPresented: $showDeleteAlert) {
            SecureField("请输入当前密码以确认", text: $confirmPwdForDelete)
            Button("取消", role: .cancel) { }
            Button("确认注销", role: .destructive) {
                Task { await auth.deleteAccount(confirmPassword: confirmPwdForDelete) }
            }
        } message: {
            Text("请输入当前密码确认。")
        }
        .overlay {
            if let msg = auth.errorMessage, !msg.isEmpty {
                Text(msg).foregroundStyle(.red).padding(.top, 8)
            }
        }
        .onAppear {
            newName = auth.accountDisplayName
        }
    }
}
