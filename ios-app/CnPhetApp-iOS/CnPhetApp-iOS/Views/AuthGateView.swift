//
//  AuthGateView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
import SwiftUI

struct AuthGateView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        Group {
            if auth.user != nil {
                HomeView()
            } else {
                // 使用新的统一认证页面
                AuthView()
            }
        }
    }
}

