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
    @StateObject private var favoritesManager = FavoritesManager()

    @State private var showProfileSheet = false
    @State private var showChangePwdSheet = false
    @State private var showDeleteAlert = false
    @State private var confirmPwdForDelete = ""
    @State private var selectedSubject: Subject?
    @State private var showGradeSelection = false

    // 先用昵称，其次邮箱，再兜底"我"
    private var displayText: String {
        if let n = auth.profile?.display_name, !n.isEmpty { return n }
        if let e = auth.user?.email, !e.isEmpty { return e }
        return "我"
    }
    private var avatarInitials: String { String(displayText.prefix(1)) }

    var body: some View {
        TabView {
            // 首页 Tab
            HomeTabView(
                selectedSubject: $selectedSubject,
                showGradeSelection: $showGradeSelection,
                showProfileSheet: $showProfileSheet,
                showChangePwdSheet: $showChangePwdSheet,
                showDeleteAlert: $showDeleteAlert,
                confirmPwdForDelete: $confirmPwdForDelete
            )
            .environmentObject(favoritesManager)
            .tabItem {
                Image(systemName: "house.fill")
                Text("首页")
            }
            
            // AI助手 Tab
            AIAssistantView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI助手")
                }
            
            // 我的 Tab
            ProfileView(
                showProfileSheet: $showProfileSheet,
                showChangePwdSheet: $showChangePwdSheet,
                showDeleteAlert: $showDeleteAlert,
                confirmPwdForDelete: $confirmPwdForDelete
            )
            .environmentObject(favoritesManager)
            .tabItem {
                Image(systemName: "person.fill")
                Text("我的")
            }
        }
        .onAppear {
            // 应用启动时刷新收藏数据
            Task {
                await favoritesManager.refreshForUser()
            }
        }
        .onChange(of: auth.user?.id) { oldValue, newValue in
            if newValue != nil {
                // 用户登录，刷新收藏数据
                Task {
                    await favoritesManager.refreshForUser()
                }
            } else {
                // 用户登出，清空收藏数据
                favoritesManager.clearForLogout()
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

// MARK: - 学科选择卡片
struct SubjectCard: View {
    let subject: Subject
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // 顶部图标
                ZStack {
                    Circle()
                        .fill(subject.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(subject.icon)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(subject.color)
                }
                
                // 学科名称
                VStack(spacing: 4) {
                    Text(subject.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subject.englishTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 扩展Subject枚举，添加颜色和图标属性
extension Subject {
    var color: Color {
        switch self {
        case .physics: return .blue
        case .chemistry: return .green
        case .math: return .yellow
        case .biology: return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .physics: return "物"
        case .chemistry: return "化"
        case .math: return "数"
        case .biology: return "生"
        }
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

// MARK: - 首页Tab视图
struct HomeTabView: View {
    @Binding var selectedSubject: Subject?
    @Binding var showGradeSelection: Bool
    @Binding var showProfileSheet: Bool
    @Binding var showChangePwdSheet: Bool
    @Binding var showDeleteAlert: Bool
    @Binding var confirmPwdForDelete: String
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showSignOutAlert = false
    @State private var searchText = ""
    @State private var showFavoritesSheet = false  // 添加收藏页面状态
    
    // 用户显示信息
    private var displayText: String {
        if let n = auth.profile?.display_name, !n.isEmpty { return n }
        if let e = auth.user?.email, !e.isEmpty { 
            // 从邮箱提取用户名（@符号前的部分）
            let components = e.components(separatedBy: "@")
            return components.first?.capitalized ?? e
        }
        return "StevenKo"
    }
    
    private var avatarInitials: String { 
        let name = displayText
        if name.count > 0 {
            return String(name.prefix(1)).uppercased()
        }
        return "S"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 顶部欢迎区域
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("欢迎回来")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Text(displayText)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        // 用户头像
                        Button(action: { showProfileSheet = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 50, height: 50)
                                
                                Text(avatarInitials)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 全局搜索框
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("搜索课程、实验、概念...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // 学科选择标题
                    HStack {
                        Text("选择学科")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Text("查看详细学程")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // 美化的学科卡片
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ModernSubjectCard(
                            title: "物理",
                            subtitle: "Physics", 
                            icon: "物",
                            color: .blue,
                            action: {
                                selectedSubject = .physics
                                showGradeSelection = true
                            }
                        )
                        
                        ModernSubjectCard(
                            title: "数学", 
                            subtitle: "Mathematics",
                            icon: "数",
                            color: .orange,
                            action: {
                                selectedSubject = .math
                                showGradeSelection = true
                            }
                        )
                        
                        ModernSubjectCard(
                            title: "化学",
                            subtitle: "Chemistry", 
                            icon: "化",
                            color: .green,
                            action: {
                                selectedSubject = .chemistry
                                showGradeSelection = true
                            }
                        )
                        
                        ModernSubjectCard(
                            title: "生物",
                            subtitle: "Biology", 
                            icon: "生",
                            color: .purple,
                            action: {
                                selectedSubject = .biology
                                showGradeSelection = true
                            }
                        )
                    }
                    .padding(.horizontal)
                    
                    // 快速操作区域
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("快速操作")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 20) {
                            QuickActionButton(
                                icon: "star.fill",
                                title: "收藏",
                                color: .orange,
                                action: { showFavoritesSheet = true }
                            )
                            
                            QuickActionButton(
                                icon: "info.circle.fill", 
                                title: "帮助",
                                color: .blue,
                                action: {}
                            )
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showGradeSelection) {
                if let subject = selectedSubject {
                    GradeSelectionView(subject: subject)
                }
            }
        }
        .alert("确认退出登录？", isPresented: $showSignOutAlert) {
            Button("取消", role: .cancel) { }
            Button("确认退出", role: .destructive) {
                auth.signOutFromUI()
            }
        }
        .sheet(isPresented: $showFavoritesSheet) {
            FavoritesView()
                .environmentObject(favoritesManager)
        }
    }
}

// MARK: - AI助手视图
struct AIAssistantView: View {
    var body: some View {
        AIChatView()
    }
}

// MARK: - 个人资料视图
struct ProfileView: View {
    @Binding var showProfileSheet: Bool
    @Binding var showChangePwdSheet: Bool
    @Binding var showDeleteAlert: Bool
    @Binding var confirmPwdForDelete: String
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showSignOutAlert = false  // 添加退出登录确认状态
    @State private var showFavoritesSheet = false  // 添加收藏页面状态
    @State private var showSubscriptionSheet = false  // 添加订阅页面状态
    
    // 先用昵称，其次邮箱，再兜底"我"
    private var displayText: String {
        if let n = auth.profile?.display_name, !n.isEmpty { return n }
        if let e = auth.user?.email, !e.isEmpty { return e }
        return "我"
    }
    private var avatarInitials: String { String(displayText.prefix(1)) }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 头像和用户信息
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 100, height: 100)
                        
                        Text(avatarInitials)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text(displayText)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let email = auth.user?.email {
                        Text(email)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                
                // 功能按钮列表
                VStack(spacing: 0) {
                    Button(action: { showProfileSheet = true }) {
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.blue)
                            Text("个人信息")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    Button(action: { showChangePwdSheet = true }) {
                        HStack {
                            Image(systemName: "lock.circle")
                                .foregroundColor(.green)
                            Text("修改密码")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    Button(action: { showFavoritesSheet = true }) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                            Text("我的收藏")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    Button(action: { showSubscriptionSheet = true }) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("订阅管理")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    Button(action: { showSignOutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.orange)
                            Text("退出登录")
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    Button(action: { showDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash.circle")
                                .foregroundColor(.red)
                            Text("注销账号")
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showFavoritesSheet) {
            FavoritesView()
                .environmentObject(favoritesManager)
        }
        .sheet(isPresented: $showSubscriptionSheet) {
            SubscriptionView()
        }
        .alert("确认退出登录？", isPresented: $showSignOutAlert) {
            Button("取消", role: .cancel) { }
            Button("确认退出", role: .destructive) {
                auth.signOutFromUI()
            }
        }
    }
}

// MARK: - AI问答相关代码

struct ChatResponse: Codable {
    let reply: String
}

struct Conversation: Identifiable {
    let id = UUID()
    let userMessage: String
    var aiMessage: String?
    let timestamp: Date = Date()
}

class AIViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var input: String = ""
    @Published var isLoading = false

    func sendMessage() {
        guard !input.isEmpty else { return }
        let userMessage = input
        
        // 创建新的对话，先只有用户消息
        let newConversation = Conversation(userMessage: userMessage, aiMessage: nil)
        conversations.append(newConversation) // 添加到数组末尾，保持历史顺序
        
        input = ""
        isLoading = true

        // 这里换成你自己 Supabase Function 的地址
        let url = URL(string: "https://yveexbmtnlnsfwrpumgy.supabase.co/functions/v1/ask-qwen")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 添加Supabase认证头
        request.addValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(AppConfig.supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        
        // 请求体
        let body: [String: Any] = ["prompt": userMessage]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // 发起请求
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                // 找到刚创建的对话并更新AI回答
                if let index = self.conversations.firstIndex(where: { $0.id == newConversation.id }) {
                    var updatedConversation = self.conversations[index]
                    
                    if let error = error {
                        updatedConversation.aiMessage = "（网络错误：\(error.localizedDescription)）"
                    } else if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP状态码: \(httpResponse.statusCode)")
                        if httpResponse.statusCode != 200 {
                            updatedConversation.aiMessage = "（服务器错误：状态码 \(httpResponse.statusCode)）"
                        } else if let data = data {
                            // 打印原始响应数据用于调试
                            if let responseString = String(data: data, encoding: .utf8) {
                                print("原始响应: \(responseString)")
                            }
                            
                            if let response = try? JSONDecoder().decode(ChatResponse.self, from: data) {
                                updatedConversation.aiMessage = response.reply
                            } else {
                                updatedConversation.aiMessage = "（解析失败，请检查响应格式）"
                            }
                        } else {
                            updatedConversation.aiMessage = "（没有收到数据）"
                        }
                    }
                    
                    self.conversations[index] = updatedConversation
                }
            }
        }.resume()
    }
}

struct AIChatView: View {
    @StateObject var vm = AIViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 主要聊天区域
                if vm.conversations.isEmpty {
                    // 欢迎界面
                    VStack(spacing: 24) {
                        Spacer()
                        
                        // DeepSeek 图标
                        ZStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 16) {
                            Text("嗨！我是 AI理科助手小高")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("我可以帮你搜索、答疑、计算、 制作动画模型，请把你的任务交给我吧～")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    // 对话列表
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(vm.conversations) { conversation in
                                    ConversationView(conversation: conversation)
                                        .id(conversation.id)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                        .onChange(of: vm.conversations.count) { oldValue, newValue in
                            // 当有新对话时，自动滚动到底部
                            if let lastConversation = vm.conversations.last {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo(lastConversation.id, anchor: .bottom)
                                }
                            }
                        }
                        .onAppear {
                            // 页面加载时滚动到底部
                            if let lastConversation = vm.conversations.last {
                                proxy.scrollTo(lastConversation.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 输入区域
                VStack(spacing: 12) {
                    // 输入框
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            TextField("给 AI小高 发送消息", text: $vm.input)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(.horizontal, 16)
                                .onSubmit {
                                    vm.sendMessage()
                                }
                                .padding(.vertical, 12)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                        
                        Button(action: {
                            vm.sendMessage()
                        }) {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 32, height: 32)
                        .background(vm.input.isEmpty || vm.isLoading ? Color.gray : Color.blue)
                        .clipShape(Circle())
                        .disabled(vm.input.isEmpty || vm.isLoading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                .background(Color(.systemBackground))
            }
            .navigationTitle("新对话")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // 侧边栏按钮
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 新对话按钮
                        vm.conversations = []
                        vm.input = ""
                    }) {
                        Image(systemName: "plus.message")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// 对话视图
struct ConversationView: View {
    let conversation: Conversation
    
    var body: some View {
        VStack(spacing: 12) {
            // 用户消息
            HStack {
                Spacer()
                Text(conversation.userMessage)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .frame(maxWidth: .infinity * 0.8, alignment: .trailing)
            }
            
            // AI回答
            if let aiMessage = conversation.aiMessage {
                HStack(alignment: .top, spacing: 12) {
                    // AI头像
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 32, height: 32)
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI小高")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Text(aiMessage)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .foregroundColor(.primary)
                            .cornerRadius(16)
                            .frame(maxWidth: .infinity * 0.8, alignment: .leading)
                    }
                    
                    Spacer()
                }
            } else {
                // 等待AI回答
                HStack(alignment: .top, spacing: 12) {
                    // AI头像
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 32, height: 32)
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI小高")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                                .scaleEffect(0.8)
                            Text("正在拼命思考...")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - 收藏视图
struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        NavigationStack {
            Group {
                if favoritesManager.isLoading {
                    ProgressView("加载收藏中...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if favoritesManager.favorites.isEmpty {
                    VStack {
                        Image(systemName: "heart")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("还没有收藏的内容")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("在知识点列表中点击心形图标来收藏")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(favoritesManager.favorites) { item in
                            FavoriteRowView(item: item)
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                }
            }
            .navigationTitle("我的收藏")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func deleteFavorites(offsets: IndexSet) {
        let itemsToDelete = offsets.map { favoritesManager.favorites[$0] }
        for item in itemsToDelete {
            Task {
                await favoritesManager.removeFromFavorites(topicId: item.topicId)
            }
        }
    }
}

// MARK: - 订阅视图
struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subscriptions: [SubscriptionItem] = [
        SubscriptionItem(title: "物理学习周刊", status: .active, nextRenewal: Date().addingTimeInterval(7 * 24 * 3600)),
        SubscriptionItem(title: "化学实验视频", status: .expired, nextRenewal: Date().addingTimeInterval(-1 * 24 * 3600)),
        SubscriptionItem(title: "数学思维训练", status: .active, nextRenewal: Date().addingTimeInterval(30 * 24 * 3600))
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(subscriptions) { item in
                    SubscriptionRowView(item: item)
                }
            }
            .navigationTitle("订阅管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("管理") {
                        // 这里可以添加订阅管理逻辑
                    }
                }
            }
        }
    }
}

// MARK: - 收藏项目模型
struct FavoriteItem: Identifiable, Codable {
    let id: UUID
    let userId: UUID?
    let title: String
    let subject: String
    let grade: String
    let timestamp: Date
    let topicId: String
    let description: String?
    
    // 数据库字段映射
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case subject
        case grade
        case timestamp = "created_at"
        case topicId = "topic_id"
        case description
    }
    
    // 自定义日期解码器
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decodeIfPresent(UUID.self, forKey: .userId)
        title = try container.decode(String.self, forKey: .title)
        subject = try container.decode(String.self, forKey: .subject)
        grade = try container.decode(String.self, forKey: .grade)
        topicId = try container.decode(String.self, forKey: .topicId)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        // 自定义日期解析
        let dateString = try container.decode(String.self, forKey: .timestamp)
        
        // 尝试多种日期格式
        let formatters: [DateFormatter] = [
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                formatter.timeZone = TimeZone.current
                return formatter
            }(),
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
                formatter.timeZone = TimeZone.current
                return formatter
            }(),
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                return formatter
            }(),
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                return formatter
            }()
        ]
        
        var parsedDate: Date?
        for formatter in formatters {
            if let date = formatter.date(from: dateString) {
                parsedDate = date
                break
            }
        }
        
        if let date = parsedDate {
            timestamp = date
        } else {
            // 如果所有格式都失败，使用当前时间作为兜底
            print("无法解析日期格式: \(dateString), 使用当前时间")
            timestamp = Date()
        }
    }
    
    // 创建新收藏项目的便利初始化器
    init(title: String, subject: String, grade: String, topicId: String, description: String? = nil, userId: UUID? = nil) {
        self.id = UUID()
        self.userId = userId
        self.title = title
        self.subject = subject
        self.grade = grade
        self.timestamp = Date()
        self.topicId = topicId
        self.description = description
    }
    
    // 从数据库加载的完整初始化器
    init(id: UUID, userId: UUID?, title: String, subject: String, grade: String, timestamp: Date, topicId: String, description: String?) {
        self.id = id
        self.userId = userId
        self.title = title
        self.subject = subject
        self.grade = grade
        self.timestamp = timestamp
        self.topicId = topicId
        self.description = description
    }
}

// MARK: - 收藏管理器
@MainActor
class FavoritesManager: ObservableObject {
    @Published var favorites: [FavoriteItem] = []
    @Published var isLoading = false
    
    private let supabaseClient = SupabaseService.shared.client
    private func getCurrentUserId() async -> UUID? {
        // 使用SupabaseService来获取当前用户ID
        do {
            let session = try await SupabaseService.shared.client.auth.session
            return session.user.id
        } catch {
            print("获取当前用户失败: \(error)")
            return nil
        }
    }
    
    init() {
        Task {
            await loadFavorites()
        }
    }
    
    // MARK: - 云端同步方法
    
    /// 从云端加载收藏数据
    func loadFavorites() async {
        guard await getCurrentUserId() != nil else {
            print("用户未登录，无法加载收藏")
            return
        }
        
        isLoading = true
        
        do {
            let response: [FavoriteItem] = try await supabaseClient.database
                .from("user_favorites")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            favorites = response
            print("成功加载 \(response.count) 个收藏项目")
        } catch {
            print("加载收藏失败: \(error)")
        }
        
        isLoading = false
    }
    
    /// 添加收藏到云端
    func addToFavorites(_ item: FavoriteItem) async {
        guard let userId = await getCurrentUserId() else {
            print("用户未登录，无法添加收藏")
            return
        }
        
        // 检查是否已经收藏
        if isFavorite(topicId: item.topicId) {
            return
        }
        
        // 创建带有用户ID的收藏项目
        let favoriteWithUserId = FavoriteItem(
            title: item.title,
            subject: item.subject,
            grade: item.grade,
            topicId: item.topicId,
            description: item.description,
            userId: userId
        )
        
        do {
            let response: [FavoriteItem] = try await supabaseClient.database
                .from("user_favorites")
                .insert(favoriteWithUserId)
                .select()
                .execute()
                .value
            
            if let newFavorite = response.first {
                favorites.insert(newFavorite, at: 0) // 添加到列表顶部
                print("成功添加收藏: \(item.title)")
            }
        } catch {
            print("添加收藏失败: \(error)")
        }
    }
    
    /// 从云端删除收藏
    func removeFromFavorites(topicId: String) async {
        guard await getCurrentUserId() != nil else {
            print("用户未登录，无法删除收藏")
            return
        }
        
        do {
            try await supabaseClient.database
                .from("user_favorites")
                .delete()
                .eq("topic_id", value: topicId)
                .execute()
            
            // 从本地列表中移除
            favorites.removeAll { $0.topicId == topicId }
            print("成功删除收藏: \(topicId)")
        } catch {
            print("删除收藏失败: \(error)")
        }
    }
    
    /// 切换收藏状态
    func toggleFavorite(_ item: FavoriteItem) async {
        if isFavorite(topicId: item.topicId) {
            await removeFromFavorites(topicId: item.topicId)
        } else {
            await addToFavorites(item)
        }
    }
    
    // MARK: - 本地查询方法
    
    func isFavorite(topicId: String) -> Bool {
        return favorites.contains { $0.topicId == topicId }
    }
    
    /// 用户登录后刷新收藏数据
    func refreshForUser() async {
        await loadFavorites()
    }
    
    /// 用户登出后清空收藏数据
    func clearForLogout() {
        favorites = []
    }
}

// MARK: - 订阅项目模型
struct SubscriptionItem: Identifiable {
    let id = UUID()
    let title: String
    let status: SubscriptionStatus
    let nextRenewal: Date
}

// MARK: - 订阅状态枚举
enum SubscriptionStatus: String, CaseIterable {
    case active = "活跃"
    case expired = "已过期"
    case pending = "待激活"
    
    var color: Color {
        switch self {
        case .active:
            return .green
        case .expired:
            return .red
        case .pending:
            return .orange
        }
    }
}

// MARK: - 收藏行视图
struct FavoriteRowView: View {
    let item: FavoriteItem
    
    var body: some View {
        NavigationLink(destination: getSimulatorDestination(for: item)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(item.subject)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                
                HStack {
                    Text(item.grade)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                if let description = item.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // 根据收藏项目获取模拟器目标
    @ViewBuilder
    private func getSimulatorDestination(for favoriteItem: FavoriteItem) -> some View {
        let topicId = favoriteItem.topicId
        switch topicId {
        case "projectile_motion":
            ProjectileSimView(title: favoriteItem.title)
        case "geometric_optics":
            // 这里可以添加几何光学的模拟器
            Text("几何光学模拟器")
                .navigationTitle(favoriteItem.title)
        case "chemical_equations":
            // 这里可以添加化学方程式的模拟器
            Text("化学方程式模拟器")
                .navigationTitle(favoriteItem.title)
        default:
            // 默认显示一个通用页面
            Text("模拟器开发中...")
                .navigationTitle(favoriteItem.title)
        }
    }
}

// MARK: - 订阅行视图
struct SubscriptionRowView: View {
    let item: SubscriptionItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(item.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.status.color.opacity(0.2))
                    .foregroundColor(item.status.color)
                    .cornerRadius(8)
            }
            
            HStack {
                Text("下次续费: \(item.nextRenewal, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                if item.status == .expired {
                    Button("续费") {
                        // 这里可以添加续费逻辑
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 现代化学科卡片
struct ModernSubjectCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // 图标背景
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(icon)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                }
                
                // 文字内容
                VStack(spacing: 4) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - 快速操作按钮
struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

