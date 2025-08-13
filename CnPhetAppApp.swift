//
//  CnPhetAppApp.swift
//  
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
import SwiftUI

@main
struct CnPhetAppApp: App {
    @StateObject private var store = ContentStore()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .environmentObject(store)
            }
        }
    }
}
