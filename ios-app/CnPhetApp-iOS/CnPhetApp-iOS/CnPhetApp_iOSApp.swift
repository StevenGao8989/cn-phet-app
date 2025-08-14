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
        }
    }
}

