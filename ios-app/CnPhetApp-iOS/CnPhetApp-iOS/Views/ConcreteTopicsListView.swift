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
        case "kinematics":
            return [
                ConcreteTopic(
                    id: "projectile_motion",
                    title: "抛体运动",
                    subtitle: "物理",
                    icon: "🚀",
                    description: "平抛运动、斜抛运动、轨迹分析",
                    difficulty: "中等",
                    concepts: ["平抛运动", "斜抛运动", "轨迹分析", "射程计算", "最高点分析"],
                    formulas: ["x = v₀t", "y = v₀t - ½gt²", "t = 2v₀sinθ/g", "R = v₀²sin2θ/g"]
                ),
                ConcreteTopic(
                    id: "free_fall",
                    title: "自由落体",
                    subtitle: "物理",
                    icon: "⬇️",
                    description: "重力加速度、下落时间、落地速度",
                    difficulty: "中等",
                    concepts: ["自由落体", "重力加速度", "下落时间", "落地速度", "高度计算"],
                    formulas: ["h = ½gt²", "v = gt", "t = √(2h/g)", "v = √(2gh)"]
                ),
                ConcreteTopic(
                    id: "uniform_motion",
                    title: "匀速直线运动",
                    subtitle: "物理",
                    icon: "➡️",
                    description: "速度恒定、位移时间关系、图像分析",
                    difficulty: "基础",
                    concepts: ["匀速运动", "速度恒定", "位移时间关系", "图像分析", "运动规律"],
                    formulas: ["v = 常数", "x = vt", "x = x₀ + vt", "t = x/v"]
                ),
                ConcreteTopic(
                    id: "uniformly_accelerated_motion",
                    title: "匀变速直线运动",
                    subtitle: "物理",
                    icon: "📈",
                    description: "加速度恒定、速度时间关系、位移时间关系",
                    difficulty: "中等",
                    concepts: ["匀变速运动", "加速度恒定", "速度时间关系", "位移时间关系", "运动图像"],
                    formulas: ["v = v₀ + at", "x = v₀t + ½at²", "v² = v₀² + 2ax", "x = (v₀ + v)t/2"]
                )
            ]
        case "force_motion_newton":
            return [
                ConcreteTopic(
                    id: "force_analysis",
                    title: "受力分析",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "受力分析与等效简化、光滑、轻绳、滑轮、质点等",
                    difficulty: "中等",
                    concepts: ["受力分析", "等效简化", "光滑面", "轻绳", "滑轮", "质点"],
                    formulas: ["ΣF = ma", "F = mg", "F = μN", "T = mg"]
                ),
                ConcreteTopic(
                    id: "newton_third_law",
                    title: "牛顿第三定律",
                    subtitle: "物理",
                    icon: "🔄",
                    description: "作用力与反作用力、超重/失重、摩擦与约束",
                    difficulty: "中等",
                    concepts: ["作用力", "反作用力", "超重", "失重", "摩擦", "约束"],
                    formulas: ["F₁₂ = -F₂₁", "N = mg + ma", "N = mg - ma", "f = μN"]
                ),
                ConcreteTopic(
                    id: "friction_constraint",
                    title: "摩擦与约束",
                    subtitle: "物理",
                    icon: "🔒",
                    description: "多物体系统、连接体、斜面模型、临界问题",
                    difficulty: "高级",
                    concepts: ["多物体系统", "连接体", "斜面模型", "临界问题", "约束条件"],
                    formulas: ["f = μN", "a = gsinθ", "T = m(g - a)", "N = mgcosθ"]
                )
            ]
        case "work_energy_advanced":
            return [
                ConcreteTopic(
                    id: "work_power_efficiency",
                    title: "功与功率",
                    subtitle: "物理",
                    icon: "⚙️",
                    description: "变力做功与F-x曲线面积、功率（平均/瞬时）",
                    difficulty: "中等",
                    concepts: ["变力做功", "F-x曲线", "平均功率", "瞬时功率", "效率"],
                    formulas: ["W = ∫Fdx", "P = W/t", "P = Fv", "η = W有用/W总"]
                ),
                ConcreteTopic(
                    id: "kinetic_energy_theorem",
                    title: "动能定理",
                    subtitle: "物理",
                    icon: "🔋",
                    description: "保守力/非保守力、机械能守恒的适用与破坏",
                    difficulty: "中等",
                    concepts: ["保守力", "非保守力", "机械能守恒", "能量转化", "动能定理"],
                    formulas: ["W = ΔEk", "Ek = ½mv²", "W = -ΔEp", "E = Ek + Ep"]
                ),
                ConcreteTopic(
                    id: "conservative_mechanical_energy",
                    title: "机械能守恒",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "能量转化与效率、机械能守恒条件",
                    difficulty: "中等",
                    concepts: ["机械能守恒", "能量转化", "效率", "守恒条件", "能量损失"],
                    formulas: ["E₁ = E₂", "Ek₁ + Ep₁ = Ek₂ + Ep₂", "η = E有用/E总"]
                )
            ]
        case "momentum_impulse_advanced":
            return [
                ConcreteTopic(
                    id: "impulse_theorem",
                    title: "冲量定理",
                    subtitle: "物理",
                    icon: "💥",
                    description: "冲量-动量定理、动量守恒（一维/二维）",
                    difficulty: "中等",
                    concepts: ["冲量", "动量", "冲量定理", "动量守恒", "一维二维"],
                    formulas: ["I = Ft", "p = mv", "I = Δp", "Σp = 常数"]
                ),
                ConcreteTopic(
                    id: "momentum_conservation",
                    title: "动量守恒",
                    subtitle: "物理",
                    icon: "🔄",
                    description: "碰撞（弹性/非弹性）与反冲/爆炸模型",
                    difficulty: "高级",
                    concepts: ["弹性碰撞", "非弹性碰撞", "反冲", "爆炸", "动量守恒"],
                    formulas: ["m₁v₁ + m₂v₂ = m₁v₁' + m₂v₂'", "e = (v₂' - v₁')/(v₁ - v₂)"]
                ),
                ConcreteTopic(
                    id: "collision_explosion",
                    title: "碰撞与爆炸",
                    subtitle: "物理",
                    icon: "💣",
                    description: "碰撞分析、爆炸模型、动量守恒应用",
                    difficulty: "高级",
                    concepts: ["碰撞分析", "爆炸模型", "动量守恒", "能量损失", "速度计算"],
                    formulas: ["p₁ + p₂ = p₁' + p₂'", "v₁' = (m₁-m₂)v₁/(m₁+m₂)", "v₂' = 2m₁v₁/(m₁+m₂)"]
                )
            ]
        case "electrostatics":
            return [
                ConcreteTopic(
                    id: "point_charge_interaction",
                    title: "点电荷相互作用",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "点电荷作用（库仑定律）、电场强度与叠加",
                    difficulty: "中等",
                    concepts: ["点电荷", "库仑定律", "电场强度", "叠加原理", "电荷性质"],
                    formulas: ["F = kq₁q₂/r²", "E = F/q", "E = kQ/r²", "E = ΣEᵢ"]
                ),
                ConcreteTopic(
                    id: "electric_field_strength",
                    title: "电场强度与电势",
                    subtitle: "物理",
                    icon: "🔋",
                    description: "电势能与电势、等势面、带电粒子在匀强电场中的类抛体",
                    difficulty: "高级",
                    concepts: ["电势能", "电势", "等势面", "匀强电场", "类抛体运动"],
                    formulas: ["U = qV", "V = kQ/r", "E = -dV/dx", "y = qEx²/(2mv₀²)"]
                ),
                ConcreteTopic(
                    id: "capacitance_concept",
                    title: "电容与电容器",
                    subtitle: "物理",
                    icon: "🔌",
                    description: "电容概念、电容器储能、串并联规律",
                    difficulty: "中等",
                    concepts: ["电容", "电容器", "储能", "串并联", "电荷分布"],
                    formulas: ["C = Q/V", "C = ε₀S/d", "U = ½CV²", "1/C = 1/C₁ + 1/C₂"]
                )
            ]
        default:
            return [
                ConcreteTopic(
                    id: "default_topic",
                    title: "知识点详情",
                    subtitle: "物理",
                    icon: "📚",
                    description: "该知识点的详细内容正在开发中...",
                    difficulty: "待定",
                    concepts: ["基础概念", "核心原理", "应用方法"],
                    formulas: ["基本公式", "推导过程", "应用示例"]
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
