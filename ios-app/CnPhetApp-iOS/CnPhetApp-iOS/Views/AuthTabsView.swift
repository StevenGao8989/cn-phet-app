//
//  AuthTabsView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
// Views/AuthTabsView.swift
import SwiftUI

struct AuthTabsView: View {
    @EnvironmentObject var auth: AuthViewModel
    var body: some View {
        TabView {
            SignInView().tabItem { Label("登录", systemImage: "person.crop.circle.badge.checkmark") }
            SignUpView().tabItem { Label("注册", systemImage: "person.badge.plus") }
        }
    }
}
