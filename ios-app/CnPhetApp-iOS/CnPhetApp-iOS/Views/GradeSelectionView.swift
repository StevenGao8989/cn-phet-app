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
        ScrollView {
            VStack(spacing: 24) {
                // 顶部学科标题区域
                VStack(spacing: 8) {
                    Text(subject.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                
                // 年级选择网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    ForEach(Grade.allCases) { grade in
                        GradeCard(grade: grade, subject: subject) {
                            selectedGrade = grade
                            showGradeTopics = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
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
    let subject: Subject
    let action: () -> Void
    
    // 根据学科获取主题色
    private var subjectColor: Color {
        switch subject {
        case .physics:
            return .blue
        case .chemistry:
            return .green
        case .math:
            return .orange
        case .biology:
            return .purple
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 20) {
                // 顶部图标
                ZStack {
                    Circle()
                        .fill(subjectColor.opacity(0.15))
                        .frame(width: 70, height: 70)
                    
                    Text(grade.title.prefix(1))
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(subjectColor)
                }
                
                // 年级名称
                VStack(spacing: 6) {
                    Text(grade.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(grade.englishTitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(subjectColor.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(0.98)
        .animation(.easeInOut(duration: 0.1), value: true)
    }
}

#Preview {
    NavigationStack {
        GradeSelectionView(subject: .physics)
    }
}
