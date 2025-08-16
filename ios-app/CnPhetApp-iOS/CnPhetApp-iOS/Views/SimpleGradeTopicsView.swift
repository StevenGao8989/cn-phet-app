//
//  SimpleGradeTopicsView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct SimpleGradeTopicsView: View {
    let grade: Grade
    @State private var gradeTopics: [GradeTopic] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题
            HStack {
                Text(grade.title)
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
            } else if gradeTopics.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("暂无知识点")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("该年级暂未配置物理知识点")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(gradeTopics) { topic in
                    NavigationLink(value: topic) {
                        SimpleTopicRow(topic: topic)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(grade.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: GradeTopic.self) { topic in
            ConcreteTopicsListView(mainTopic: topic)
        }
        .onAppear {
            loadGradeTopics()
        }
    }
    
    private func loadGradeTopics() {
        isLoading = true
        
        // 根据年级加载对应的知识点
        gradeTopics = getTopicsForGrade(grade)
        isLoading = false
        
        print("📚 加载年级 \(grade.title) 的知识点")
        print("📊 找到 \(gradeTopics.count) 个知识点")
    }
    
    private func getTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        switch grade {
        case .grade7:
            return [
                GradeTopic(
                    id: "uniform_motion",
                    title: "匀速直线运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "基础力学概念和运动规律",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "density_calculation",
                    title: "密度计算",
                    subtitle: "物理",
                    icon: "物",
                    description: "基础热学概念和测量",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "simple_machine",
                    title: "简单机械",
                    subtitle: "物理",
                    icon: "物",
                    description: "杠杆、滑轮等简单机械",
                    difficulty: "基础"
                )
            ]
        case .grade8:
            return [
                GradeTopic(
                    id: "motion_and_force",
                    title: "运动与力",
                    subtitle: "物理",
                    icon: "物",
                    description: "位移与路程、速度与加速度、受力与合力、摩擦力",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "pressure_buoyancy",
                    title: "压强与浮力",
                    subtitle: "物理",
                    icon: "物",
                    description: "压强与面积关系、液体压强与深度、阿基米德原理",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "sound_light_basic",
                    title: "声与光(基础)",
                    subtitle: "物理",
                    icon: "物",
                    description: "声音的产生与传播、光的直线传播、反射与折射",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "simple_circuit",
                    title: "简单电路入门",
                    subtitle: "物理",
                    icon: "物",
                    description: "电路元件与电路图、串并联规律、安全用电",
                    difficulty: "基础"
                )
            ]
        case .grade9:
            return [
                GradeTopic(
                    id: "energy_conservation",
                    title: "能量守恒",
                    subtitle: "物理",
                    icon: "物",
                    description: "机械能守恒、能量转化与转移、效率",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "wave_properties",
                    title: "波动性质",
                    subtitle: "物理",
                    icon: "物",
                    description: "波的传播、反射、折射、干涉、衍射",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "electric_field_basic",
                    title: "电场基础",
                    subtitle: "物理",
                    icon: "物",
                    description: "电荷、电场、电势、电流、电阻",
                    difficulty: "中等"
                )
            ]
        case .grade10:
            return [
                GradeTopic(
                    id: "kinematics",
                    title: "运动学",
                    subtitle: "物理",
                    icon: "物",
                    description: "x–t、v–t图像、匀变速直线运动、抛体与曲线运动",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "force_motion",
                    title: "力与运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "受力分析与平衡、牛顿第三定律、摩擦力与约束力",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "work_energy",
                    title: "功与能",
                    subtitle: "物理",
                    icon: "物",
                    description: "功功率与效率、动能定理、保守力与机械能守恒",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "momentum_impulse",
                    title: "动量与冲量",
                    subtitle: "物理",
                    icon: "物",
                    description: "冲量定理、动量守恒、碰撞与爆炸",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "electrostatics_basic",
                    title: "静电场基础",
                    subtitle: "物理",
                    icon: "物",
                    description: "点电荷相互作用、电场强度与电势差、电容概念",
                    difficulty: "中等"
                )
            ]
        case .grade11:
            return [
                GradeTopic(
                    id: "electromagnetic_induction",
                    title: "电磁感应",
                    subtitle: "物理",
                    icon: "物",
                    description: "法拉第电磁感应定律、楞次定律、自感与互感",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "alternating_current",
                    title: "交流电",
                    subtitle: "物理",
                    icon: "物",
                    description: "正弦交流电、有效值、相位、阻抗",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "quantum_physics_basic",
                    title: "量子物理基础",
                    subtitle: "物理",
                    icon: "物",
                    description: "光电效应、波粒二象性、原子结构",
                    difficulty: "高级"
                )
            ]
        case .grade12:
            return [
                GradeTopic(
                    id: "nuclear_physics",
                    title: "核物理",
                    subtitle: "物理",
                    icon: "物",
                    description: "原子核结构、放射性衰变、核反应、质能方程",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "relativity_basic",
                    title: "相对论基础",
                    subtitle: "物理",
                    icon: "物",
                    description: "狭义相对论、时间膨胀、长度收缩、质能关系",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "modern_physics",
                    title: "现代物理",
                    subtitle: "物理",
                    icon: "物",
                    description: "激光、超导、纳米技术、宇宙学基础",
                    difficulty: "高级"
                )
            ]
        }
    }
}



struct SimpleTopicRow: View {
    let topic: GradeTopic
    
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

#Preview {
    NavigationStack {
        SimpleGradeTopicsView(grade: .grade8)
    }
}
