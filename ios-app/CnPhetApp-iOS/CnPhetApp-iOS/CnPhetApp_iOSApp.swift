//
//  CnPhetApp_iOSApp.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import SwiftUI

@main
struct CnPhetApp_iOSApp: App {
    @StateObject private var store = ContentStore()
    @StateObject private var auth  = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            AuthGateView()
                .environmentObject(store)
                .environmentObject(auth)
                .onOpenURL { url in
                    print("🚀 应用通过 URL 打开: \(url)")
                    handlePasswordResetURL(url)
                }
                .onAppear {
                    print("🚀 应用启动")
                    // 检查是否有待处理的 URL
                    if let url = UserDefaults.standard.url(forKey: "pendingPasswordResetURL") {
                        print("🔄 发现待处理的密码重置 URL: \(url)")
                        UserDefaults.standard.removeObject(forKey: "pendingPasswordResetURL")
                        handlePasswordResetURL(url)
                    }
                }
        }
    }
    
    private func handlePasswordResetURL(_ url: URL) {
        print("🔗 收到 URL 回调: \(url)")
        print("🔗 URL 绝对路径: \(url.absoluteString)")
        
        // 检查是否是密码重置链接
        if url.absoluteString.contains("cnphetapp://auth/reset-password") {
            print("✅ 检测到密码重置链接")
            
            // 解析 URL 参数
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let queryItems = components.queryItems else {
                print("❌ 无法解析 URL 参数")
                return
            }
            
            print("🔍 查询参数数量: \(queryItems.count)")
            for item in queryItems {
                print("🔍 参数: \(item.name) = \(item.value ?? "nil")")
            }
            
            // 查找密码重置相关参数
            var token: String?
            var email: String?
            
            for item in queryItems {
                if item.name == "token" {
                    token = item.value
                    print("✅ 找到 token: \(item.value ?? "nil")")
                } else if item.name == "email" {
                    email = item.value
                    print("✅ 找到 email: \(item.value ?? "nil")")
                }
            }
            
            // 如果找到了必要的参数，触发密码重置流程
            if let token = token, let email = email {
                print("🔄 开始密码重置流程")
                print("📝 Token: \(token)")
                print("📝 Email: \(email)")
                
                Task { @MainActor in
                    print("🔄 调用 auth.handlePasswordReset")
                    auth.handlePasswordReset(token: token, email: email)
                    print("✅ 密码重置流程已启动")
                }
            } else {
                print("❌ 缺少必要的参数")
                if token == nil { print("❌ 缺少 token") }
                if email == nil { print("❌ 缺少 email") }
            }
        } else {
            print("❌ 不是密码重置链接")
        }
    }
    
    private func extractEmailFromURL(_ url: URL) -> String? {
        // 尝试从 URL 中提取邮箱地址
        let urlString = url.absoluteString
        
        // 常见的邮箱提取模式
        if let emailRange = urlString.range(of: "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}", options: .regularExpression) {
            return String(urlString[emailRange])
        }
        
        // 如果正则表达式失败，尝试从查询参数中获取
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let queryItems = components.queryItems {
            for item in queryItems {
                if item.name == "email" {
                    return item.value
                }
            }
        }
        
        return nil
    }
}

