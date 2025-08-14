//
//  AuthTabsView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import SwiftUI

struct AuthTabsView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("首页", systemImage: "house") }

            //NavigationStack { AccountView() }
              //  .tabItem { Label("我", systemImage: "person.circle") }
        }
    }
}

