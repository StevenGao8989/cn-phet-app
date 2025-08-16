//
//  GradePhysicsOutlineView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct GradePhysicsOutlineView: View {
    let grade: Grade
    @State private var selectedCategory: PhysicsCategory?
    @State private var physicsOutline: GradePhysicsOutline?
    @State private var isLoading = true
    
    var body: some View {
        HStack(spacing: 0) {
            // 左侧导航栏 - 大类知识点
            VStack(spacing: 0) {
                // 顶部切换按钮
                HStack(spacing: 0) {
                    Button("教材") {
                        // 切换到教材模式
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    
                    Button("知识点") {
                        // 切换到知识点模式
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                }
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.top)
                
                // 调试信息
                Text("🔍 调试: 年级 \(grade.title)")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
                
                // 大类知识点列表
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if let outline = physicsOutline {
                            Text("📚 \(grade.title) - 找到 \(outline.categories.count) 个大类")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            
                            ForEach(outline.categories) { category in
                                CategoryRow(
                                    category: category,
                                    isSelected: selectedCategory?.id == category.id
                                ) {
                                    selectedCategory = category
                                    print("🎯 选择了大类: \(category.title)")
                                }
                            }
                        } else {
                            // 加载中或空状态
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text("正在加载知识点...")
                                    .foregroundColor(.secondary)
                                Text("年级: \(grade.title)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .padding(.top)
            }
            .frame(width: 280)
            .background(Color(.systemGray6))
            
            // 右侧内容区域
            VStack(spacing: 0) {
                // 顶部标题和搜索栏
                HStack {
                    Text("精品实验")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // 搜索栏
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("搜索资源", text: .constant(""))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(width: 200)
                }
                .padding()
                
                // 内容区域
                if let selectedCategory = selectedCategory {
                    VStack(spacing: 16) {
                        Text("📖 当前选择: \(selectedCategory.title)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("包含 \(selectedCategory.topics.count) 个知识点")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        CategoryContentView(category: selectedCategory)
                    }
                } else {
                    // 默认显示所有实验
                    VStack(spacing: 16) {
                        Text("🔬 精品实验")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("请从左侧选择一个知识点大类")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        AllExperimentsView()
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(grade.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: PhysicsTopic.self) { topic in
            TopicDetailView(topic: topic)
        }
        .onAppear {
            loadPhysicsOutline()
        }
    }
    
    private func loadPhysicsOutline() {
        // 加载年级物理大纲数据
        isLoading = true
        
        // 直接加载数据，不使用延迟
        self.physicsOutline = getExamplePhysicsOutline(for: self.grade)
        self.selectedCategory = self.physicsOutline?.categories.first
        self.isLoading = false
        
        print("📚 加载年级 \(grade.title) 的物理大纲")
        print("📊 找到 \(physicsOutline?.categories.count ?? 0) 个大类")
        if let firstCategory = self.physicsOutline?.categories.first {
            print("🎯 第一个大类: \(firstCategory.title)，包含 \(firstCategory.topics.count) 个知识点")
        }
    }
    
    private func getExamplePhysicsOutline(for grade: Grade) -> GradePhysicsOutline {
        switch grade {
        case .grade7:
            return GradePhysicsOutline(
                grade: "初一",
                gradeEnglish: "Grade 7",
                categories: [
                    PhysicsCategory(
                        id: "mechanics_basic",
                        title: "力学基础",
                        icon: "figure.walk",
                        description: "基础力学概念和运动规律",
                        topics: [
                            PhysicsTopic(
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
                        ]
                    ),
                    PhysicsCategory(
                        id: "thermodynamics_basic",
                        title: "热学基础",
                        icon: "thermometer",
                        description: "基础热学概念和测量",
                        topics: [
                            PhysicsTopic(
                                id: "density_calculation",
                                title: "密度计算",
                                grade: .grade7,
                                difficulty: "基础",
                                coreConcepts: ["质量", "体积", "密度"],
                                parameters: [
                                    TopicParameter(symbol: "m", name: "质量", unit: "kg", range: [0, 10], defaultValue: 1, description: "物体质量"),
                                    TopicParameter(symbol: "V", name: "体积", unit: "m³", range: [0, 2], defaultValue: 0.5, description: "物体体积")
                                ],
                                equations: ["ρ = m / V"],
                                formulaDescription: "密度等于质量除以体积",
                                applicationScenarios: ["材料识别", "浮力计算"],
                                experimentType: "measurement",
                                experimentGoal: "测量物体密度",
                                teachingFocus: ["密度的定义", "质量和体积的关系"],
                                commonErrors: ["混淆质量和重量", "忽略单位统一"],
                                thumbnail: "thumb_physics_density",
                                teachingResources: TeachingResources(
                                    videos: ["密度概念"],
                                    experiments: ["密度测量"],
                                    exercises: ["密度计算"]
                                )
                            )
                        ]
                    )
                ],
                teachingGoal: "建立物理概念，培养观察能力，激发学习兴趣",
                keyPoints: ["基础概念理解", "实验观察能力", "简单计算能力"]
            )
            
        case .grade8:
            return GradePhysicsOutline(
                grade: "初二",
                gradeEnglish: "Grade 8",
                categories: [
                    PhysicsCategory(
                        id: "mechanics_motion",
                        title: "运动学",
                        icon: "figure.walk",
                        description: "运动规律和力学分析",
                        topics: [
                            PhysicsTopic(
                                id: "free_fall",
                                title: "自由落体",
                                grade: .grade8,
                                difficulty: "基础",
                                coreConcepts: ["重力加速度", "下落高度", "速度变化"],
                                parameters: [
                                    TopicParameter(symbol: "h", name: "高度", unit: "m", range: [0, 50], defaultValue: 10, description: "下落高度"),
                                    TopicParameter(symbol: "g", name: "重力加速度", unit: "m·s⁻²", range: [9.0, 10.0], defaultValue: 9.8, description: "地球重力加速度")
                                ],
                                equations: ["h = 0.5·g·t²", "v = g·t"],
                                formulaDescription: "下落高度与时间的平方成正比，速度与时间成正比",
                                applicationScenarios: ["物体下落", "跳伞运动"],
                                experimentType: "motion_2d",
                                experimentGoal: "观察自由落体运动",
                                teachingFocus: ["重力加速度的概念", "下落高度与时间的关系"],
                                commonErrors: ["忽略空气阻力", "混淆下落时间和高度"],
                                thumbnail: "thumb_physics_free_fall",
                                teachingResources: TeachingResources(
                                    videos: ["自由落体现象"],
                                    experiments: ["下落轨迹测量"],
                                    exercises: ["高度计算"]
                                )
                            ),
                            PhysicsTopic(
                                id: "projectile_motion",
                                title: "抛体运动",
                                grade: .grade8,
                                difficulty: "中等",
                                coreConcepts: ["初速度", "抛射角", "轨迹", "射程"],
                                parameters: [
                                    TopicParameter(symbol: "v₀", name: "初速度", unit: "m·s⁻¹", range: [0, 50], defaultValue: 20, description: "抛射初速度"),
                                    TopicParameter(symbol: "θ", name: "抛射角", unit: "°", range: [0, 90], defaultValue: 45, description: "抛射角度")
                                ],
                                equations: ["x = v₀cosθ·t", "y = v₀sinθ·t − 0.5·g·t²"],
                                formulaDescription: "水平运动为匀速，垂直运动为匀加速",
                                applicationScenarios: ["投掷运动", "炮弹轨迹"],
                                experimentType: "motion_2d",
                                experimentGoal: "分析抛体运动轨迹",
                                teachingFocus: ["运动的独立性原理", "轨迹方程的应用"],
                                commonErrors: ["忽略水平运动", "混淆角度和弧度"],
                                thumbnail: "thumb_physics_projectile",
                                teachingResources: TeachingResources(
                                    videos: ["抛体运动分析"],
                                    experiments: ["抛物线轨迹"],
                                    exercises: ["轨迹计算"]
                                )
                            )
                        ]
                    )
                ],
                teachingGoal: "引入数学公式，培养计算能力，理解运动规律",
                keyPoints: ["公式应用", "运动分析", "实验设计"]
            )
            
        default:
            return GradePhysicsOutline(
                grade: grade.title,
                gradeEnglish: grade.englishTitle,
                categories: [],
                teachingGoal: "学习物理知识，培养科学思维",
                keyPoints: ["概念理解", "规律应用", "实验探究"]
            )
        }
    }
}

struct CategoryRow: View {
    let category: PhysicsCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(category.description)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .padding()
            .background(isSelected ? Color.blue : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

struct CategoryRowPlaceholder: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray4))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(height: 16)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray4))
                    .frame(height: 12)
            }
            
            Spacer()
        }
        .padding()
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

struct CategoryContentView: View {
    let category: PhysicsCategory
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // 分类标题
                HStack {
                    Text(category.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)
                
                // 知识点网格
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(category.topics) { topic in
                        NavigationLink(value: topic) {
                            TopicCard(topic: topic)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}

struct AllExperimentsView: View {
    let experiments = [
        ExperimentResource(
            id: "exp1",
            title: "等量异号点电荷的电场线",
            thumbnail: "electric_field",
            viewCount: "25k",
            isVIP: true,
            category: "电学",
            description: "观察等量异号点电荷的电场线分布",
            difficulty: "中等",
            estimatedTime: "15分钟",
            tags: ["电场", "电荷", "电场线"]
        ),
        ExperimentResource(
            id: "exp2",
            title: "伏安法测电阻分压接法",
            thumbnail: "circuit",
            viewCount: "6.9k",
            isVIP: true,
            category: "电学",
            description: "学习伏安法测量电阻的分压接法",
            difficulty: "基础",
            estimatedTime: "20分钟",
            tags: ["电阻", "伏安法", "分压"]
        ),
        ExperimentResource(
            id: "exp3",
            title: "抛石机 (趣味版)",
            thumbnail: "trebuchet",
            viewCount: "156.7k",
            isVIP: false,
            category: "力学",
            description: "趣味抛石机实验，学习抛体运动",
            difficulty: "基础",
            estimatedTime: "30分钟",
            tags: ["抛体运动", "趣味实验", "力学"]
        ),
        ExperimentResource(
            id: "exp4",
            title: "两球的碰撞",
            thumbnail: "collision",
            viewCount: "14.1k",
            isVIP: true,
            category: "力学",
            description: "观察两球碰撞的物理现象",
            difficulty: "中等",
            estimatedTime: "25分钟",
            tags: ["碰撞", "动量", "能量"]
        ),
        ExperimentResource(
            id: "exp5",
            title: "静电感应",
            thumbnail: "electrostatic",
            viewCount: "947.6k",
            isVIP: false,
            category: "电学",
            description: "静电感应现象的实验观察",
            difficulty: "基础",
            estimatedTime: "20分钟",
            tags: ["静电", "感应", "电荷"]
        ),
        ExperimentResource(
            id: "exp6",
            title: "通电导线与磁体通过磁场发生作用",
            thumbnail: "magnetic_field",
            viewCount: "25.2k",
            isVIP: true,
            category: "磁场",
            description: "观察通电导线在磁场中的受力",
            difficulty: "中等",
            estimatedTime: "30分钟",
            tags: ["磁场", "电流", "洛伦兹力"]
        )
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(experiments) { experiment in
                    ExperimentCard(experiment: experiment)
                }
            }
            .padding()
        }
    }
}

struct TopicCard: View {
    let topic: PhysicsTopic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 缩略图
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 120)
                
                Text(topic.title.prefix(1))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // 标题
                Text(topic.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // 难度和年级
                HStack(spacing: 8) {
                    Text(topic.difficulty)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(difficultyColor.opacity(0.2))
                        .foregroundColor(difficultyColor)
                        .cornerRadius(4)
                    
                    Text(topic.grade.title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 核心概念
                if !topic.coreConcepts.isEmpty {
                    Text("核心概念：\(topic.coreConcepts.prefix(2).joined(separator: "、"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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

struct ExperimentCard: View {
    let experiment: ExperimentResource
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 缩略图
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 120)
                
                // VIP标签
                if experiment.isVIP {
                    Text("VIP")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange)
                        .cornerRadius(8)
                        .padding(8)
                }
                
                // 播放次数
                HStack(spacing: 4) {
                    Image(systemName: "eye.fill")
                        .font(.caption)
                    Text(experiment.viewCount)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.6))
                .cornerRadius(8)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // 标题
                Text(experiment.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // 分类和难度
                HStack(spacing: 8) {
                    Text(experiment.category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                    
                    Text(experiment.difficulty)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(difficultyColor.opacity(0.2))
                        .foregroundColor(difficultyColor)
                        .cornerRadius(4)
                }
                
                // 描述
                Text(experiment.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var difficultyColor: Color {
        switch experiment.difficulty {
        case "基础": return .green
        case "中等": return .orange
        case "高级": return .red
        default: return .blue
        }
    }
}

#Preview {
    NavigationStack {
        GradePhysicsOutlineView(grade: .grade7)
    }
}
