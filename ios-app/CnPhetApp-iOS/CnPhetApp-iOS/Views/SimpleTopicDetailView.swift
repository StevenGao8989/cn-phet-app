//
//  SimpleTopicDetailView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct SimpleTopicDetailView: View {
    let topic: GradeTopic
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 顶部信息卡片
                VStack(spacing: 16) {
                    // 知识点图标和标题
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Text(topic.icon)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 8) {
                                Text(topic.subtitle)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                                
                                Text(topic.difficulty)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(difficultyColor.opacity(0.2))
                                    .foregroundColor(difficultyColor)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    // 描述
                    if !topic.description.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("知识点描述")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text(topic.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // 学习建议
                VStack(alignment: .leading, spacing: 12) {
                    Text("学习建议")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ConcreteLearningTipRow(
                            icon: "lightbulb.fill",
                            color: .yellow,
                            title: "理解概念",
                            description: "先理解基本概念和定义，建立知识框架"
                        )
                        
                        ConcreteLearningTipRow(
                            icon: "flask.fill",
                            color: .green,
                            title: "实验验证",
                            description: "通过实验验证理论，加深理解"
                        )
                        
                        ConcreteLearningTipRow(
                            icon: "pencil.circle.fill",
                            color: .blue,
                            title: "练习应用",
                            description: "多做练习题，掌握应用方法"
                        )
                        
                        ConcreteLearningTipRow(
                            icon: "book.fill",
                            color: .purple,
                            title: "拓展阅读",
                            description: "阅读相关材料，拓展知识面"
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // 相关资源
                VStack(alignment: .leading, spacing: 12) {
                    Text("相关资源")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ResourceRow(
                            icon: "play.circle.fill",
                            color: .blue,
                            title: "视频讲解",
                            description: "观看相关视频，理解知识点"
                        )
                        
                        ResourceRow(
                            icon: "doc.text.fill",
                            color: .green,
                            title: "文档资料",
                            description: "阅读详细文档，深入学习"
                        )
                        
                        ResourceRow(
                            icon: "gamecontroller.fill",
                            color: .orange,
                            title: "互动实验",
                            description: "参与互动实验，动手实践"
                        )
                        
                        ResourceRow(
                            icon: "questionmark.circle.fill",
                            color: .red,
                            title: "在线答疑",
                            description: "遇到问题，在线寻求帮助"
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("开始学习") {
                    // 这里可以跳转到对应的模拟器或学习内容
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private var difficultyColor: Color {
        switch topic.difficulty {
        case "基础": return .green
        case "中等": return .orange
        case "高级": return .red
        default: return .blue
        }
    }
}



struct ResourceRow: View {
    let icon: String
    let color: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    let sampleTopic = GradeTopic(
        id: "uniform_motion",
        title: "匀速直线运动",
        subtitle: "物理",
        icon: "物",
        description: "基础力学概念和运动规律，包括速度、位移、时间等基本概念",
        difficulty: "基础"
    )
    
    NavigationStack {
        SimpleTopicDetailView(topic: sampleTopic)
    }
}
