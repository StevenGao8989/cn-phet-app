//
//  PhysicsNavigationView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct PhysicsNavigationView: View {
    @State private var selectedSubject: Subject?
    @State private var showSubjectTopics = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 顶部标题
                HStack {
                    Text("交互公式实验室")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button("S") {
                        // 设置按钮
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.blue)
                    .clipShape(Circle())
                }
                .padding()
                
                // 学科选择按钮
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    SubjectCard(subject: .physics) {
                        selectedSubject = .physics
                        showSubjectTopics = true
                    }
                    
                    SubjectCard(subject: .chemistry) {
                        selectedSubject = .chemistry
                        showSubjectTopics = true
                    }
                    
                    SubjectCard(subject: .math) {
                        selectedSubject = .math
                        showSubjectTopics = true
                    }
                    
                    SubjectCard(subject: .biology) {
                        selectedSubject = .biology
                        showSubjectTopics = true
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("学科选择")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSubjectTopics) {
                if let subject = selectedSubject {
                    NavigationStack {
                        SubjectTopicsView(subject: subject)
                    }
                }
            }
        }
    }
}

#Preview {
    PhysicsNavigationView()
}
