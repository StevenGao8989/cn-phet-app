//
//  HomeView.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: ContentStore
    @EnvironmentObject var auth: AuthViewModel

    @State private var showProfileSheet = false
    @State private var showChangePwdSheet = false
    @State private var showDeleteAlert = false
    @State private var confirmPwdForDelete = ""

    // 先用昵称，其次邮箱，再兜底“我”
    private var displayText: String {
        if let n = auth.profile?.display_name, !n.isEmpty { return n }
        if let e = auth.user?.email, !e.isEmpty { return e }
        return "我"
    }
    private var avatarInitials: String { String(displayText.prefix(1)) }

    var body: some View {
        NavigationStack {
            VStack {
                SubjectsBar(filter: $store.filter)
                TopicsList(topics: store.visibleTopics)
            }
            .navigationDestination(for: Topic.self) { topic in
                SimHostView(topic: topic)
            }
            .navigationTitle("交互公式实验室")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("查看个人信息") { showProfileSheet = true }
                        Button("修改密码")   { showChangePwdSheet = true }
                        Divider()

                        Divider()
                        Button("退出登录", role: .destructive) {
                            auth.signOutFromUI()
                        }
                        Button("注销账号", role: .destructive) {
                            showDeleteAlert = true
                        }
                    } label: {
                        AvatarView(initials: avatarInitials)
                    }
                }
            }
            .alert("确认注销？", isPresented: $showDeleteAlert) {
                SecureField("请输入当前密码以确认", text: $confirmPwdForDelete)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .privacySensitive()
                Button("取消", role: .cancel) { }
                // 注销确认里
                Button("确认注销", role: .destructive) {
                    auth.deleteAccountFromUI(confirmPassword: confirmPwdForDelete)
                }
            } message: {
                Text("此操作不可恢复，将删除你的登录账户与资料。")
            }
            .overlay(alignment: .top) {
                if let msg = auth.banner {
                    BannerView(text: msg).padding(.top, 8)
                }
            }
            // 这两个 Sheet 不再额外传 environmentObject，避免类型推断开销
            .sheet(isPresented: $showProfileSheet) { ProfileSheetView() }
            .sheet(isPresented: $showChangePwdSheet) { ChangePasswordSheetView() }
        }
    }
}

// MARK: - 顶部学科筛选条（拆分成独立视图，降低复杂度）
private struct SubjectsBar: View {
    @Binding var filter: Subject?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button("全部") { filter = nil }
                    .buttonStyle(.borderedProminent)
                // 如果 Subject 遵循 Hashable（一般枚举都可以），显式 id 可减轻推断
                ForEach(Subject.allCases, id: \.self) { s in
                    Button(s.title) { filter = s }
                        .buttonStyle(.bordered)
                        .tint(filter == s ? .accentColor : .secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

// MARK: - 主题列表（独立视图）
private struct TopicsList: View {
    let topics: [Topic]
    var body: some View {
        List(topics) { topic in
            NavigationLink(value: topic) { TopicRow(topic: topic) }
        }
        .listStyle(.plain)
    }
}

// MARK: - 头像 & 顶部提示（跟之前一致）
struct AvatarView: View {
    var initials: String
    var body: some View {
        ZStack {
            Circle().fill(Color.blue)
            Text(initials).foregroundStyle(.white).font(.callout).bold()
        }
        .frame(width: 28, height: 28)
        .accessibilityLabel("账户")
    }
}

struct BannerView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThickMaterial)
            .clipShape(Capsule())
            .shadow(radius: 2)
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// 个人信息（最小实现，显示邮箱 + 改昵称）
struct ProfileSheetView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("邮箱"); Spacer()
                    Text(auth.user?.email ?? auth.profile?.email ?? "-")
                        .foregroundStyle(.secondary)
                }
                Section("昵称") {
                    TextField("请输入昵称", text: $name)
                    Button("保存") {
                        Task { await auth.updateDisplayName(name); dismiss() }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("个人信息")
            .onAppear { name = auth.profile?.display_name ?? "" }
        }
        .presentationDetents([.medium, .large])
    }
}

// 修改密码（完善版）
struct ChangePasswordSheetView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var oldPwd = ""
    @State private var newPwd = ""
    @State private var newPwd2 = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("当前密码") {
                    SecureField("当前密码", text: $oldPwd)
                        .textContentType(.password)
                        .privacySensitive()
                }
                Section("新密码") {
                    SecureField("新密码（≥6位）", text: $newPwd)
                        .textContentType(.password)
                        .privacySensitive()
                    
                    SecureField("重复新密码", text: $newPwd2)
                        .textContentType(.password)
                        .privacySensitive()
                    
                    // 密码确认提示 - 只在第二次输入完成后才显示
                    if !newPwd2.isEmpty {
                        if newPwd == newPwd2 {
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
                
                Button("确认修改") {
                    Task {
                        await validateAndChangePassword()
                    }
                }
                .disabled(oldPwd.isEmpty || newPwd.count < 6 || newPwd != newPwd2)
            }
            .navigationTitle("修改密码")
            .alert("修改密码", isPresented: $showErrorAlert) {
                Button("确定") { }
            } message: {
                Text(errorMessage)
            }
        }
        .presentationDetents([.medium, .large])
    }
    
    // 验证并修改密码
    private func validateAndChangePassword() async {
        // 验证新密码一致性
        guard newPwd == newPwd2 else {
            errorMessage = "新密码与重复新密码不一致，请检查后重试。"
            showErrorAlert = true
            return
        }
        
        // 验证新密码长度
        guard newPwd.count >= 6 else {
            errorMessage = "新密码长度至少6位，请检查后重试。"
            showErrorAlert = true
            return
        }
        
        // 调用修改密码方法
        await auth.changePassword(current: oldPwd, to: newPwd)
        
        // 检查是否有错误
        if let error = auth.errorMessage, !error.isEmpty {
            errorMessage = error
            showErrorAlert = true
        } else {
            // 成功修改，关闭界面
            dismiss()
        }
    }
    

    

}
