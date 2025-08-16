//
//  TestGradeTopics.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct TestGradeTopics: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("知识点配置测试")
                    .font(.title)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Subject.allCases) { subject in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(subject.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                ForEach(Grade.allCases) { grade in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("  \(grade.title):")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        
                                        let topics = getTopicsForSubjectAndGrade(subject: subject, grade: grade)
                                        ForEach(topics) { topic in
                                            Text("    • \(topic.title) - \(topic.description)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        if topics.isEmpty {
                                            Text("    暂无知识点")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func getTopicsForSubjectAndGrade(subject: Subject, grade: Grade) -> [GradeTopic] {
        switch subject {
        case .physics:
            return getPhysicsTopicsForGrade(grade)
        case .math:
            return getMathTopicsForGrade(grade)
        case .chemistry:
            return getChemistryTopicsForGrade(grade)
        case .biology:
            return getBiologyTopicsForGrade(grade)
        }
    }
    
    // 复制知识点配置函数
    private func getPhysicsTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        switch grade {
        case .grade7: // 初一
            return [
                GradeTopic(
                    id: "basic_physics_concept",
                    title: "物理基础概念",
                    subtitle: "物理",
                    icon: "物",
                    description: "物理学的定义、研究方法、基本单位",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "measurement",
                    title: "测量与单位",
                    subtitle: "物理",
                    icon: "物",
                    description: "长度、质量、时间的测量，国际单位制",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "simple_motion",
                    title: "简单运动",
                    subtitle: "物理",
                    icon: "物",
                    description: "匀速直线运动、路程与时间的关系",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
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
        case .grade9: // 初三
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
        case .grade10: // 高一 - 完全按照截图配置
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
        case .grade11: // 高二
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
        case .grade12: // 高三
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
    
    private func getMathTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        // 简化版本，只返回基础信息
        switch grade {
        case .grade10:
            return [
                GradeTopic(
                    id: "linear_function",
                    title: "一次函数 y=kx+b",
                    subtitle: "数学",
                    icon: "数",
                    description: "线性函数的基本性质和图像",
                    difficulty: "基础"
                )
            ]
        default:
            return [
                GradeTopic(
                    id: "basic_math",
                    title: "基础数学",
                    subtitle: "数学",
                    icon: "数",
                    description: "该年级的数学基础概念",
                    difficulty: "基础"
                )
            ]
        }
    }
    
    private func getChemistryTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        // 简化版本，只返回基础信息
        switch grade {
        case .grade10:
            return [
                GradeTopic(
                    id: "ideal_gas",
                    title: "理想气体 pV=nRT",
                    subtitle: "化学",
                    icon: "化",
                    description: "理想气体状态方程",
                    difficulty: "中等"
                )
            ]
        default:
            return [
                GradeTopic(
                    id: "basic_chemistry",
                    title: "基础化学",
                    subtitle: "化学",
                    icon: "化",
                    description: "该年级的化学基础概念",
                    difficulty: "基础"
                )
            ]
        }
    }
    
    private func getBiologyTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        // 简化版本，只返回基础信息
        switch grade {
        case .grade10:
            return [
                GradeTopic(
                    id: "cell_structure",
                    title: "细胞结构",
                    subtitle: "生物",
                    icon: "生",
                    description: "细胞的基本结构和功能",
                    difficulty: "基础"
                )
            ]
        default:
            return [
                GradeTopic(
                    id: "basic_biology",
                    title: "基础生物",
                    subtitle: "生物",
                    icon: "生",
                    description: "该年级的生物基础概念",
                    difficulty: "基础"
                )
            ]
        }
    }
}

#Preview {
    TestGradeTopics()
}
