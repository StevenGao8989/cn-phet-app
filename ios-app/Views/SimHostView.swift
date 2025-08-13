//
//  SimHostView.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation
import SwiftUI

struct SimHostView: View {
    let topic: Topic
    var body: some View {
        switch topic.sim {
        case .projectile:
            ProjectileSimView(title: topic.title)
        default:
            VStack(spacing: 12) {
                Text(topic.title).font(.title3.bold())
                Text("这个模拟正在开发中…").foregroundStyle(.secondary)
            }
            .navigationTitle(topic.title)
        }
    }
}
