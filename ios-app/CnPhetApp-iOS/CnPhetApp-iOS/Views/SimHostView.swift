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
            VStack(spacing: 20) {
                Image(systemName: "flask.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text(topic.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("该知识点的模拟器正在开发中...")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationTitle(topic.title)
        }
    }
}
