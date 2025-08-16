//
//  TopicDetailView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct TopicDetailView: View {
    let topic: PhysicsTopic
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 顶部信息卡片
                TopicHeaderCard(topic: topic)
                
                // 标签页选择器
                Picker("选择标签页", selection: $selectedTab) {
                    Text("基础信息").tag(0)
                    Text("参数设置").tag(1)
                    Text("教学资源").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // 标签页内容
                TabView(selection: $selectedTab) {
                    BasicInfoTab(topic: topic)
                        .tag(0)
                    
                    ParametersTab(topic: topic)
                        .tag(1)
                    
                    TeachingResourcesTab(topic: topic)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle(topic.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("开始学习") {
                        // 这里可以跳转到对应的模拟器
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct TopicHeaderCard: View {
    let topic: PhysicsTopic
    
    var body: some View {
        VStack(spacing: 16) {
            // 知识点图标和标题
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Text(topic.title.prefix(1))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 8) {
                        Text(topic.grade.title)
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
            
            // 核心概念
            if !topic.coreConcepts.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("核心概念")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(topic.coreConcepts, id: \.self) { concept in
                            Text(concept)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
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

struct BasicInfoTab: View {
    let topic: PhysicsTopic
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 公式说明
                InfoCard(title: "公式说明", content: topic.formulaDescription)
                
                // 应用场景
                if !topic.applicationScenarios.isEmpty {
                    InfoCard(title: "应用场景", content: topic.applicationScenarios.joined(separator: "、"))
                }
                
                // 实验目标
                InfoCard(title: "实验目标", content: topic.experimentGoal)
                
                // 教学重点
                if !topic.teachingFocus.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("教学重点")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(topic.teachingFocus.enumerated()), id: \.offset) { index, focus in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .frame(width: 20, alignment: .leading)
                                    
                                    Text(focus)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
                
                // 常见错误
                if !topic.commonErrors.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("常见错误")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(topic.commonErrors.enumerated()), id: \.offset) { index, error in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("\(index + 1).")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .frame(width: 20, alignment: .leading)
                                    
                                    Text(error)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
            }
            .padding()
        }
    }
}

struct ParametersTab: View {
    let topic: PhysicsTopic
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 参数列表
                VStack(alignment: .leading, spacing: 16) {
                    Text("参数设置")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(topic.parameters, id: \.symbol) { parameter in
                        ParameterCard(parameter: parameter)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // 方程列表
                if !topic.equations.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("相关方程")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(topic.equations, id: \.self) { equation in
                                Text(equation)
                                    .font(.system(.body, design: .monospaced))
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                }
            }
            .padding()
        }
    }
}

struct TeachingResourcesTab: View {
    let topic: PhysicsTopic
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 视频资源
                if !topic.teachingResources.videos.isEmpty {
                    ResourceSection(
                        title: "视频资源",
                        icon: "play.circle.fill",
                        color: .blue,
                        items: topic.teachingResources.videos
                    )
                }
                
                // 实验资源
                if !topic.teachingResources.experiments.isEmpty {
                    ResourceSection(
                        title: "实验资源",
                        icon: "flask.fill",
                        color: .green,
                        items: topic.teachingResources.experiments
                    )
                }
                
                // 练习资源
                if !topic.teachingResources.exercises.isEmpty {
                    ResourceSection(
                        title: "练习资源",
                        icon: "pencil.circle.fill",
                        color: .orange,
                        items: topic.teachingResources.exercises
                    )
                }
            }
            .padding()
        }
    }
}

struct InfoCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ParameterCard: View {
    let parameter: TopicParameter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(parameter.symbol)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(parameter.name)
                        .font(.headline)
                    
                    Text(parameter.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text(parameter.unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("默认: \(String(format: "%.2f", parameter.defaultValue))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // 参数范围
            HStack {
                Text("范围:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(String(format: "%.2f", parameter.range[0])) - \(String(format: "%.2f", parameter.range[1]))")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct ResourceSection: View {
    let title: String
    let icon: String
    let color: Color
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text("•")
                            .foregroundColor(color)
                        Text(item)
                            .font(.body)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    let sampleTopic = PhysicsTopic(
        id: "uniform_motion",
        title: "匀速直线运动",
        grade: .grade7,
        difficulty: "基础",
        coreConcepts: ["速度", "位移", "时间"],
        parameters: [
            TopicParameter(symbol: "v", name: "速度", unit: "m·s⁻¹", range: [0, 10], defaultValue: 5, description: "物体运动的速度"),
            TopicParameter(symbol: "t", name: "时间", unit: "s", range: [0, 60], defaultValue: 10, description: "运动时间")
        ],
        equations: ["s = v·t"],
        formulaDescription: "位移等于速度乘以时间",
        applicationScenarios: ["汽车匀速行驶", "传送带运动"],
        experimentType: "motion_2d",
        experimentGoal: "理解匀速运动的特点",
        teachingFocus: ["速度的概念和单位", "匀速运动的特征"],
        commonErrors: ["混淆速度和速率", "忽略方向性"],
        thumbnail: "thumb_physics_uniform_motion",
        teachingResources: TeachingResources(
            videos: ["运动学基础"],
            experiments: ["运动轨迹测量"],
            exercises: ["基础计算题"]
        )
    )
    
    TopicDetailView(topic: sampleTopic)
}
