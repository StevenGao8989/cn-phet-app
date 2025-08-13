//
//  AuthGateView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
// Views/AuthGateView.swift
import SwiftUI

struct AuthGateView: View {
    @StateObject private var auth  = AuthViewModel()
    @StateObject private var store = ContentStore()

    var body: some View {
        Group {
            if auth.user != nil {
                NavigationStack {                    // ← 加这一层
                    HomeView()
                        .environmentObject(store)
                        .toolbar {
                            Menu {
                                if let name = auth.profile?.display_name, !name.isEmpty {
                                    Text("你好，\(name)")
                                }
                                Button("退出登录") { Task { try? await auth.signOut() } }
                            } label: {
                                Image(systemName: "person.circle")
                            }
                        }
                }
            } else {
                AuthTabsView()
                    .environmentObject(auth)
            }
        }
        .environmentObject(auth) // 让子视图也能拿到 auth（可选）
    }
}

