//
//  HomeView.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: ContentStore
    var body: some View {
        VStack {
            // 学科筛选
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Button("全部") { store.filter = nil }
                        .buttonStyle(.borderedProminent)
                    ForEach(Subject.allCases) { s in
                        Button(s.title) { store.filter = s }
                            .buttonStyle(.bordered)
                            .tint(store.filter == s ? .accentColor : .secondary)
                    }
                }.padding(.horizontal)
            }.padding(.top, 8)

            List(store.visibleTopics) { topic in
                NavigationLink(value: topic) {
                    TopicRow(topic: topic)
                }
            }
            .navigationDestination(for: Topic.self) { topic in
                SimHostView(topic: topic)
            }
            .navigationTitle("交互公式实验室")
        }
    }
}
