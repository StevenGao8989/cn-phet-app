//
//  SubjectTopicsView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct SubjectTopicsView: View {
    let subject: Subject
    @State private var topics: [SubjectTopic] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题
            HStack {
                Text(subject.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            // 知识点列表
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("正在加载知识点...")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if topics.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("暂无知识点")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("该学科暂未配置知识点")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(topics) { topic in
                    NavigationLink(value: topic) {
                        SubjectTopicRow(topic: topic)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(subject.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: SubjectTopic.self) { topic in
            SubjectTopicDetailView(topic: topic)
        }
        .onAppear {
            loadTopics()
        }
    }
    
    private func loadTopics() {
        isLoading = true
        
        // 根据学科加载对应的知识点
        topics = getTopicsForSubject(subject)
        isLoading = false
        
        print("📚 加载学科 \(subject.title) 的知识点")
        print("📊 找到 \(topics.count) 个知识点")
    }
    
    private func getTopicsForSubject(_ subject: Subject) -> [SubjectTopic] {
        switch subject {
        case .physics:
            return [
                SubjectTopic(
                    id: "projectile_motion",
                    title: "抛体运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "物体在重力作用下的曲线运动",
                    difficulty: "中等"
                ),
                SubjectTopic(
                    id: "free_fall",
                    title: "自由落体",
                    subtitle: "物理",
                    icon: "物",
                    description: "物体在重力作用下自由下落",
                    difficulty: "基础"
                ),
                SubjectTopic(
                    id: "lens_imaging",
                    title: "透镜成像",
                    subtitle: "物理",
                    icon: "物",
                    description: "凸透镜和凹透镜的成像规律",
                    difficulty: "中等"
                ),
                SubjectTopic(
                    id: "ohm_law",
                    title: "欧姆定律",
                    subtitle: "物理",
                    icon: "物",
                    description: "电流、电压、电阻之间的关系",
                    difficulty: "基础"
                )
            ]
            
        case .math:
            return [
                SubjectTopic(
                    id: "linear_function",
                    title: "一次函数 y=kx+b",
                    subtitle: "数学",
                    icon: "数",
                    description: "线性函数的基本性质和图像",
                    difficulty: "基础"
                ),
                SubjectTopic(
                    id: "quadratic_function",
                    title: "二次函数 y=ax²+bx+c",
                    subtitle: "数学",
                    icon: "数",
                    description: "二次函数的图像和性质",
                    difficulty: "中等"
                ),
                SubjectTopic(
                    id: "trigonometric_function",
                    title: "三角函数 y=A·sin(ωx+φ)",
                    subtitle: "数学",
                    icon: "数",
                    description: "正弦函数的图像和变换",
                    difficulty: "中等"
                )
            ]
            
        case .chemistry:
            return [
                SubjectTopic(
                    id: "ideal_gas",
                    title: "理想气体 pV=nRT",
                    subtitle: "化学",
                    icon: "化",
                    description: "理想气体状态方程",
                    difficulty: "中等"
                ),
                SubjectTopic(
                    id: "chemical_reaction",
                    title: "化学反应方程式",
                    subtitle: "化学",
                    icon: "化",
                    description: "化学反应的平衡和计算",
                    difficulty: "中等"
                ),
                SubjectTopic(
                    id: "molecular_structure",
                    title: "分子结构",
                    subtitle: "化学",
                    icon: "化",
                    description: "分子的几何构型和性质",
                    difficulty: "高级"
                )
            ]
            
        case .biology:
            return [
                SubjectTopic(
                    id: "cell_structure",
                    title: "细胞结构",
                    subtitle: "生物",
                    icon: "生",
                    description: "细胞的基本结构和功能",
                    difficulty: "基础"
                ),
                SubjectTopic(
                    id: "genetics",
                    title: "遗传学基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "基因的传递和表达",
                    difficulty: "中等"
                ),
                SubjectTopic(
                    id: "ecosystem",
                    title: "生态系统",
                    subtitle: "生物",
                    icon: "生",
                    description: "生物与环境的关系",
                    difficulty: "中等"
                )
            ]
        }
    }
}

struct SubjectTopic: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let description: String
    let difficulty: String
}

struct SubjectTopicRow: View {
    let topic: SubjectTopic
    
    var body: some View {
        HStack(spacing: 16) {
            // 左侧图标
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                
                Text(topic.icon)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            
            // 中间内容
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(topic.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !topic.description.isEmpty {
                    Text(topic.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            // 右侧箭头
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct SubjectTopicDetailView: View {
    let topic: SubjectTopic
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
                        SubjectLearningTipRow(
                            icon: "lightbulb.fill",
                            color: .yellow,
                            title: "理解概念",
                            description: "先理解基本概念和定义，建立知识框架"
                        )
                        
                        SubjectLearningTipRow(
                            icon: "flask.fill",
                            color: .green,
                            title: "实验验证",
                            description: "通过实验验证理论，加深理解"
                        )
                        
                        SubjectLearningTipRow(
                            icon: "pencil.circle.fill",
                            color: .blue,
                            title: "练习应用",
                            description: "多做练习题，掌握应用方法"
                        )
                        
                        SubjectLearningTipRow(
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

struct SubjectLearningTipRow: View {
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
    NavigationStack {
        SubjectTopicsView(subject: .physics)
    }
}
