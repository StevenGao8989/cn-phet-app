//
//  ConcreteTopicsListView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import Foundation
import SwiftUI

// 导入重新组织的模拟器文件
import Foundation
import SwiftUI

struct ConcreteTopicsListView: View {
    let mainTopic: GradeTopic
    @State private var concreteTopics: [ConcreteTopic] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题
            HStack {
                Text(mainTopic.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            // 具体知识点列表
            List(concreteTopics) { topic in
                NavigationLink(destination: getSimulatorDestination(for: topic)) {
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
                .buttonStyle(PlainButtonStyle())
            }
            .listStyle(.plain)
        }
        .navigationTitle(mainTopic.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadConcreteTopics()
        }
    }
    
    private func loadConcreteTopics() {
        print("🔍 开始加载具体知识点...")
        print("📚 主知识点ID: \(mainTopic.id)")
        print("📚 主知识点标题: \(mainTopic.title)")
        print("📚 主知识点描述: \(mainTopic.description)")
        
        concreteTopics = getConcreteTopicsForMainTopic(mainTopic)
        
        print("📊 找到 \(concreteTopics.count) 个具体知识点")
        for (index, topic) in concreteTopics.enumerated() {
            print("  \(index + 1). \(topic.title) - \(topic.description)")
        }
        
        if concreteTopics.isEmpty {
            print("⚠️ 警告：没有找到具体知识点，可能的原因：")
            print("   - mainTopic.id 不匹配任何 case")
            print("   - 当前 mainTopic.id: '\(mainTopic.id)'")
            print("   - 支持的 case: kinematics, force_motion, work_energy, momentum_impulse, electrostatics_basic")
        }
    }
    
    private func getConcreteTopicsForMainTopic(_ mainTopic: GradeTopic) -> [ConcreteTopic] {
        switch mainTopic.id {
        case "kinematics": // 运动学
            return [
                ConcreteTopic(
                    id: "projectile_motion",
                    title: "抛体运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "平抛运动、斜抛运动、轨迹分析",
                    difficulty: "中等",
                    concepts: ["平抛运动", "斜抛运动", "轨迹方程", "飞行时间", "射程"],
                    formulas: ["x = v₀t", "y = v₀ₓt - ½gt²", "t = 2v₀ₓ/g", "R = v₀²sin(2θ)/g"]
                ),
                ConcreteTopic(
                    id: "free_fall",
                    title: "自由落体",
                    subtitle: "物理",
                    icon: "物",
                    description: "重力加速度、下落时间、落地速度",
                    difficulty: "基础",
                    concepts: ["重力加速度", "自由落体", "匀加速运动", "下落时间", "落地速度"],
                    formulas: ["v = gt", "h = ½gt²", "v² = 2gh", "t = √(2h/g)"]
                ),
                ConcreteTopic(
                    id: "uniform_motion",
                    title: "匀速直线运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "速度恒定、位移时间关系、图像分析",
                    difficulty: "基础",
                    concepts: ["匀速运动", "速度恒定", "位移时间关系", "s-t图像", "v-t图像"],
                    formulas: ["s = vt", "v = s/t", "t = s/v"]
                ),
                ConcreteTopic(
                    id: "uniformly_accelerated_motion",
                    title: "匀变速直线运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "加速度恒定、速度时间关系、位移时间关系",
                    difficulty: "中等",
                    concepts: ["匀变速运动", "加速度恒定", "速度时间关系", "位移时间关系", "图像分析"],
                    formulas: ["v = v₀ + at", "s = v₀t + ½at²", "v² = v₀² + 2as"]
                )
            ]
        case "force_motion": // 力与运动
            return [
                ConcreteTopic(
                    id: "force_analysis",
                    title: "受力分析",
                    subtitle: "物理",
                    icon: "物",
                    description: "力的合成与分解、平衡条件、受力图",
                    difficulty: "中等",
                    concepts: ["力的合成", "力的分解", "平衡条件", "受力图", "正交分解"],
                    formulas: ["F = ma", "ΣF = 0", "Fₓ = Fcosθ", "Fᵧ = Fsinθ"]
                ),
                ConcreteTopic(
                    id: "newton_third_law",
                    title: "牛顿第三定律",
                    subtitle: "物理",
                    icon: "物",
                    description: "作用力与反作用力、力的相互性",
                    difficulty: "基础",
                    concepts: ["作用力", "反作用力", "力的相互性", "大小相等", "方向相反"],
                    formulas: ["F₁₂ = -F₂₁", "F₁₂ = F₂₁"]
                ),
                ConcreteTopic(
                    id: "friction_constraint",
                    title: "摩擦力与约束力",
                    subtitle: "物理",
                    icon: "物",
                    description: "静摩擦力、滑动摩擦力、约束力分析",
                    difficulty: "中等",
                    concepts: ["静摩擦力", "滑动摩擦力", "约束力", "摩擦系数", "最大静摩擦力"],
                    formulas: ["f = μN", "fₘₐₓ = μₛN", "fₖ = μₖN"]
                )
            ]
        case "work_energy": // 功与能
            return [
                ConcreteTopic(
                    id: "work_power_efficiency",
                    title: "功功率与效率",
                    subtitle: "物理",
                    icon: "物",
                    description: "功的计算、功率定义、机械效率",
                    difficulty: "中等",
                    concepts: ["功", "功率", "效率", "有用功", "总功"],
                    formulas: ["W = Fs", "P = W/t", "η = W有用/W总", "P = Fv"]
                ),
                ConcreteTopic(
                    id: "kinetic_energy_theorem",
                    title: "动能定理",
                    subtitle: "物理",
                    icon: "物",
                    description: "动能变化、合外力做功、动能定理应用",
                    difficulty: "中等",
                    concepts: ["动能", "动能变化", "合外力做功", "动能定理", "应用"],
                    formulas: ["Eₖ = ½mv²", "W = ΔEₖ", "W = ½mv² - ½mv₀²"]
                ),
                ConcreteTopic(
                    id: "conservative_mechanical_energy",
                    title: "保守力与机械能守恒",
                    subtitle: "物理",
                    icon: "物",
                    description: "保守力、势能、机械能守恒定律",
                    difficulty: "高级",
                    concepts: ["保守力", "势能", "机械能", "守恒定律", "能量转化"],
                    formulas: ["E = Eₖ + Eₚ", "E₁ = E₂", "ΔE = 0"]
                )
            ]
        case "momentum_impulse": // 动量与冲量
            return [
                ConcreteTopic(
                    id: "impulse_theorem",
                    title: "冲量定理",
                    subtitle: "物理",
                    icon: "物",
                    description: "冲量定义、动量变化、冲量定理应用",
                    difficulty: "高级",
                    concepts: ["冲量", "动量变化", "冲量定理", "力时间", "应用"],
                    formulas: ["I = Ft", "I = Δp", "Ft = mv - mv₀"]
                ),
                ConcreteTopic(
                    id: "momentum_conservation",
                    title: "动量守恒",
                    subtitle: "物理",
                    icon: "物",
                    description: "动量守恒条件、碰撞前后动量、应用",
                    difficulty: "高级",
                    concepts: ["动量守恒", "碰撞", "系统动量", "条件", "应用"],
                    formulas: ["p₁ + p₂ = p₁' + p₂'", "m₁v₁ + m₂v₂ = m₁v₁' + m₂v₂'"]
                ),
                ConcreteTopic(
                    id: "collision_explosion",
                    title: "碰撞与爆炸",
                    subtitle: "物理",
                    icon: "物",
                    description: "弹性碰撞、非弹性碰撞、爆炸过程",
                    difficulty: "高级",
                    concepts: ["弹性碰撞", "非弹性碰撞", "爆炸", "能量损失", "动量守恒"],
                    formulas: ["v₁' = (m₁-m₂)v₁/(m₁+m₂) + 2m₂v₂/(m₁+m₂)", "v₂' = (m₂-m₁)v₂/(m₁+m₂) + 2m₁v₁/(m₁+m₂)"]
                )
            ]
        case "electrostatics_basic": // 静电场基础
            return [
                ConcreteTopic(
                    id: "point_charge_interaction",
                    title: "点电荷相互作用",
                    subtitle: "物理",
                    icon: "物",
                    description: "库仑定律、电荷间作用力、电场力",
                    difficulty: "中等",
                    concepts: ["点电荷", "库仑定律", "电荷间作用力", "电场力", "方向"],
                    formulas: ["F = kq₁q₂/r²", "k = 9×10⁹ N·m²/C²", "F = qE"]
                ),
                ConcreteTopic(
                    id: "electric_field_strength",
                    title: "电场强度与电势差",
                    subtitle: "物理",
                    icon: "物",
                    description: "电场强度定义、电势差计算、电场线",
                    difficulty: "中等",
                    concepts: ["电场强度", "电势差", "电场线", "方向", "大小"],
                    formulas: ["E = F/q", "E = kQ/r²", "U = Ed", "E = -∇U"]
                ),
                ConcreteTopic(
                    id: "capacitance_concept",
                    title: "电容概念",
                    subtitle: "物理",
                    icon: "物",
                    description: "电容定义、平行板电容器、电容计算",
                    difficulty: "中等",
                    concepts: ["电容", "电容器", "电荷量", "电势差", "平行板"],
                    formulas: ["C = Q/U", "C = ε₀S/d", "U = Q/C"]
                )
            ]
        default:
            // 其他知识点的默认配置
            return [
                ConcreteTopic(
                    id: "basic_concept",
                    title: "基础概念",
                    subtitle: mainTopic.subtitle,
                    icon: mainTopic.icon,
                    description: "该知识点的基本概念和定义",
                    difficulty: "基础",
                    concepts: ["基本概念", "定义", "原理", "应用"],
                    formulas: ["基本公式", "计算方法", "应用公式"]
                )
            ]
        }
    }
    
    private func getSimulatorDestination(for topic: ConcreteTopic) -> some View {
        switch topic.id {
        case "projectile_motion":
            return AnyView(ProjectileSimView(title: topic.title))
        case "free_fall":
            return AnyView(FreefallSimView(title: topic.title))
        case "uniform_motion", "uniformly_accelerated_motion":
            return AnyView(SimpleMotionSimView(title: topic.title, motionType: topic.id))
        case "force_analysis", "newton_third_law", "friction_constraint":
            return AnyView(ForceMotionSimView(title: topic.title, forceType: topic.id))
        case "lens_imaging", "refraction_reflection":
            return AnyView(LensSimView(title: topic.title))
        default:
            // 如果没有对应的模拟器，显示一个默认的详情页面
            return AnyView(
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
            )
        }
    }
    
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "基础": return .green
        case "中等": return .orange
        case "高级": return .red
        default: return .blue
        }
    }
}

struct ConcreteTopicDetailView: View {
    let topic: ConcreteTopic
    
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
                                    .background(difficultyColor(for: topic.difficulty).opacity(0.2))
                                    .foregroundColor(difficultyColor(for: topic.difficulty))
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
                
                // 核心概念
                VStack(alignment: .leading, spacing: 12) {
                    Text("核心概念")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(topic.concepts, id: \.self) { concept in
                            HStack(spacing: 12) {
                                Image(systemName: "circle.fill")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                
                                Text(concept)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                // 重要公式
                VStack(alignment: .leading, spacing: 12) {
                    Text("重要公式")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(topic.formulas, id: \.self) { formula in
                            HStack(spacing: 12) {
                                Image(systemName: "function")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                
                                Text(formula)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .font(.system(.body, design: .monospaced))
                                
                                Spacer()
                            }
                        }
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
            }
            .padding()
        }
        .navigationTitle(topic.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "基础": return .green
        case "中等": return .orange
        case "高级": return .red
        default: return .blue
        }
    }
}

#Preview {
    NavigationStack {
        ConcreteTopicsListView(mainTopic: GradeTopic(
            id: "kinematics",
            title: "运动学",
            subtitle: "物理",
            icon: "物",
            description: "x–t、v–t图像、匀变速直线运动、抛体与曲线运动",
            difficulty: "中等"
        ))
    }
}
