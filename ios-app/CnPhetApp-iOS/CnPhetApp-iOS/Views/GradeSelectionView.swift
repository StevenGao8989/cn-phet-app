//
//  GradeSelectionView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct GradeSelectionView: View {
    let subject: Subject
    @State private var selectedGrade: Grade?
    @State private var showGradeTopics = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            // 学科标题 - 居中
            HStack {
                Spacer()
                Text(subject.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            // 年级选择网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(Grade.allCases) { grade in
                    GradeCard(grade: grade) {
                        selectedGrade = grade
                        showGradeTopics = true
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("年级选择")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showGradeTopics) {
            if let grade = selectedGrade {
                GradeTopicsView(subject: subject, grade: grade)
            }
        }
    }
}

struct GradeCard: View {
    let grade: Grade
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                // 顶部图标
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(grade.title.prefix(1))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                // 年级名称
                VStack(spacing: 4) {
                    Text(grade.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(grade.englishTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        GradeSelectionView(subject: .physics)
    }
}
