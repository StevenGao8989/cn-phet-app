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
        .onAppear {
            loadConcreteTopics()
        }
    }
    
    private func loadConcreteTopics() {
        print("🔍 开始加载具体知识点...")
        print("📚 主知识点ID: \(mainTopic.id)")
        print("📚 主知识点标题: \(mainTopic.title)")
        print("📚 主知识点描述: \(mainTopic.description)")
        
        concreteTopics = ConcreteTopicsListView.getConcreteTopicsForMainTopic(mainTopic)
        
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
    
    static func getConcreteTopicsForMainTopic(_ mainTopic: GradeTopic) -> [ConcreteTopic] {
        switch mainTopic.id {
        // 初二年级物理知识点
        case "motion_force":
            return [
                ConcreteTopic(
                    id: "particle_reference_frame",
                    title: "质点与参考系",
                    subtitle: "物理",
                    icon: "🎯",
                    description: "质点的概念、参考系的选择、相对运动",
                    difficulty: "基础",
                    concepts: ["质点", "参考系", "相对运动", "运动描述", "坐标系"],
                    formulas: ["相对速度", "位移计算", "运动方程"]
                ),
                ConcreteTopic(
                    id: "displacement_distance",
                    title: "位移与路程",
                    subtitle: "物理",
                    icon: "📏",
                    description: "位移的矢量性、路程的标量性、位移与路程的区别",
                    difficulty: "基础",
                    concepts: ["位移", "路程", "矢量", "标量", "方向性"],
                    formulas: ["位移 = 终点位置 - 起点位置", "路程 = 路径长度"]
                ),
                ConcreteTopic(
                    id: "scalar_vector",
                    title: "标量与矢量",
                    subtitle: "物理",
                    icon: "➡️",
                    description: "标量的特点、矢量的特点、矢量的合成与分解",
                    difficulty: "基础",
                    concepts: ["标量", "矢量", "大小", "方向", "合成", "分解"],
                    formulas: ["矢量合成", "矢量分解", "平行四边形法则"]
                ),
                ConcreteTopic(
                    id: "velocity_acceleration",
                    title: "速度与加速度",
                    subtitle: "物理",
                    icon: "📈",
                    description: "平均速度、瞬时速度、加速度的定义与计算",
                    difficulty: "基础",
                    concepts: ["平均速度", "瞬时速度", "加速度", "速度变化", "时间"],
                    formulas: ["v = s/t", "a = Δv/Δt", "v = v₀ + at"]
                ),
                ConcreteTopic(
                    id: "uniform_acceleration_formulas",
                    title: "匀变速直线运动三公式",
                    subtitle: "物理",
                    icon: "📊",
                    description: "速度公式、位移公式、速度位移关系式",
                    difficulty: "基础",
                    concepts: ["匀变速运动", "初速度", "末速度", "加速度", "位移"],
                    formulas: ["v = v₀ + at", "s = v₀t + ½at²", "v² = v₀² + 2as"]
                )
            ]
        case "pressure_buoyancy":
            return [
                ConcreteTopic(
                    id: "pressure_area_relation",
                    title: "压强与面积关系",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "压强的定义、压强与受力面积的关系",
                    difficulty: "基础",
                    concepts: ["压强", "压力", "面积", "压强公式", "单位"],
                    formulas: ["p = F/S", "压强单位: Pa", "1 Pa = 1 N/m²"]
                ),
                ConcreteTopic(
                    id: "liquid_pressure",
                    title: "液体压强",
                    subtitle: "物理",
                    icon: "💧",
                    description: "液体压强的特点、p=ρgh公式的应用",
                    difficulty: "基础",
                    concepts: ["液体压强", "密度", "重力加速度", "深度", "压强分布"],
                    formulas: ["p = ρgh", "液体压强与深度成正比", "与液体密度成正比"]
                ),
                ConcreteTopic(
                    id: "atmospheric_pressure",
                    title: "气压与连通器",
                    subtitle: "物理",
                    icon: "🌬️",
                    description: "大气压强的概念、连通器原理、气压计",
                    difficulty: "基础",
                    concepts: ["大气压", "连通器", "气压计", "标准大气压", "气压变化"],
                    formulas: ["标准大气压 = 1.013×10⁵ Pa", "连通器液面等高"]
                ),
                ConcreteTopic(
                    id: "archimedes_principle",
                    title: "阿基米德原理",
                    subtitle: "物理",
                    icon: "🏊",
                    description: "浮力的概念、阿基米德原理、浮沉条件",
                    difficulty: "基础",
                    concepts: ["浮力", "阿基米德原理", "排开液体", "浮沉条件", "密度比较"],
                    formulas: ["F浮 = ρ液gV排", "浮沉条件: ρ物与ρ液比较"]
                )
            ]
        case "acoustics":
            return [
                ConcreteTopic(
                    id: "sound_production_propagation",
                    title: "声音的产生与传播",
                    subtitle: "物理",
                    icon: "🔊",
                    description: "声音的产生条件、传播介质、声速",
                    difficulty: "基础",
                    concepts: ["声源", "振动", "传播介质", "声速", "传播条件"],
                    formulas: ["声速 = 距离/时间", "不同介质中声速不同"]
                ),
                ConcreteTopic(
                    id: "sound_characteristics",
                    title: "声音的特性",
                    subtitle: "物理",
                    icon: "🎵",
                    description: "音调、响度、音色的概念与影响因素",
                    difficulty: "基础",
                    concepts: ["音调", "响度", "音色", "频率", "振幅", "波形"],
                    formulas: ["音调与频率关系", "响度与振幅关系"]
                ),
                ConcreteTopic(
                    id: "echo_doppler",
                    title: "回声与多普勒现象",
                    subtitle: "物理",
                    icon: "🔄",
                    description: "回声的形成条件、多普勒效应的应用",
                    difficulty: "基础",
                    concepts: ["回声", "反射", "时间间隔", "多普勒效应", "相对运动"],
                    formulas: ["回声距离 = 声速×时间/2", "多普勒频率变化"]
                ),
                ConcreteTopic(
                    id: "noise_reduction",
                    title: "噪声与降噪",
                    subtitle: "物理",
                    icon: "🔇",
                    description: "噪声的危害、降噪的方法与原理",
                    difficulty: "基础",
                    concepts: ["噪声", "危害", "降噪方法", "隔音", "吸音"],
                    formulas: ["分贝计算", "噪声叠加"]
                )
            ]
        case "geometric_optics_basic":
            return [
                ConcreteTopic(
                    id: "light_rectilinear_propagation",
                    title: "光的直线传播",
                    subtitle: "物理",
                    icon: "💡",
                    description: "光的直线传播特性、小孔成像原理",
                    difficulty: "基础",
                    concepts: ["直线传播", "小孔成像", "倒像", "成像大小", "成像距离"],
                    formulas: ["成像比例", "小孔成像规律"]
                ),
                ConcreteTopic(
                    id: "reflection_law",
                    title: "反射定律",
                    subtitle: "物理",
                    icon: "🪞",
                    description: "反射定律、平面镜成像规律、虚像特点",
                    difficulty: "基础",
                    concepts: ["入射角", "反射角", "法线", "平面镜", "虚像"],
                    formulas: ["入射角 = 反射角", "像距 = 物距", "像高 = 物高"]
                ),
                ConcreteTopic(
                    id: "refraction_total_reflection",
                    title: "折射与全反射",
                    subtitle: "物理",
                    icon: "🔍",
                    description: "折射现象、折射定律、全反射条件",
                    difficulty: "基础",
                    concepts: ["折射", "折射角", "折射率", "全反射", "临界角"],
                    formulas: ["n₁sinθ₁ = n₂sinθ₂", "临界角计算"]
                ),
                ConcreteTopic(
                    id: "shadow_formation",
                    title: "阴影形成",
                    subtitle: "物理",
                    icon: "🌑",
                    description: "本影、半影的形成、日食月食原理",
                    difficulty: "基础",
                    concepts: ["本影", "半影", "光源大小", "障碍物大小", "日食月食"],
                    formulas: ["阴影大小计算", "日食月食条件"]
                )
            ]
        case "simple_circuit":
            return [
                ConcreteTopic(
                    id: "circuit_components",
                    title: "电路元件",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "电源、开关、导线、用电器等基本元件",
                    difficulty: "基础",
                    concepts: ["电源", "开关", "导线", "用电器", "电路符号"],
                    formulas: ["电路图绘制", "元件连接"]
                ),
                ConcreteTopic(
                    id: "series_parallel",
                    title: "串并联电路",
                    subtitle: "物理",
                    icon: "🔗",
                    description: "串联电路特点、并联电路特点、基本规律",
                    difficulty: "基础",
                    concepts: ["串联", "并联", "电流", "电压", "电阻"],
                    formulas: ["串联: I=I₁=I₂, U=U₁+U₂, R=R₁+R₂", "并联: I=I₁+I₂, U=U₁=U₂, 1/R=1/R₁+1/R₂"]
                ),
                ConcreteTopic(
                    id: "current_voltage_resistance",
                    title: "电流电压电阻",
                    subtitle: "物理",
                    icon: "📊",
                    description: "电流的概念、电压的概念、电阻的概念与测量",
                    difficulty: "基础",
                    concepts: ["电流", "电压", "电阻", "欧姆表", "测量方法"],
                    formulas: ["I = Q/t", "U = W/Q", "R = U/I"]
                ),
                ConcreteTopic(
                    id: "electrical_safety",
                    title: "安全用电",
                    subtitle: "物理",
                    icon: "⚠️",
                    description: "安全电压、触电原因、安全用电常识",
                    difficulty: "基础",
                    concepts: ["安全电压", "触电", "绝缘", "接地", "保护措施"],
                    formulas: ["安全电压标准", "触电电流计算"]
                )
            ]
        // 初一年级物理知识点
        case "scientific_method":
            return [
                ConcreteTopic(
                    id: "idealization",
                    title: "理想化方法",
                    subtitle: "物理",
                    icon: "🎯",
                    description: "理想化模型、理想化条件、简化问题的方法",
                    difficulty: "基础",
                    concepts: ["理想化", "模型", "简化", "抽象", "科学方法"],
                    formulas: ["无具体公式", "思维方法", "建模过程"]
                ),
                ConcreteTopic(
                    id: "control_variables",
                    title: "控制变量法",
                    subtitle: "物理",
                    icon: "🔬",
                    description: "控制变量实验设计、单一变量原则",
                    difficulty: "基础",
                    concepts: ["控制变量", "单一变量", "实验设计", "对比实验", "科学探究"],
                    formulas: ["实验设计原则", "变量控制方法"]
                ),
                ConcreteTopic(
                    id: "comparison_experiment",
                    title: "对照实验",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "对照组的设置、实验结果的对比分析",
                    difficulty: "基础",
                    concepts: ["对照组", "实验组", "对比分析", "实验设计", "结果验证"],
                    formulas: ["实验设计", "对比方法"]
                ),
                ConcreteTopic(
                    id: "data_recording_processing",
                    title: "数据记录与处理",
                    subtitle: "物理",
                    icon: "📊",
                    description: "实验数据的记录、整理、分析和处理",
                    difficulty: "基础",
                    concepts: ["数据记录", "数据整理", "数据分析", "数据处理", "科学记录"],
                    formulas: ["数据处理方法", "误差分析"]
                )
            ]
        case "physical_quantities":
            return [
                ConcreteTopic(
                    id: "si_basic_units",
                    title: "SI基本单位",
                    subtitle: "物理",
                    icon: "📏",
                    description: "国际单位制基本单位、常用物理量单位",
                    difficulty: "基础",
                    concepts: ["SI单位", "基本单位", "导出单位", "单位换算", "国际标准"],
                    formulas: ["长度: m", "质量: kg", "时间: s", "电流: A", "温度: K"]
                ),
                ConcreteTopic(
                    id: "unit_conversion",
                    title: "常用单位换算",
                    subtitle: "物理",
                    icon: "🔄",
                    description: "常用物理量单位之间的换算关系",
                    difficulty: "基础",
                    concepts: ["单位换算", "换算关系", "换算方法", "常用单位", "换算公式"],
                    formulas: ["1 km = 1000 m", "1 h = 3600 s", "1 kg = 1000 g"]
                ),
                ConcreteTopic(
                    id: "dimensional_analysis",
                    title: "量纲分析",
                    subtitle: "物理",
                    icon: "🔍",
                    description: "物理量的量纲、量纲一致性检查",
                    difficulty: "基础",
                    concepts: ["量纲", "量纲分析", "量纲一致性", "物理意义", "单位检查"],
                    formulas: ["量纲公式", "量纲检查方法"]
                )
            ]
        case "measurement_error":
            return [
                ConcreteTopic(
                    id: "reading_rules",
                    title: "读数规则",
                    subtitle: "物理",
                    icon: "📖",
                    description: "各种测量仪器的读数方法和规则",
                    difficulty: "基础",
                    concepts: ["读数规则", "估读", "最小刻度", "测量精度", "仪器使用"],
                    formulas: ["读数 = 整刻度 + 估读值", "估读值 ≤ 最小刻度/2"]
                ),
                ConcreteTopic(
                    id: "significant_figures",
                    title: "有效数字",
                    subtitle: "物理",
                    icon: "🔢",
                    description: "有效数字的概念、有效数字的运算规则",
                    difficulty: "基础",
                    concepts: ["有效数字", "可靠数字", "可疑数字", "运算规则", "精度保持"],
                    formulas: ["有效数字运算", "精度确定方法"]
                ),
                ConcreteTopic(
                    id: "absolute_relative_error",
                    title: "绝对误差与相对误差",
                    subtitle: "物理",
                    icon: "📊",
                    description: "绝对误差、相对误差的定义与计算",
                    difficulty: "基础",
                    concepts: ["绝对误差", "相对误差", "误差计算", "误差分析", "测量精度"],
                    formulas: ["绝对误差 = |测量值 - 真值|", "相对误差 = 绝对误差/真值 × 100%"]
                ),
                ConcreteTopic(
                    id: "repeated_measurement_average",
                    title: "重复测量与平均值",
                    subtitle: "物理",
                    icon: "🔄",
                    description: "多次测量的意义、平均值的计算、误差的减小",
                    difficulty: "基础",
                    concepts: ["重复测量", "平均值", "误差减小", "测量可靠性", "统计方法"],
                    formulas: ["平均值 = (x₁ + x₂ + ... + xₙ)/n", "误差减小方法"]
                )
            ]
        // 初三年级物理知识点
        case "electricity_deep":
            return [
                ConcreteTopic(
                    id: "ohm_law",
                    title: "欧姆定律",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "欧姆定律的表述、适用条件、电阻的计算",
                    difficulty: "中等",
                    concepts: ["欧姆定律", "电流", "电压", "电阻", "线性关系", "适用条件"],
                    formulas: ["I = U/R", "R = U/I", "U = IR", "电阻单位: Ω"]
                ),
                ConcreteTopic(
                    id: "series_parallel_calculation",
                    title: "串并联电路定量计算",
                    subtitle: "物理",
                    icon: "🔗",
                    description: "串联并联电路的电流、电压、电阻的定量计算",
                    difficulty: "中等",
                    concepts: ["串联电路", "并联电路", "电流分配", "电压分配", "等效电阻"],
                    formulas: ["串联: R总 = R₁ + R₂ + R₃", "并联: 1/R总 = 1/R₁ + 1/R₂ + 1/R₃"]
                ),
                ConcreteTopic(
                    id: "electrical_work_power",
                    title: "电功与电功率",
                    subtitle: "物理",
                    icon: "🔋",
                    description: "电功的计算、电功率的定义与计算、单位换算",
                    difficulty: "中等",
                    concepts: ["电功", "电功率", "能量转化", "时间", "效率"],
                    formulas: ["W = UIt", "P = UI", "P = W/t", "1 kW·h = 3.6×10⁶ J"]
                ),
                ConcreteTopic(
                    id: "joule_law",
                    title: "焦耳定律",
                    subtitle: "物理",
                    icon: "🔥",
                    description: "焦耳定律的表述、电流热效应的应用",
                    difficulty: "中等",
                    concepts: ["焦耳定律", "电流热效应", "电阻", "时间", "热量"],
                    formulas: ["Q = I²Rt", "热量单位: J", "热功率: P = I²R"]
                ),
                ConcreteTopic(
                    id: "home_circuit_safety",
                    title: "家庭电路与安全",
                    subtitle: "物理",
                    icon: "🏠",
                    description: "家庭电路的组成、安全用电常识、保险丝的作用",
                    difficulty: "中等",
                    concepts: ["家庭电路", "火线", "零线", "地线", "保险丝", "安全用电"],
                    formulas: ["家庭电压: 220V", "安全电流: ≤30mA"]
                )
            ]
        case "work_mechanical_energy":
            return [
                ConcreteTopic(
                    id: "work_power",
                    title: "功与功率",
                    subtitle: "物理",
                    icon: "⚙️",
                    description: "功的定义、功率的计算、机械效率",
                    difficulty: "中等",
                    concepts: ["功", "功率", "机械效率", "有用功", "总功", "时间"],
                    formulas: ["W = Fs", "P = W/t", "P = Fv", "η = W有用/W总"]
                ),
                ConcreteTopic(
                    id: "lever_pulley",
                    title: "杠杆与滑轮",
                    subtitle: "物理",
                    icon: "🔧",
                    description: "杠杆平衡条件、滑轮的特点、机械优势",
                    difficulty: "中等",
                    concepts: ["杠杆", "支点", "动力", "阻力", "滑轮", "机械优势"],
                    formulas: ["F₁L₁ = F₂L₂", "定滑轮: F = G", "动滑轮: F = G/2"]
                ),
                ConcreteTopic(
                    id: "kinetic_potential_energy",
                    title: "动能与势能",
                    subtitle: "物理",
                    icon: "🎯",
                    description: "动能的定义、重力势能、弹性势能的计算",
                    difficulty: "中等",
                    concepts: ["动能", "重力势能", "弹性势能", "质量", "高度", "弹性系数"],
                    formulas: ["E动 = ½mv²", "E重 = mgh", "E弹 = ½kx²"]
                ),
                ConcreteTopic(
                    id: "mechanical_energy_conservation",
                    title: "机械能守恒",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "机械能守恒的条件、动能定理的应用",
                    difficulty: "中等",
                    concepts: ["机械能守恒", "动能定理", "能量转化", "保守力", "非保守力"],
                    formulas: ["E₁ = E₂", "W = ΔE", "E = E动 + E重 + E弹"]
                )
            ]
        case "thermodynamics_phase":
            return [
                ConcreteTopic(
                    id: "temperature_heat",
                    title: "温度与热量",
                    subtitle: "物理",
                    icon: "🌡️",
                    description: "温度的概念、热量的定义、热传递的方式",
                    difficulty: "中等",
                    concepts: ["温度", "热量", "热传递", "热传导", "热对流", "热辐射"],
                    formulas: ["温度单位: ℃, K", "热量单位: J", "1 cal = 4.2 J"]
                ),
                ConcreteTopic(
                    id: "specific_heat_capacity",
                    title: "比热容与热量计算",
                    subtitle: "物理",
                    icon: "🔥",
                    description: "比热容的概念、热量计算公式、比热容的测量",
                    difficulty: "中等",
                    concepts: ["比热容", "质量", "温度变化", "热量计算", "比热容测量"],
                    formulas: ["Q = cmΔt", "c = Q/(mΔt)", "比热容单位: J/(kg·℃)"]
                ),
                ConcreteTopic(
                    id: "phase_change_latent_heat",
                    title: "物态变化与潜热",
                    subtitle: "物理",
                    icon: "💧",
                    description: "物态变化过程、潜热的概念、物态变化图",
                    difficulty: "中等",
                    concepts: ["物态变化", "潜热", "熔化", "凝固", "汽化", "液化"],
                    formulas: ["Q = mL", "L = Q/m", "潜热单位: J/kg"]
                ),
                ConcreteTopic(
                    id: "heat_transfer_application",
                    title: "热传递与生活应用",
                    subtitle: "物理",
                    icon: "🏠",
                    description: "热传递在生活中的应用、保温材料、散热设计",
                    difficulty: "中等",
                    concepts: ["热传递应用", "保温", "散热", "材料选择", "设计原理"],
                    formulas: ["热传导: Q = kAΔt/d", "热对流", "热辐射"]
                )
            ]
        // 高二年级物理知识点
        case "magnetic_field_particles":
            return [
                ConcreteTopic(
                    id: "magnetic_field_lines",
                    title: "磁感线与右手定则",
                    subtitle: "物理",
                    icon: "🧲",
                    description: "磁感线的概念、右手定则的应用、磁场方向的判断",
                    difficulty: "高级",
                    concepts: ["磁感线", "右手定则", "磁场方向", "磁感应强度", "磁场分布"],
                    formulas: ["右手定则", "磁感线密度", "磁场强度"]
                ),
                ConcreteTopic(
                    id: "current_carrying_conductor",
                    title: "通电导线的磁场",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "通电直导线、通电线圈的磁场、安培定则",
                    difficulty: "高级",
                    concepts: ["通电导线", "通电线圈", "安培定则", "磁场强度", "磁感应强度"],
                    formulas: ["B = μ₀I/(2πr)", "B = μ₀nI", "μ₀ = 4π×10⁻⁷ T·m/A"]
                ),
                ConcreteTopic(
                    id: "lorentz_force",
                    title: "洛伦兹力",
                    subtitle: "物理",
                    icon: "🎯",
                    description: "洛伦兹力的定义、带电粒子在磁场中的运动",
                    difficulty: "高级",
                    concepts: ["洛伦兹力", "带电粒子", "磁场", "速度", "电荷", "运动轨迹"],
                    formulas: ["F = qvBsinθ", "F = qvB (垂直)", "r = mv/(qB)"]
                ),
                ConcreteTopic(
                    id: "circular_spiral_motion",
                    title: "圆周运动与螺旋运动",
                    subtitle: "物理",
                    icon: "🌀",
                    description: "带电粒子在匀强磁场中的圆周运动、螺旋运动",
                    difficulty: "高级",
                    concepts: ["圆周运动", "螺旋运动", "周期", "半径", "螺距", "运动分析"],
                    formulas: ["T = 2πm/(qB)", "r = mv/(qB)", "h = v∥T"]
                )
            ]
        case "electromagnetic_induction_ac":
            return [
                ConcreteTopic(
                    id: "magnetic_flux",
                    title: "磁通量",
                    subtitle: "物理",
                    icon: "🔗",
                    description: "磁通量的定义、磁通量的计算、磁通量的变化",
                    difficulty: "高级",
                    concepts: ["磁通量", "磁感应强度", "面积", "夹角", "磁通量变化"],
                    formulas: ["Φ = BScosθ", "ΔΦ = Φ₂ - Φ₁", "磁通量单位: Wb"]
                ),
                ConcreteTopic(
                    id: "faraday_law",
                    title: "法拉第电磁感应定律",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "法拉第定律的表述、感应电动势的计算",
                    difficulty: "高级",
                    concepts: ["法拉第定律", "感应电动势", "磁通量变化率", "线圈匝数", "楞次定律"],
                    formulas: ["ε = -NΔΦ/Δt", "ε = -NBSωsinωt", "电动势单位: V"]
                ),
                ConcreteTopic(
                    id: "lenz_law",
                    title: "楞次定律",
                    subtitle: "物理",
                    icon: "🔄",
                    description: "楞次定律的表述、感应电流方向的判断",
                    difficulty: "高级",
                    concepts: ["楞次定律", "感应电流", "磁通量变化", "阻碍作用", "能量守恒"],
                    formulas: ["感应电流方向", "阻碍磁通量变化", "能量转化"]
                ),
                ConcreteTopic(
                    id: "ac_circuit_analysis",
                    title: "交流电路分析",
                    subtitle: "物理",
                    icon: "🌊",
                    description: "正弦交流电、有效值、相位、阻抗RLC电路",
                    difficulty: "高级",
                    concepts: ["正弦交流", "有效值", "相位", "阻抗", "RLC电路", "谐振"],
                    formulas: ["I有效 = Iₘ/√2", "U有效 = Uₘ/√2", "Z = √(R² + (XL - XC)²)"]
                )
            ]
        case "vibration_waves":
            return [
                ConcreteTopic(
                    id: "simple_harmonic_motion",
                    title: "简谐振动",
                    subtitle: "物理",
                    icon: "🎵",
                    description: "简谐振动的特征、振动方程、振动图像",
                    difficulty: "高级",
                    concepts: ["简谐振动", "振幅", "周期", "频率", "相位", "振动方程"],
                    formulas: ["x = Acos(ωt + φ)", "ω = 2πf", "T = 1/f", "f = 1/T"]
                ),
                ConcreteTopic(
                    id: "pendulum_spring_oscillator",
                    title: "单摆与弹簧振子",
                    subtitle: "物理",
                    icon: "🔗",
                    description: "单摆的周期、弹簧振子的周期、振动规律",
                    difficulty: "高级",
                    concepts: ["单摆", "弹簧振子", "周期", "重力加速度", "弹性系数", "质量"],
                    formulas: ["单摆: T = 2π√(L/g)", "弹簧: T = 2π√(m/k)"]
                ),
                ConcreteTopic(
                    id: "wave_properties",
                    title: "波的性质",
                    subtitle: "物理",
                    icon: "🌊",
                    description: "机械波、波速、波长、频率、波的能量传递",
                    difficulty: "高级",
                    concepts: ["机械波", "波速", "波长", "频率", "波的能量", "波的传播"],
                    formulas: ["v = λf", "v = λ/T", "λ = vT", "波速与介质有关"]
                ),
                ConcreteTopic(
                    id: "wave_phenomena",
                    title: "波动现象",
                    subtitle: "物理",
                    icon: "🔍",
                    description: "波的反射、干涉、衍射、共振现象",
                    difficulty: "高级",
                    concepts: ["反射", "干涉", "衍射", "共振", "驻波", "多普勒效应"],
                    formulas: ["干涉条件", "衍射条件", "共振条件", "驻波方程"]
                )
            ]
        // 高三年级物理知识点
        case "optics_advanced":
            return [
                ConcreteTopic(
                    id: "thin_lens_imaging",
                    title: "薄透镜成像",
                    subtitle: "物理",
                    icon: "🔬",
                    description: "薄透镜成像规律、作图法、放大率计算",
                    difficulty: "高级",
                    concepts: ["薄透镜", "成像规律", "作图法", "放大率", "物距", "像距"],
                    formulas: ["1/u + 1/v = 1/f", "m = v/u", "m = h'/h", "f = R/2"]
                ),
                ConcreteTopic(
                    id: "optical_instruments",
                    title: "光学仪器",
                    subtitle: "物理",
                    icon: "🔭",
                    description: "显微镜、望远镜、照相机等光学仪器的原理",
                    difficulty: "高级",
                    concepts: ["显微镜", "望远镜", "照相机", "放大率", "分辨率", "光学系统"],
                    formulas: ["显微镜: M = M₁M₂", "望远镜: M = f₁/f₂", "照相机: 1/u + 1/v = 1/f"]
                ),
                ConcreteTopic(
                    id: "interference_diffraction",
                    title: "干涉与衍射",
                    subtitle: "物理",
                    icon: "🌈",
                    description: "杨氏双缝干涉、薄膜干涉、单缝衍射现象",
                    difficulty: "高级",
                    concepts: ["干涉", "衍射", "双缝", "薄膜", "光程差", "条纹"],
                    formulas: ["双缝: dsinθ = mλ", "薄膜: 2nd = mλ", "单缝: asinθ = mλ"]
                ),
                ConcreteTopic(
                    id: "diffraction_conditions",
                    title: "衍射条件",
                    subtitle: "物理",
                    icon: "🔍",
                    description: "衍射角条件、衍射极限、分辨率",
                    difficulty: "高级",
                    concepts: ["衍射角", "衍射极限", "分辨率", "瑞利判据", "光学仪器"],
                    formulas: ["衍射角: θ ≈ λ/a", "分辨率: θ = 1.22λ/D", "瑞利判据"]
                )
            ]
        case "thermodynamics_gas":
            return [
                ConcreteTopic(
                    id: "ideal_gas_equation",
                    title: "理想气体状态方程",
                    subtitle: "物理",
                    icon: "🌡️",
                    description: "理想气体状态方程、各种过程的分析",
                    difficulty: "高级",
                    concepts: ["理想气体", "状态方程", "等温过程", "等压过程", "等容过程", "绝热过程"],
                    formulas: ["PV = nRT", "PV = 常数(等温)", "V/T = 常数(等压)", "P/T = 常数(等容)"]
                ),
                ConcreteTopic(
                    id: "kinetic_theory",
                    title: "气体分子运动论",
                    subtitle: "物理",
                    icon: "⚛️",
                    description: "气体分子运动论要点、压强微观解释",
                    difficulty: "高级",
                    concepts: ["分子运动", "压强", "温度", "平均动能", "分子速度", "碰撞"],
                    formulas: ["P = (1/3)nmv²", "E = (3/2)kT", "v = √(3kT/m)", "平均动能与温度成正比"]
                ),
                ConcreteTopic(
                    id: "thermodynamics_first_law",
                    title: "热力学第一定律",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "热力学第一定律、内能变化、功与热量的关系",
                    difficulty: "高级",
                    concepts: ["热力学第一定律", "内能", "功", "热量", "能量守恒", "状态函数"],
                    formulas: ["ΔU = Q + W", "Q > 0 (吸热)", "W > 0 (对外做功)", "内能是状态函数"]
                ),
                ConcreteTopic(
                    id: "gas_processes",
                    title: "气体过程分析",
                    subtitle: "物理",
                    icon: "📊",
                    description: "各种气体过程的分析、P-V图、T-S图",
                    difficulty: "高级",
                    concepts: ["等温过程", "等压过程", "等容过程", "绝热过程", "循环过程", "效率"],
                    formulas: ["等温: W = nRTln(V₂/V₁)", "等压: W = PΔV", "等容: W = 0", "绝热: PV^γ = 常数"]
                )
            ]
        case "modern_physics_advanced":
            return [
                ConcreteTopic(
                    id: "photoelectric_effect",
                    title: "光电效应",
                    subtitle: "物理",
                    icon: "💡",
                    description: "光量子假说、光电效应方程、截止频率",
                    difficulty: "高级",
                    concepts: ["光电效应", "光子", "普朗克常数", "截止频率", "逸出功", "爱因斯坦方程"],
                    formulas: ["E = hf", "hf = W + ½mv²", "h = 6.63×10⁻³⁴ J·s", "截止频率: f₀ = W/h"]
                ),
                ConcreteTopic(
                    id: "atomic_models",
                    title: "原子模型",
                    subtitle: "物理",
                    icon: "⚛️",
                    description: "原子结构模型、能级跃迁、谱线分析",
                    difficulty: "高级",
                    concepts: ["原子模型", "能级", "跃迁", "谱线", "玻尔模型", "量子数"],
                    formulas: ["E = -13.6/n² eV", "hf = E₂ - E₁", "里德伯常数", "巴尔末公式"]
                ),
                ConcreteTopic(
                    id: "hydrogen_bohr_model",
                    title: "氢原子玻尔模型",
                    subtitle: "物理",
                    icon: "🔬",
                    description: "玻尔模型的假设、能级公式、轨道半径",
                    difficulty: "高级",
                    concepts: ["玻尔模型", "量子化", "轨道半径", "能级", "角动量", "氢原子"],
                    formulas: ["r = n²a₀", "a₀ = 0.53×10⁻¹⁰ m", "E = -13.6/n² eV", "L = nh/(2π)"]
                ),
                ConcreteTopic(
                    id: "matter_waves",
                    title: "物质波",
                    subtitle: "物理",
                    icon: "🌊",
                    description: "德布罗意波长、波粒二象性、不确定性原理",
                    difficulty: "高级",
                    concepts: ["物质波", "德布罗意波长", "波粒二象性", "不确定性原理", "量子力学"],
                    formulas: ["λ = h/p", "λ = h/(mv)", "ΔxΔp ≥ h/(4π)", "德布罗意波长"]
                )
            ]
        case "nuclear_radioactivity":
            return [
                ConcreteTopic(
                    id: "radioactive_decay",
                    title: "放射性衰变",
                    subtitle: "物理",
                    icon: "☢️",
                    description: "衰变规律、半衰期、衰变常数",
                    difficulty: "高级",
                    concepts: ["放射性衰变", "半衰期", "衰变常数", "衰变方程", "衰变链", "统计规律"],
                    formulas: ["N = N₀e^(-λt)", "T₁/₂ = ln2/λ", "λ = ln2/T₁/₂", "衰变率: dN/dt = -λN"]
                ),
                ConcreteTopic(
                    id: "nuclear_reactions",
                    title: "核反应方程",
                    subtitle: "物理",
                    icon: "⚛️",
                    description: "核反应方程配平、质量数守恒、电荷数守恒",
                    difficulty: "高级",
                    concepts: ["核反应", "质量数", "电荷数", "守恒定律", "配平", "核素"],
                    formulas: ["质量数守恒: A₁ + A₂ = A₃ + A₄", "电荷数守恒: Z₁ + Z₂ = Z₃ + Z₄"]
                ),
                ConcreteTopic(
                    id: "mass_defect_binding_energy",
                    title: "质量亏损与结合能",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "质量亏损、结合能、比结合能",
                    difficulty: "高级",
                    concepts: ["质量亏损", "结合能", "比结合能", "核力", "稳定性", "核素"],
                    formulas: ["Δm = Zm_p + Nm_n - M", "E = Δmc²", "比结合能 = E/A", "E = 931.5Δm MeV"]
                ),
                ConcreteTopic(
                    id: "nuclear_fission_fusion",
                    title: "核裂变与核聚变",
                    subtitle: "物理",
                    icon: "💥",
                    description: "核裂变、核聚变原理、核能利用的利弊",
                    difficulty: "高级",
                    concepts: ["核裂变", "核聚变", "链式反应", "可控核聚变", "核能", "核废料"],
                    formulas: ["裂变: ²³⁵U + ¹n → 产物 + 能量", "聚变: ²H + ³H → ⁴He + ¹n + 能量"]
                )
            ]
        case "comprehensive_practice":
            return [
                ConcreteTopic(
                    id: "multi_topic_integration",
                    title: "多主题综合题",
                    subtitle: "物理",
                    icon: "🎯",
                    description: "多主题综合题的分析方法、解题策略",
                    difficulty: "高级",
                    concepts: ["综合题", "多主题", "分析方法", "解题策略", "知识整合", "思维方法"],
                    formulas: ["综合运用各章节公式", "建立物理模型", "分析物理过程"]
                ),
                ConcreteTopic(
                    id: "graphical_methods",
                    title: "图像法",
                    subtitle: "物理",
                    icon: "📊",
                    description: "图像法的应用、图像分析技巧",
                    difficulty: "高级",
                    concepts: ["图像法", "图像分析", "斜率", "面积", "截距", "图像变换"],
                    formulas: ["斜率 = Δy/Δx", "面积 = ∫ydx", "图像特征分析"]
                ),
                ConcreteTopic(
                    id: "extreme_critical_values",
                    title: "极值与临界",
                    subtitle: "物理",
                    icon: "🔍",
                    description: "极值问题、临界条件、边界分析",
                    difficulty: "高级",
                    concepts: ["极值", "临界条件", "边界分析", "导数", "不等式", "约束条件"],
                    formulas: ["极值条件: df/dx = 0", "临界条件", "边界条件分析"]
                ),
                ConcreteTopic(
                    id: "experiment_design_evaluation",
                    title: "实验设计与评估",
                    subtitle: "物理",
                    icon: "🧪",
                    description: "实验设计原则、控制变量、重复性、灵敏度",
                    difficulty: "高级",
                    concepts: ["实验设计", "控制变量", "重复性", "灵敏度", "误差分析", "实验评估"],
                    formulas: ["实验设计原则", "误差分析", "不确定度评估", "实验验证"]
                )
            ]
        // 物理知识点
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
        
        // 化学知识点
        case "chemical_concepts_experiment":
            return [
                ConcreteTopic(
                    id: "chemical_physical_changes",
                    title: "物理/化学变化区分",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "化学研究对象与物理/化学变化的区分",
                    difficulty: "基础",
                    concepts: ["物理变化", "化学变化", "化学研究对象", "变化特征", "判断方法"],
                    formulas: ["无化学公式", "观察法", "性质变化", "新物质生成"]
                ),
                ConcreteTopic(
                    id: "experiment_safety",
                    title: "实验安全",
                    subtitle: "化学",
                    icon: "⚠️",
                    description: "基本实验仪器与实验安全、火焰使用、毒/腐/易燃标识、废液分类",
                    difficulty: "基础",
                    concepts: ["实验仪器", "安全操作", "危险标识", "废液处理", "个人防护"],
                    formulas: ["安全第一", "规范操作", "废物分类", "应急预案"]
                )
            ]
        case "matter_properties":
            return [
                ConcreteTopic(
                    id: "pure_mixture",
                    title: "纯净物与混合物",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "纯净物/混合物、物理性质/化学性质",
                    difficulty: "基础",
                    concepts: ["纯净物", "混合物", "物理性质", "化学性质", "分离方法"],
                    formulas: ["无化学公式", "性质差异", "分离原理", "提纯技术"]
                ),
                ConcreteTopic(
                    id: "separation_purification",
                    title: "分离与提纯",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "过滤、蒸发、蒸馏、萃取、结晶、简单色谱",
                    difficulty: "基础",
                    concepts: ["过滤", "蒸发", "蒸馏", "萃取", "结晶", "色谱"],
                    formulas: ["无化学公式", "物理分离", "溶解度差异", "沸点差异"]
                )
            ]
        case "solution_basics":
            return [
                ConcreteTopic(
                    id: "dissolution_solubility",
                    title: "溶解与溶解度",
                    subtitle: "化学",
                    icon: "💧",
                    description: "溶解/溶解度、饱和/不饱和溶液、影响因素（温度、搅拌、粒度）",
                    difficulty: "基础",
                    concepts: ["溶解", "溶解度", "饱和溶液", "不饱和溶液", "影响因素"],
                    formulas: ["溶解度 = 溶质质量/溶剂质量", "温度影响", "搅拌影响", "粒度影响"]
                )
            ]
        case "particle_view_formula":
            return [
                ConcreteTopic(
                    id: "atoms_molecules_ions",
                    title: "原子、分子、离子",
                    subtitle: "化学",
                    icon: "⚛️",
                    description: "原子、分子、离子概念、元素与同位素",
                    difficulty: "基础",
                    concepts: ["原子", "分子", "离子", "元素", "同位素"],
                    formulas: ["原子序数", "质量数", "电荷数", "电子数"]
                ),
                ConcreteTopic(
                    id: "chemical_symbols_formulas",
                    title: "化学符号与化学式",
                    subtitle: "化学",
                    icon: "🔤",
                    description: "化学符号、化学式与式量、化合价与配比",
                    difficulty: "基础",
                    concepts: ["化学符号", "化学式", "式量", "化合价", "配比"],
                    formulas: ["式量计算", "化合价规则", "配平方法"]
                )
            ]
        case "chemical_reactions_equations":
            return [
                ConcreteTopic(
                    id: "mass_conservation",
                    title: "质量守恒定律",
                    subtitle: "化学",
                    icon: "⚖️",
                    description: "质量守恒定律、化学方程式的书写与配平",
                    difficulty: "中等",
                    concepts: ["质量守恒", "化学方程式", "配平", "反应物", "生成物"],
                    formulas: ["反应物质量 = 生成物质量", "配平系数", "原子守恒"]
                ),
                ConcreteTopic(
                    id: "reaction_types",
                    title: "反应类型",
                    subtitle: "化学",
                    icon: "🔄",
                    description: "化合/分解/置换/复分解、热化学反应（放/吸热）",
                    difficulty: "中等",
                    concepts: ["化合反应", "分解反应", "置换反应", "复分解反应", "热效应"],
                    formulas: ["A + B → AB", "AB → A + B", "A + BC → AC + B", "AB + CD → AD + CB"]
                )
            ]
        case "acid_base_salt":
            return [
                ConcreteTopic(
                    id: "acid_base_properties",
                    title: "酸碱性质",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "酸、碱、盐的性质与相互转化、中和反应",
                    difficulty: "中等",
                    concepts: ["酸的性质", "碱的性质", "盐的性质", "相互转化", "中和反应"],
                    formulas: ["酸 + 碱 → 盐 + 水", "pH值", "指示剂变色"]
                ),
                ConcreteTopic(
                    id: "acid_base_strength",
                    title: "酸碱强弱",
                    subtitle: "化学",
                    icon: "📊",
                    description: "酸碱强弱与指示剂（石蕊、酚酞等）、滴定基本操作",
                    difficulty: "中等",
                    concepts: ["酸碱强弱", "指示剂", "石蕊", "酚酞", "滴定操作"],
                    formulas: ["pH = -log[H⁺]", "pOH = -log[OH⁻]", "pH + pOH = 14"]
                )
            ]
        case "atomic_structure_periodic":
            return [
                ConcreteTopic(
                    id: "electron_configuration",
                    title: "电子排布",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "电子排布、核外电子层与副层、价电子与化学性质",
                    difficulty: "中等",
                    concepts: ["电子排布", "电子层", "副层", "价电子", "化学性质"],
                    formulas: ["2n²", "s、p、d、f轨道", "价电子数", "最外层电子"]
                ),
                ConcreteTopic(
                    id: "periodic_trends",
                    title: "周期律与周期性",
                    subtitle: "化学",
                    icon: "📈",
                    description: "周期律与周期性、原子半径、电离能、电负性、金属性/非金属性的趋势",
                    difficulty: "中等",
                    concepts: ["周期律", "周期性", "原子半径", "电离能", "电负性"],
                    formulas: ["原子半径变化", "电离能变化", "电负性变化", "金属性变化"]
                )
            ]
        case "chemical_bonds_structure":
            return [
                ConcreteTopic(
                    id: "bond_types",
                    title: "化学键类型",
                    subtitle: "化学",
                    icon: "🔗",
                    description: "离子键、共价键、金属键、价键理论与八隅体规则",
                    difficulty: "中等",
                    concepts: ["离子键", "共价键", "金属键", "价键理论", "八隅体规则"],
                    formulas: ["离子键形成", "共价键形成", "电子对共享", "八电子稳定"]
                ),
                ConcreteTopic(
                    id: "molecular_forces",
                    title: "分子间作用力",
                    subtitle: "化学",
                    icon: "💫",
                    description: "极性/非极性键、分子极性、分子间作用力（氢键、偶极-偶极、色散力）",
                    difficulty: "中等",
                    concepts: ["极性键", "非极性键", "分子极性", "氢键", "范德华力"],
                    formulas: ["偶极矩", "氢键强度", "色散力大小"]
                )
            ]
        case "gas_state_equation":
            return [
                ConcreteTopic(
                    id: "ideal_gas_law",
                    title: "理想气体方程",
                    subtitle: "化学",
                    icon: "📊",
                    description: "理想气体方程pV=nRT的应用、等温/等压/等容变化定性分析",
                    difficulty: "中等",
                    concepts: ["理想气体", "状态方程", "等温变化", "等压变化", "等容变化"],
                    formulas: ["pV = nRT", "p₁V₁ = p₂V₂", "V₁/T₁ = V₂/T₂", "p₁/T₁ = p₂/T₂"]
                )
            ]
        case "thermochemistry_basic":
            return [
                ConcreteTopic(
                    id: "reaction_heat_enthalpy",
                    title: "反应热与焓变",
                    subtitle: "化学",
                    icon: "🔥",
                    description: "反应热与焓变、量热法、亥斯定律的应用",
                    difficulty: "中等",
                    concepts: ["反应热", "焓变", "量热法", "亥斯定律", "热化学方程式"],
                    formulas: ["ΔH = H生成物 - H反应物", "q = mcΔT", "ΔH = ΣΔH生成物 - ΣΔH反应物"]
                )
            ]
        case "reaction_rate":
            return [
                ConcreteTopic(
                    id: "rate_definition_measurement",
                    title: "速率定义与测定",
                    subtitle: "化学",
                    icon: "⚡",
                    description: "速率的定义与测定方式、温度、浓度、催化剂、表面积的影响",
                    difficulty: "中等",
                    concepts: ["反应速率", "速率测定", "影响因素", "温度", "浓度"],
                    formulas: ["v = Δc/Δt", "阿伦尼乌斯方程", "活化能", "碰撞理论"]
                )
            ]
        case "chemical_equilibrium_basic":
            return [
                ConcreteTopic(
                    id: "reversible_reactions",
                    title: "可逆反应与平衡",
                    subtitle: "化学",
                    icon: "⚖️",
                    description: "可逆反应与平衡常数、勒沙特列原理、温度、压强、浓度变化对平衡的影响",
                    difficulty: "中等",
                    concepts: ["可逆反应", "化学平衡", "平衡常数", "勒沙特列原理", "平衡移动"],
                    formulas: ["Kc = [C]ᶜ[D]ᵈ/[A]ᵃ[B]ᵇ", "Q与K比较", "平衡移动方向"]
                )
            ]
        case "electrolyte_acid_base":
            return [
                ConcreteTopic(
                    id: "strong_weak_electrolytes",
                    title: "强/弱电解质",
                    subtitle: "化学",
                    icon: "⚡",
                    description: "强/弱电解质、电离平衡与电导概念、酸碱理论、pH与指示剂",
                    difficulty: "中等",
                    concepts: ["强电解质", "弱电解质", "电离平衡", "电导", "pH值"],
                    formulas: ["Ka = [H⁺][A⁻]/[HA]", "Kb = [OH⁻][HB⁺]/[B]", "pH = -log[H⁺]"]
                )
            ]
        case "solubility_equilibrium":
            return [
                ConcreteTopic(
                    id: "solubility_product",
                    title: "溶度积",
                    subtitle: "化学",
                    icon: "💧",
                    description: "溶度积Ksp、共离子效应、沉淀溶解判据、选择性沉淀与分离",
                    difficulty: "高级",
                    concepts: ["溶度积", "共离子效应", "沉淀溶解", "选择性沉淀", "分离方法"],
                    formulas: ["Ksp = [A⁺]ᵃ[B⁻]ᵇ", "Qsp与Ksp比较", "沉淀条件"]
                )
            ]
        case "acid_base_equilibrium":
            return [
                ConcreteTopic(
                    id: "weak_acid_base_ionization",
                    title: "弱酸弱碱电离",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "弱酸/弱碱的电离常数、pKa/pKb、Henderson–Hasselbalch公式与缓冲溶液",
                    difficulty: "高级",
                    concepts: ["弱酸电离", "弱碱电离", "电离常数", "pKa", "pKb", "缓冲溶液"],
                    formulas: ["Ka = [H⁺][A⁻]/[HA]", "Kb = [OH⁻][HB⁺]/[B]", "pH = pKa + log([A⁻]/[HA])"]
                )
            ]
        case "chemical_kinetics_advanced":
            return [
                ConcreteTopic(
                    id: "rate_equations",
                    title: "速率方程",
                    subtitle: "化学",
                    icon: "📊",
                    description: "速率方程、反应级数与半衰期、阿伦尼乌斯方程、活化能的实验求取",
                    difficulty: "高级",
                    concepts: ["速率方程", "反应级数", "半衰期", "阿伦尼乌斯方程", "活化能"],
                    formulas: ["v = k[A]ᵃ[B]ᵇ", "t₁/₂ = ln2/k", "k = Ae^(-Ea/RT)"]
                )
            ]
        case "electrochemistry":
            return [
                ConcreteTopic(
                    id: "galvanic_electrolytic_cells",
                    title: "原电池与电解池",
                    subtitle: "化学",
                    icon: "🔋",
                    description: "原电池/电解池、电极反应、标准电极电势、能斯特方程、电解与法拉第定律",
                    difficulty: "高级",
                    concepts: ["原电池", "电解池", "电极反应", "电极电势", "能斯特方程"],
                    formulas: ["E = E° - (RT/nF)lnQ", "ΔG° = -nFE°", "m = (M/nF)Q"]
                )
            ]
        case "organic_chemistry_basic":
            return [
                ConcreteTopic(
                    id: "naming_isomerism",
                    title: "命名与同分异构",
                    subtitle: "化学",
                    icon: "⚛️",
                    description: "命名与同分异构（结构/位置/官能团/构象）、烷烃、烯烃、炔烃、芳香烃",
                    difficulty: "高级",
                    concepts: ["有机命名", "同分异构", "结构异构", "位置异构", "官能团异构"],
                    formulas: ["IUPAC命名规则", "同分异构体数量", "构象分析"]
                ),
                ConcreteTopic(
                    id: "functional_groups",
                    title: "官能团与性质",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "卤代烃、醇、醛酮、羧酸及其衍生物、官能团识别与性质对比",
                    difficulty: "高级",
                    concepts: ["卤代烃", "醇", "醛", "酮", "羧酸", "酯"],
                    formulas: ["取代反应", "加成反应", "氧化反应", "还原反应", "酯化反应"]
                )
            ]
        case "polymers_materials":
            return [
                ConcreteTopic(
                    id: "polymerization_reactions",
                    title: "聚合反应",
                    subtitle: "化学",
                    icon: "🔗",
                    description: "加聚/缩聚反应、常见聚合物性质与应用、材料化学：陶瓷、半导体、复合材料",
                    difficulty: "高级",
                    concepts: ["加聚反应", "缩聚反应", "聚合物", "陶瓷", "半导体", "复合材料"],
                    formulas: ["nA → (A)ₙ", "加聚机理", "缩聚机理", "材料性能"]
                )
            ]
        case "organic_chemistry_advanced":
            return [
                ConcreteTopic(
                    id: "reaction_mechanisms",
                    title: "反应机理",
                    subtitle: "化学",
                    icon: "⚛️",
                    description: "反应机理与选择性、区域/立体选择性、E/Z与R/S、芳香性与取代定位规则",
                    difficulty: "高级",
                    concepts: ["反应机理", "区域选择性", "立体选择性", "E/Z构型", "R/S构型"],
                    formulas: ["亲电加成", "亲核取代", "自由基反应", "立体化学"]
                )
            ]
        case "analytical_chemistry":
            return [
                ConcreteTopic(
                    id: "volumetric_analysis",
                    title: "容量分析",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "酸碱滴定、配位滴定（EDTA）、氧化还原滴定（KMnO₄、K₂Cr₂O₇）",
                    difficulty: "高级",
                    concepts: ["容量分析", "酸碱滴定", "配位滴定", "氧化还原滴定", "滴定曲线"],
                    formulas: ["c₁V₁ = c₂V₂", "滴定终点", "指示剂选择", "误差分析"]
                ),
                ConcreteTopic(
                    id: "spectroscopic_analysis",
                    title: "光谱分析",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "IR识别官能团、¹H NMR/¹³C NMR化学位移与裂分、MS分子峰",
                    difficulty: "高级",
                    concepts: ["红外光谱", "核磁共振", "质谱", "官能团识别", "结构解析"],
                    formulas: ["化学位移", "裂分模式", "分子离子峰", "碎片离子"]
                )
            ]
        case "chemical_thermodynamics":
            return [
                ConcreteTopic(
                    id: "spontaneity_criteria",
                    title: "自发性判据",
                    subtitle: "化学",
                    icon: "🔥",
                    description: "ΔH、ΔS、ΔG与反应自发性判据、ΔG°与平衡常数的关系、温度对K的影响",
                    difficulty: "高级",
                    concepts: ["焓变", "熵变", "吉布斯自由能", "自发性", "平衡常数"],
                    formulas: ["ΔG = ΔH - TΔS", "ΔG° = -RTlnK", "范特霍夫方程"]
                )
            ]
        case "electrochemistry_energy":
            return [
                ConcreteTopic(
                    id: "battery_types",
                    title: "电池类型",
                    subtitle: "化学",
                    icon: "🔋",
                    description: "二次电池工作原理与比较、燃料电池与电极催化、超级电容、腐蚀机理与防护",
                    difficulty: "高级",
                    concepts: ["锂离子电池", "铅酸电池", "镍氢电池", "燃料电池", "超级电容"],
                    formulas: ["电池反应", "电极电势", "容量计算", "循环寿命"]
                )
            ]
        case "green_sustainable_chemistry":
            return [
                ConcreteTopic(
                    id: "green_chemistry_principles",
                    title: "绿色化学原则",
                    subtitle: "化学",
                    icon: "🌱",
                    description: "原子经济性、危害最小化、可再生原料、能效、可降解材料、环境化学与治理",
                    difficulty: "高级",
                    concepts: ["原子经济性", "危害最小化", "可再生原料", "能效", "可降解材料"],
                    formulas: ["原子经济性 = 目标产物质量/反应物质量", "环境友好", "可持续发展"]
                )
            ]
        case "comprehensive_experiment":
            return [
                ConcreteTopic(
                    id: "experiment_design",
                    title: "实验设计",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "实验设计、变量控制、空白/对照、重复性与灵敏度、数据处理",
                    difficulty: "高级",
                    concepts: ["实验设计", "变量控制", "空白对照", "重复性", "灵敏度"],
                    formulas: ["有效数字", "不确定度评估", "线性拟合", "误差分析"]
                ),
                ConcreteTopic(
                    id: "safety_culture",
                    title: "安全文化",
                    subtitle: "化学",
                    icon: "⚠️",
                    description: "化学品分类与SDS、个人防护、废弃物管理、常见操作要点",
                    difficulty: "高级",
                    concepts: ["化学品分类", "SDS", "个人防护", "废弃物管理", "安全操作"],
                    formulas: ["安全第一", "规范操作", "废物分类", "应急预案"]
                )
            ]
        
        // 生物知识点
        case "life_characteristics_scientific_method":
            return [
                ConcreteTopic(
                    id: "life_characteristics",
                    title: "生命体共同特征",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "代谢、生长、繁殖、应激、遗传与进化",
                    difficulty: "基础",
                    concepts: ["代谢", "生长", "繁殖", "应激", "遗传", "进化"],
                    formulas: ["无生物公式", "生命特征观察", "实验验证", "科学方法"]
                ),
                ConcreteTopic(
                    id: "scientific_inquiry",
                    title: "科学探究",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "变量控制、对照实验、数据记录与基本统计",
                    difficulty: "基础",
                    concepts: ["变量控制", "对照实验", "数据记录", "基本统计", "科学方法"],
                    formulas: ["实验设计", "数据收集", "统计分析", "结论得出"]
                ),
                ConcreteTopic(
                    id: "microscope_usage",
                    title: "显微镜使用",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "显微镜结构与使用、放大倍数计算与切片制备",
                    difficulty: "基础",
                    concepts: ["显微镜结构", "使用方法", "放大倍数", "切片制备", "观察技巧"],
                    formulas: ["总放大倍数 = 目镜放大倍数 × 物镜放大倍数", "分辨率计算"]
                )
            ]
        case "cells_biomolecules":
            return [
                ConcreteTopic(
                    id: "cell_theory",
                    title: "细胞学说",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "细胞学说、原核/真核差异、细胞膜、质、核的基本功能",
                    difficulty: "基础",
                    concepts: ["细胞学说", "原核细胞", "真核细胞", "细胞膜", "细胞质", "细胞核"],
                    formulas: ["细胞基本单位", "结构差异", "功能特点"]
                ),
                ConcreteTopic(
                    id: "cell_organelles",
                    title: "细胞器功能",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "主要细胞器（叶绿体、线粒体、液泡、内质网、高尔基体、核糖体等）的入门认识",
                    difficulty: "基础",
                    concepts: ["叶绿体", "线粒体", "液泡", "内质网", "高尔基体", "核糖体"],
                    formulas: ["细胞器功能", "结构特点", "相互协作"]
                ),
                ConcreteTopic(
                    id: "biomolecules",
                    title: "生物大分子",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "糖类、脂质、蛋白质、核酸的组成与功能",
                    difficulty: "基础",
                    concepts: ["糖类", "脂质", "蛋白质", "核酸", "组成", "功能"],
                    formulas: ["分子结构", "功能关系", "代谢途径"]
                ),
                ConcreteTopic(
                    id: "membrane_transport",
                    title: "物质跨膜运输",
                    subtitle: "生物",
                    icon: "🔄",
                    description: "扩散、渗透（选择透过性概念）",
                    difficulty: "基础",
                    concepts: ["扩散", "渗透", "选择透过性", "浓度梯度", "膜结构"],
                    formulas: ["扩散速率", "渗透压", "浓度差影响"]
                )
            ]
        case "tissue_organ_system":
            return [
                ConcreteTopic(
                    id: "plant_tissues_organs",
                    title: "植物组织与器官",
                    subtitle: "生物",
                    icon: "🌿",
                    description: "分生/基本/输导组织、根、茎、叶、花、果、种子的结构与功能",
                    difficulty: "基础",
                    concepts: ["分生组织", "基本组织", "输导组织", "根", "茎", "叶", "花", "果实", "种子"],
                    formulas: ["组织功能", "器官结构", "生长发育"]
                ),
                ConcreteTopic(
                    id: "animal_tissues_systems",
                    title: "动物组织与系统",
                    subtitle: "生物",
                    icon: "🫀",
                    description: "上皮、结缔、肌、神经组织、消化、循环、呼吸、排泄、神经/内分泌系统概览",
                    difficulty: "基础",
                    concepts: ["上皮组织", "结缔组织", "肌肉组织", "神经组织", "消化系统", "循环系统", "呼吸系统", "排泄系统", "神经系统", "内分泌系统"],
                    formulas: ["组织特点", "系统功能", "协调工作"]
                ),
                ConcreteTopic(
                    id: "homeostasis_concept",
                    title: "稳态概念",
                    subtitle: "生物",
                    icon: "⚖️",
                    description: "稳态概念与体内环境（定性）",
                    difficulty: "基础",
                    concepts: ["稳态", "体内环境", "平衡调节", "反馈机制", "适应性"],
                    formulas: ["稳态维持", "调节机制", "平衡状态"]
                )
            ]
        case "ecology_basics":
            return [
                ConcreteTopic(
                    id: "ecosystem_composition",
                    title: "生态系统组成",
                    subtitle: "生物",
                    icon: "🌍",
                    description: "生产者/消费者/分解者、能量流动与物质循环",
                    difficulty: "基础",
                    concepts: ["生产者", "消费者", "分解者", "能量流动", "物质循环", "生态平衡"],
                    formulas: ["能量传递效率", "物质循环路径", "生态系统稳定性"]
                ),
                ConcreteTopic(
                    id: "food_chains_webs",
                    title: "食物链与食物网",
                    subtitle: "生物",
                    icon: "🕸️",
                    description: "食物链/食物网、能量金字塔与生态效率",
                    difficulty: "基础",
                    concepts: ["食物链", "食物网", "能量金字塔", "生态效率", "营养级", "能量损失"],
                    formulas: ["能量传递效率 = 10%", "营养级数量", "能量金字塔形状"]
                ),
                ConcreteTopic(
                    id: "population_community",
                    title: "种群与群落",
                    subtitle: "生物",
                    icon: "👥",
                    description: "种群特征（数量、密度、年龄结构）与增长曲线、群落演替与生态位",
                    difficulty: "基础",
                    concepts: ["种群数量", "种群密度", "年龄结构", "增长曲线", "群落演替", "生态位"],
                    formulas: ["种群密度 = 个体数/面积", "增长率计算", "生态位宽度"]
                )
            ]
        case "genetics_variation":
            return [
                ConcreteTopic(
                    id: "genes_alleles",
                    title: "基因与等位基因",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "基因、等位基因、基因型/表现型、孟德尔分离律与自由组合律",
                    difficulty: "中等",
                    concepts: ["基因", "等位基因", "基因型", "表现型", "分离律", "自由组合律"],
                    formulas: ["基因型比例", "表现型比例", "遗传概率计算"]
                ),
                ConcreteTopic(
                    id: "meiosis_genetic_diagrams",
                    title: "减数分裂与遗传图解",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "减数分裂与遗传图解、联锁与交换（入门）、人类遗传与家系图阅读",
                    difficulty: "中等",
                    concepts: ["减数分裂", "遗传图解", "联锁", "交换", "人类遗传", "家系图"],
                    formulas: ["减数分裂过程", "遗传图解绘制", "家系图分析"]
                ),
                ConcreteTopic(
                    id: "variation_sources",
                    title: "变异来源",
                    subtitle: "生物",
                    icon: "🔄",
                    description: "变异来源：基因突变、染色体异常（入门）",
                    difficulty: "中等",
                    concepts: ["基因突变", "染色体异常", "变异类型", "变异频率", "变异意义"],
                    formulas: ["突变频率", "变异率计算", "遗传变异分析"]
                )
            ]
        case "metabolism_photosynthesis_respiration":
            return [
                ConcreteTopic(
                    id: "photosynthesis",
                    title: "光合作用",
                    subtitle: "生物",
                    icon: "🌱",
                    description: "光反应与碳反应（C₃/C₄/CAM了解）、影响因素、叶绿体结构",
                    difficulty: "中等",
                    concepts: ["光反应", "碳反应", "C₃植物", "C₄植物", "CAM植物", "叶绿体结构", "影响因素"],
                    formulas: ["光合作用方程式", "光能转化", "CO₂固定途径"]
                ),
                ConcreteTopic(
                    id: "cellular_respiration",
                    title: "细胞呼吸",
                    subtitle: "生物",
                    icon: "🫁",
                    description: "有氧/无氧、ATP概念与能量转化、线粒体结构",
                    difficulty: "中等",
                    concepts: ["有氧呼吸", "无氧呼吸", "ATP", "能量转化", "线粒体结构", "呼吸过程"],
                    formulas: ["呼吸作用方程式", "ATP生成量", "能量转化效率"]
                ),
                ConcreteTopic(
                    id: "enzyme_nature_function",
                    title: "酶的本质与作用",
                    subtitle: "生物",
                    icon: "⚡",
                    description: "酶的本质与作用特点、温度/pH/底物浓度对酶活性影响",
                    difficulty: "中等",
                    concepts: ["酶的本质", "作用特点", "温度影响", "pH影响", "底物浓度影响", "酶活性"],
                    formulas: ["酶活性测定", "最适温度", "最适pH", "米氏方程"]
                )
            ]
        case "cell_structure_function_advanced":
            return [
                ConcreteTopic(
                    id: "biomembrane_system",
                    title: "生物膜系统",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "生物膜系统与跨膜运输（易化扩散、主动运输、胞吞/胞吐）",
                    difficulty: "中等",
                    concepts: ["生物膜系统", "易化扩散", "主动运输", "胞吞", "胞吐", "膜结构"],
                    formulas: ["运输速率", "能量消耗", "浓度梯度"]
                ),
                ConcreteTopic(
                    id: "cytoskeleton_cell_cycle",
                    title: "细胞骨架与细胞周期",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "细胞骨架、细胞周期与有丝分裂（分裂各期识别与意义）",
                    difficulty: "中等",
                    concepts: ["细胞骨架", "微管", "微丝", "中间纤维", "细胞周期", "有丝分裂", "分裂期"],
                    formulas: ["细胞周期时间", "分裂期比例", "染色体数量变化"]
                ),
                ConcreteTopic(
                    id: "surface_volume_ratio",
                    title: "表面积/体积比",
                    subtitle: "生物",
                    icon: "📊",
                    description: "表面积/体积比对物质运输和代谢效率的影响",
                    difficulty: "中等",
                    concepts: ["表面积", "体积", "表面积/体积比", "物质运输", "代谢效率", "细胞大小"],
                    formulas: ["表面积/体积比 = 表面积/体积", "运输效率", "代谢速率"]
                )
            ]
        case "physiology_homeostasis":
            return [
                ConcreteTopic(
                    id: "plant_physiology",
                    title: "植物生理",
                    subtitle: "生物",
                    icon: "🌿",
                    description: "蒸腾作用、矿质吸收、水分运输、植物激素（生长素等）与向性",
                    difficulty: "中等",
                    concepts: ["蒸腾作用", "矿质吸收", "水分运输", "植物激素", "生长素", "向性", "向光性", "向地性"],
                    formulas: ["蒸腾速率", "水分运输速度", "激素浓度效应"]
                ),
                ConcreteTopic(
                    id: "animal_physiology",
                    title: "动物生理",
                    subtitle: "生物",
                    icon: "🫀",
                    description: "体液、内环境与稳态、神经调节与体液调节的协同、渗透调节与排泄、体温调节",
                    difficulty: "中等",
                    concepts: ["体液", "内环境", "稳态", "神经调节", "体液调节", "渗透调节", "排泄", "体温调节"],
                    formulas: ["体液平衡", "调节机制", "反馈控制"]
                )
            ]
        case "molecular_genetics_biotechnology":
            return [
                ConcreteTopic(
                    id: "dna_structure_function",
                    title: "DNA结构与功能",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "DNA双螺旋与染色质、复制、转录、翻译、基因表达调控（原核/真核差异）",
                    difficulty: "高级",
                    concepts: ["DNA双螺旋", "染色质", "DNA复制", "转录", "翻译", "基因表达调控", "原核生物", "真核生物"],
                    formulas: ["碱基配对", "复制准确性", "转录效率", "翻译速率"]
                ),
                ConcreteTopic(
                    id: "mutation_repair",
                    title: "突变与修复",
                    subtitle: "生物",
                    icon: "🔄",
                    description: "突变与修复、染色体结构变异与基因组概览",
                    difficulty: "高级",
                    concepts: ["基因突变", "DNA修复", "染色体变异", "基因组", "变异类型", "修复机制"],
                    formulas: ["突变率", "修复效率", "变异频率"]
                ),
                ConcreteTopic(
                    id: "biotechnology_principles",
                    title: "生物技术原理",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "PCR、限制性内切酶、质粒载体、克隆、测序、转基因与基因编辑（CRISPR）原理与伦理",
                    difficulty: "高级",
                    concepts: ["PCR", "限制性内切酶", "质粒载体", "克隆", "测序", "转基因", "基因编辑", "CRISPR", "伦理问题"],
                    formulas: ["PCR扩增倍数", "酶切效率", "克隆成功率"]
                )
            ]
        case "ecosystem_behavior":
            return [
                ConcreteTopic(
                    id: "community_diversity",
                    title: "群落多样性",
                    subtitle: "生物",
                    icon: "🌍",
                    description: "群落多样性、关键种、物种间关系（竞争/互利/捕食/寄生）",
                    difficulty: "高级",
                    concepts: ["群落多样性", "关键种", "竞争关系", "互利关系", "捕食关系", "寄生关系", "物种丰富度"],
                    formulas: ["多样性指数", "物种丰富度", "关系强度"]
                ),
                ConcreteTopic(
                    id: "population_dynamics",
                    title: "种群动力学",
                    subtitle: "生物",
                    icon: "📈",
                    description: "种群动力学：指数/逻辑斯谛模型、r/K选择策略、密度制约",
                    difficulty: "高级",
                    concepts: ["指数增长", "逻辑斯谛增长", "r选择", "K选择", "密度制约", "种群调节", "增长模型"],
                    formulas: ["指数增长方程", "逻辑斯谛方程", "r值计算", "K值确定"]
                ),
                ConcreteTopic(
                    id: "behavioral_ecology",
                    title: "行为生态学",
                    subtitle: "生物",
                    icon: "🧠",
                    description: "行为生态学：先天行为/学习行为、信号与通讯、最优化理论、社会行为",
                    difficulty: "高级",
                    concepts: ["先天行为", "学习行为", "信号通讯", "最优化理论", "社会行为", "行为适应", "行为进化"],
                    formulas: ["行为频率", "学习曲线", "适应度计算"]
                )
            ]
        case "evolution_speciation":
            return [
                ConcreteTopic(
                    id: "evolutionary_forces",
                    title: "进化驱动力",
                    subtitle: "生物",
                    icon: "🦕",
                    description: "进化驱动力：自然选择、性选择、遗传漂变、基因流、突变",
                    difficulty: "高级",
                    concepts: ["自然选择", "性选择", "遗传漂变", "基因流", "突变", "选择压力", "适应度"],
                    formulas: ["选择系数", "遗传漂变强度", "基因流速率"]
                ),
                ConcreteTopic(
                    id: "species_concept_isolation",
                    title: "物种概念与隔离",
                    subtitle: "生物",
                    icon: "🔒",
                    description: "物种概念与生殖隔离、适应与趋同/分歧进化",
                    difficulty: "高级",
                    concepts: ["物种概念", "生殖隔离", "地理隔离", "生态隔离", "趋同进化", "分歧进化", "适应"],
                    formulas: ["隔离指数", "分化程度", "进化速率"]
                ),
                ConcreteTopic(
                    id: "phylogeny_molecular_clock",
                    title: "系统发生与分子钟",
                    subtitle: "生物",
                    icon: "🕰️",
                    description: "系统发生、同源/同功结构、分子钟与系统发育树解读",
                    difficulty: "高级",
                    concepts: ["系统发生", "同源结构", "同功结构", "分子钟", "系统发育树", "进化关系", "共同祖先"],
                    formulas: ["分子钟速率", "分歧时间", "进化距离"]
                )
            ]
        case "human_physiology_special":
            return [
                ConcreteTopic(
                    id: "circulatory_system",
                    title: "循环系统",
                    subtitle: "生物",
                    icon: "🫀",
                    description: "心动周期、血压调控、血液成分与免疫基础",
                    difficulty: "高级",
                    concepts: ["心动周期", "血压调控", "血液成分", "免疫基础", "心脏功能", "血管调节", "血液循环"],
                    formulas: ["心率", "血压", "心输出量", "血流速度"]
                ),
                ConcreteTopic(
                    id: "respiratory_system",
                    title: "呼吸系统",
                    subtitle: "生物",
                    icon: "🫁",
                    description: "通气与气体交换、呼吸调节",
                    difficulty: "高级",
                    concepts: ["通气", "气体交换", "呼吸调节", "肺功能", "呼吸中枢", "呼吸频率", "肺活量"],
                    formulas: ["通气量", "气体交换效率", "呼吸商"]
                ),
                ConcreteTopic(
                    id: "digestive_system",
                    title: "消化系统",
                    subtitle: "生物",
                    icon: "🍽️",
                    description: "消化与吸收、营养代谢与能量平衡",
                    difficulty: "高级",
                    concepts: ["消化", "吸收", "营养代谢", "能量平衡", "消化酶", "吸收效率", "营养需求"],
                    formulas: ["消化率", "吸收率", "能量消耗", "营养利用率"]
                ),
                ConcreteTopic(
                    id: "urinary_system",
                    title: "泌尿系统",
                    subtitle: "生物",
                    icon: "💧",
                    description: "肾单位结构、滤过/重吸收/分泌与渗透调节",
                    difficulty: "高级",
                    concepts: ["肾单位", "滤过", "重吸收", "分泌", "渗透调节", "尿液形成", "水盐平衡"],
                    formulas: ["滤过率", "重吸收率", "尿液浓度", "渗透压"]
                ),
                ConcreteTopic(
                    id: "neuroendocrine_integration",
                    title: "神经-内分泌整合",
                    subtitle: "生物",
                    icon: "🧠",
                    description: "下丘脑—垂体—靶腺轴、负反馈调控",
                    difficulty: "高级",
                    concepts: ["下丘脑", "垂体", "靶腺", "激素轴", "负反馈", "神经调节", "内分泌调节"],
                    formulas: ["激素水平", "反馈强度", "调节效率"]
                ),
                ConcreteTopic(
                    id: "immune_system",
                    title: "免疫系统",
                    subtitle: "生物",
                    icon: "🛡️",
                    description: "非特异/特异免疫、体液/细胞免疫、疫苗与免疫记忆",
                    difficulty: "高级",
                    concepts: ["非特异免疫", "特异免疫", "体液免疫", "细胞免疫", "疫苗", "免疫记忆", "免疫应答"],
                    formulas: ["抗体水平", "免疫细胞数量", "免疫应答强度"]
                )
            ]
        case "scientific_inquiry_biosafety":
            return [
                ConcreteTopic(
                    id: "experiment_design_bio",
                    title: "实验设计",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "变量控制、对照/空白、重复性与灵敏度",
                    difficulty: "高级",
                    concepts: ["变量控制", "对照实验", "空白实验", "重复性", "灵敏度", "实验设计", "数据收集"],
                    formulas: ["实验误差", "重复性指标", "灵敏度测定"]
                ),
                ConcreteTopic(
                    id: "data_processing_bio",
                    title: "数据处理",
                    subtitle: "生物",
                    icon: "📊",
                    description: "有效数字、误差/不确定度、卡方检验等基础统计",
                    difficulty: "高级",
                    concepts: ["有效数字", "误差", "不确定度", "卡方检验", "统计分析", "数据可靠性"],
                    formulas: ["误差计算", "不确定度评估", "卡方检验", "显著性水平"]
                ),
                ConcreteTopic(
                    id: "biosafety_ethics",
                    title: "生物安全与伦理",
                    subtitle: "生物",
                    icon: "⚠️",
                    description: "生物安全与伦理、人类受试者保护、动物福利、环境与转基因安全",
                    difficulty: "高级",
                    concepts: ["生物安全", "伦理原则", "人类受试者保护", "动物福利", "环境安全", "转基因安全", "风险评估"],
                    formulas: ["安全等级", "风险评估", "伦理审查"]
                )
            ]
        
        // 数学知识点
        case "numbers_expressions":
            return [
                ConcreteTopic(
                    id: "integer_fraction_operations",
                    title: "整数与分数运算",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "整数与分数的运算、约分通分、幂与开方（平方/立方入门）",
                    difficulty: "基础",
                    concepts: ["整数运算", "分数运算", "约分", "通分", "幂运算", "开方"],
                    formulas: ["a + b = b + a", "a × b = b × a", "a² = a × a", "√a² = |a|"]
                ),
                ConcreteTopic(
                    id: "factors_multiples",
                    title: "因数与倍数",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "因数与倍数（质因数分解、最大公因数/最小公倍数）",
                    difficulty: "基础",
                    concepts: ["因数", "倍数", "质因数分解", "最大公因数", "最小公倍数", "质数"],
                    formulas: ["质因数分解", "最大公因数", "最小公倍数", "质数判断"]
                ),
                ConcreteTopic(
                    id: "ratio_percentage",
                    title: "比、比例与百分数",
                    subtitle: "数学",
                    icon: "📊",
                    description: "比、比例与百分数（折扣、增长率、利息入门）",
                    difficulty: "基础",
                    concepts: ["比", "比例", "百分数", "折扣", "增长率", "利息"],
                    formulas: ["比例 = a:b", "百分数 = 部分/整体 × 100%", "折扣 = 原价 × 折扣率"]
                ),
                ConcreteTopic(
                    id: "algebraic_expressions",
                    title: "简单代数式与整式运算",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "简单代数式与整式运算（合并同类项、去括号）",
                    difficulty: "基础",
                    concepts: ["代数式", "整式", "同类项", "合并同类项", "去括号", "整式运算"],
                    formulas: ["合并同类项", "去括号法则", "整式加减法"]
                )
            ]
        case "equations_inequalities":
            return [
                ConcreteTopic(
                    id: "linear_equations",
                    title: "一元一次方程",
                    subtitle: "数学",
                    icon: "⚖️",
                    description: "一元一次方程与应用题建模",
                    difficulty: "基础",
                    concepts: ["一元一次方程", "解方程", "应用题建模", "等量关系", "未知数"],
                    formulas: ["ax + b = 0", "x = -b/a", "解方程步骤"]
                ),
                ConcreteTopic(
                    id: "linear_inequalities",
                    title: "一元一次不等式",
                    subtitle: "数学",
                    icon: "⚖️",
                    description: "一元一次不等式（解集表示与数轴）",
                    difficulty: "基础",
                    concepts: ["一元一次不等式", "解不等式", "解集", "数轴表示", "不等式性质"],
                    formulas: ["ax + b > 0", "ax + b < 0", "解集表示"]
                ),
                ConcreteTopic(
                    id: "functions_images_basic",
                    title: "函数与图像（入门）",
                    subtitle: "数学",
                    icon: "📈",
                    description: "变量、函数的基本概念、表格—图像—解析式的对应、直角坐标系与点的表示、象限",
                    difficulty: "基础",
                    concepts: ["变量", "函数", "表格", "图像", "解析式", "直角坐标系", "象限"],
                    formulas: ["函数关系", "坐标表示", "象限判断"]
                )
            ]
        case "geometry_graphics":
            return [
                ConcreteTopic(
                    id: "basic_geometric_concepts",
                    title: "基本几何概念与作图",
                    subtitle: "数学",
                    icon: "📐",
                    description: "基本几何概念与作图：点、线、角，垂线与平行线",
                    difficulty: "基础",
                    concepts: ["点", "线", "角", "垂线", "平行线", "几何作图", "基本概念"],
                    formulas: ["角的大小", "垂线性质", "平行线性质"]
                ),
                ConcreteTopic(
                    id: "triangles_quadrilaterals",
                    title: "三角形与四边形",
                    subtitle: "数学",
                    icon: "📐",
                    description: "三角形与四边形的基本性质（内角和、分类）",
                    difficulty: "基础",
                    concepts: ["三角形", "四边形", "内角和", "分类", "基本性质", "边角关系"],
                    formulas: ["三角形内角和 = 180°", "四边形内角和 = 360°", "分类方法"]
                ),
                ConcreteTopic(
                    id: "circle_basic",
                    title: "圆的认识",
                    subtitle: "数学",
                    icon: "⭕",
                    description: "圆的认识（半径、直径、周长、面积入门）",
                    difficulty: "基础",
                    concepts: ["圆", "半径", "直径", "周长", "面积", "圆心", "圆周"],
                    formulas: ["直径 = 2 × 半径", "周长 = 2πr", "面积 = πr²"]
                ),
                ConcreteTopic(
                    id: "geometric_transformations",
                    title: "图形的变换",
                    subtitle: "数学",
                    icon: "🔄",
                    description: "图形的平移、旋转、对称（轴对称/中心对称）",
                    difficulty: "基础",
                    concepts: ["平移", "旋转", "对称", "轴对称", "中心对称", "变换性质"],
                    formulas: ["平移向量", "旋转角度", "对称轴", "对称中心"]
                )
            ]
        case "statistics_probability_basic":
            return [
                ConcreteTopic(
                    id: "statistical_charts",
                    title: "统计图表",
                    subtitle: "数学",
                    icon: "📊",
                    description: "统计图表：条形图、折线图、扇形图",
                    difficulty: "基础",
                    concepts: ["条形图", "折线图", "扇形图", "统计图表", "数据表示", "图表分析"],
                    formulas: ["图表制作", "数据读取", "图表分析"]
                ),
                ConcreteTopic(
                    id: "central_tendency_measures",
                    title: "集中趋势量数",
                    subtitle: "数学",
                    icon: "📊",
                    description: "平均数、众数、中位数的含义与求法",
                    difficulty: "基础",
                    concepts: ["平均数", "众数", "中位数", "集中趋势", "数据特征", "计算方法"],
                    formulas: ["平均数 = 总和/个数", "众数 = 出现次数最多的数", "中位数 = 中间位置的数"]
                ),
                ConcreteTopic(
                    id: "simple_random_events",
                    title: "简单随机事件",
                    subtitle: "数学",
                    icon: "🎲",
                    description: "简单随机事件与频率",
                    difficulty: "基础",
                    concepts: ["随机事件", "频率", "概率", "事件类型", "频率计算"],
                    formulas: ["频率 = 事件发生次数/总次数", "概率 = 有利事件数/总事件数"]
                )
            ]
        case "algebra_equations":
            return [
                ConcreteTopic(
                    id: "systems_of_linear_equations",
                    title: "二元一次方程组",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "二元一次方程组的解法（代入/加减）与应用",
                    difficulty: "基础",
                    concepts: ["二元一次方程组", "代入法", "加减法", "解方程组", "应用问题"],
                    formulas: ["代入法", "加减法", "解的唯一性", "应用建模"]
                ),
                ConcreteTopic(
                    id: "polynomial_multiplication",
                    title: "整式的乘法",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "整式的乘法与平方公式、分式的基本性质与运算",
                    difficulty: "基础",
                    concepts: ["整式乘法", "平方公式", "分式", "基本性质", "分式运算"],
                    formulas: ["(a+b)² = a²+2ab+b²", "(a-b)² = a²-2ab+b²", "分式加减乘除"]
                ),
                ConcreteTopic(
                    id: "linear_functions",
                    title: "一次函数",
                    subtitle: "数学",
                    icon: "📈",
                    description: "一次函数：概念、斜率、图像与应用",
                    difficulty: "基础",
                    concepts: ["一次函数", "斜率", "图像", "函数性质", "应用问题"],
                    formulas: ["y = kx + b", "斜率k", "截距b", "图像特征"]
                )
            ]
        case "geometry_advanced":
            return [
                ConcreteTopic(
                    id: "parallel_lines",
                    title: "平行线性质与判定",
                    subtitle: "数学",
                    icon: "📐",
                    description: "平行线性质与判定、内错角、同位角、同旁内角",
                    difficulty: "基础",
                    concepts: ["平行线", "性质", "判定", "内错角", "同位角", "同旁内角"],
                    formulas: ["平行线性质", "判定条件", "角度关系"]
                ),
                ConcreteTopic(
                    id: "triangle_congruence",
                    title: "三角形全等",
                    subtitle: "数学",
                    icon: "📐",
                    description: "三角形全等（SAS/ASA/SSS/AAS）及判定应用",
                    difficulty: "基础",
                    concepts: ["三角形全等", "SAS", "ASA", "SSS", "AAS", "判定应用"],
                    formulas: ["全等条件", "判定方法", "应用证明"]
                ),
                ConcreteTopic(
                    id: "pythagorean_theorem",
                    title: "勾股定理",
                    subtitle: "数学",
                    icon: "📐",
                    description: "勾股定理与逆定理，直角三角形应用",
                    difficulty: "基础",
                    concepts: ["勾股定理", "逆定理", "直角三角形", "应用", "证明"],
                    formulas: ["a² + b² = c²", "逆定理", "应用计算"]
                )
            ]
        case "algebra_functions_advanced":
            return [
                ConcreteTopic(
                    id: "quadratic_functions",
                    title: "二次函数",
                    subtitle: "数学",
                    icon: "📈",
                    description: "二次函数：开口、顶点、对称轴、与一次函数/反比例函数综合",
                    difficulty: "中等",
                    concepts: ["二次函数", "开口方向", "顶点", "对称轴", "图像特征", "综合应用"],
                    formulas: ["y = ax² + bx + c", "顶点坐标", "对称轴方程", "开口判断"]
                ),
                ConcreteTopic(
                    id: "factoring_methods",
                    title: "因式分解系统法",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "因式分解系统法（提公因式、公式法、十字相乘等）",
                    difficulty: "中等",
                    concepts: ["因式分解", "提公因式", "公式法", "十字相乘", "分组分解"],
                    formulas: ["提公因式", "平方差公式", "完全平方公式", "十字相乘"]
                ),
                ConcreteTopic(
                    id: "quadratic_equations",
                    title: "一元二次方程",
                    subtitle: "数学",
                    icon: "⚖️",
                    description: "一元二次方程：求根公式与判别式、二次不等式的解法",
                    difficulty: "中等",
                    concepts: ["一元二次方程", "求根公式", "判别式", "二次不等式", "解法"],
                    formulas: ["x = (-b ± √(b²-4ac))/2a", "Δ = b²-4ac", "不等式解法"]
                )
            ]
        case "geometry_trigonometry":
            return [
                ConcreteTopic(
                    id: "similar_triangles",
                    title: "相似三角形",
                    subtitle: "数学",
                    icon: "📐",
                    description: "相似三角形的判定与性质、放缩与比例线段",
                    difficulty: "中等",
                    concepts: ["相似三角形", "判定", "性质", "放缩", "比例线段", "相似比"],
                    formulas: ["相似条件", "相似比", "面积比", "比例关系"]
                ),
                ConcreteTopic(
                    id: "circle_properties",
                    title: "圆的性质",
                    subtitle: "数学",
                    icon: "⭕",
                    description: "圆的性质与切线、弦、圆周角、圆心角、弧长与扇形面积",
                    difficulty: "中等",
                    concepts: ["切线", "弦", "圆周角", "圆心角", "弧长", "扇形面积"],
                    formulas: ["切线性质", "圆周角定理", "弧长公式", "扇形面积公式"]
                ),
                ConcreteTopic(
                    id: "right_triangle_trigonometry",
                    title: "解直角三角形",
                    subtitle: "数学",
                    icon: "📐",
                    description: "解直角三角形：sin、cos、tan的定义与简单应用",
                    difficulty: "中等",
                    concepts: ["正弦", "余弦", "正切", "解直角三角形", "三角函数", "应用"],
                    formulas: ["sin A = 对边/斜边", "cos A = 邻边/斜边", "tan A = 对边/邻边"]
                )
            ]
        case "sets_logic_basic":
            return [
                ConcreteTopic(
                    id: "set_operations",
                    title: "集合表示与运算",
                    subtitle: "数学",
                    icon: "🔗",
                    description: "集合表示与运算（并、交、补）、子集与真子集",
                    difficulty: "中等",
                    concepts: ["集合", "表示方法", "并集", "交集", "补集", "子集", "真子集"],
                    formulas: ["A ∪ B", "A ∩ B", "A'", "A ⊆ B", "A ⊂ B"]
                ),
                ConcreteTopic(
                    id: "propositions_logic",
                    title: "命题与逻辑",
                    subtitle: "数学",
                    icon: "🧠",
                    description: "命题、充分必要条件、简单逻辑推理",
                    difficulty: "中等",
                    concepts: ["命题", "充分条件", "必要条件", "充要条件", "逻辑推理", "真值"],
                    formulas: ["p → q", "p ↔ q", "逻辑运算", "推理规则"]
                )
            ]
        case "functions_equations":
            return [
                ConcreteTopic(
                    id: "function_properties",
                    title: "函数的性质",
                    subtitle: "数学",
                    icon: "📈",
                    description: "函数的性质：定义域、值域、奇偶性、单调性与对称性",
                    difficulty: "中等",
                    concepts: ["定义域", "值域", "奇偶性", "单调性", "对称性", "函数性质"],
                    formulas: ["奇函数: f(-x) = -f(x)", "偶函数: f(-x) = f(x)", "单调性判断"]
                ),
                ConcreteTopic(
                    id: "elementary_functions",
                    title: "基本初等函数",
                    subtitle: "数学",
                    icon: "📈",
                    description: "基本初等函数：幂函数、指数函数、对数函数（运算与图像）",
                    difficulty: "中等",
                    concepts: ["幂函数", "指数函数", "对数函数", "运算", "图像", "性质"],
                    formulas: ["幂函数: y = x^n", "指数函数: y = a^x", "对数函数: y = log_a(x)"]
                )
            ]
        case "trigonometry_basic":
            return [
                ConcreteTopic(
                    id: "angles_radians",
                    title: "任意角与弧度制",
                    subtitle: "数学",
                    icon: "📐",
                    description: "任意角与弧度制、正弦、余弦、正切的定义与图像",
                    difficulty: "中等",
                    concepts: ["任意角", "弧度制", "正弦", "余弦", "正切", "定义", "图像"],
                    formulas: ["弧度 = 角度 × π/180", "sin θ", "cos θ", "tan θ"]
                ),
                ConcreteTopic(
                    id: "trigonometric_identities",
                    title: "三角恒等式",
                    subtitle: "数学",
                    icon: "📐",
                    description: "三角恒等式（同角三角函数关系、诱导公式）、两角和差公式（入门）",
                    difficulty: "中等",
                    concepts: ["三角恒等式", "同角关系", "诱导公式", "和差公式", "证明"],
                    formulas: ["sin²θ + cos²θ = 1", "诱导公式", "sin(A+B) = sinAcosB + cosAsinB"]
                )
            ]
        case "vectors_analytic_geometry":
            return [
                ConcreteTopic(
                    id: "plane_vectors",
                    title: "平面向量",
                    subtitle: "数学",
                    icon: "➡️",
                    description: "平面向量的加减与数乘、基底表示与坐标表示",
                    difficulty: "中等",
                    concepts: ["平面向量", "加减法", "数乘", "基底", "坐标表示", "向量运算"],
                    formulas: ["向量加法", "向量减法", "数乘", "坐标表示"]
                ),
                ConcreteTopic(
                    id: "line_equations",
                    title: "直线方程",
                    subtitle: "数学",
                    icon: "📐",
                    description: "线段的向量表示、点到点/点到直线的距离、直线的方程与位置关系",
                    difficulty: "中等",
                    concepts: ["线段", "向量表示", "距离", "直线方程", "位置关系"],
                    formulas: ["点斜式", "斜截式", "一般式", "距离公式"]
                )
            ]
        case "sequences":
            return [
                ConcreteTopic(
                    id: "arithmetic_geometric_sequences",
                    title: "等差等比数列",
                    subtitle: "数学",
                    icon: "📊",
                    description: "等差、等比数列的通项与前n项和、递推关系入门",
                    difficulty: "中等",
                    concepts: ["等差数列", "等比数列", "通项公式", "前n项和", "递推关系"],
                    formulas: ["等差数列: an = a1 + (n-1)d", "等比数列: an = a1 × q^(n-1)", "求和公式"]
                )
            ]
        case "trigonometry_triangle_solving":
            return [
                ConcreteTopic(
                    id: "advanced_trigonometric_formulas",
                    title: "高级三角公式",
                    subtitle: "数学",
                    icon: "📐",
                    description: "倍角/半角、积化和差与和差化积公式",
                    difficulty: "高级",
                    concepts: ["倍角公式", "半角公式", "积化和差", "和差化积", "公式推导"],
                    formulas: ["sin(2θ) = 2sinθcosθ", "cos(2θ) = cos²θ - sin²θ", "积化和差公式"]
                ),
                ConcreteTopic(
                    id: "sine_cosine_theorems",
                    title: "正弦定理与余弦定理",
                    subtitle: "数学",
                    icon: "📐",
                    description: "正弦定理、余弦定理、面积公式与解三角形综合",
                    difficulty: "高级",
                    concepts: ["正弦定理", "余弦定理", "面积公式", "解三角形", "综合应用"],
                    formulas: ["正弦定理: a/sinA = b/sinB = c/sinC", "余弦定理: c² = a² + b² - 2abcosC"]
                )
            ]
        case "solid_geometry_spatial_concepts":
            return [
                ConcreteTopic(
                    id: "spatial_position_relations",
                    title: "空间位置关系",
                    subtitle: "数学",
                    icon: "🔲",
                    description: "空间点、线、面的位置关系（平行/垂直判定与性质）",
                    difficulty: "高级",
                    concepts: ["空间点", "空间线", "空间面", "平行", "垂直", "判定", "性质"],
                    formulas: ["平行判定", "垂直判定", "位置关系判断"]
                ),
                ConcreteTopic(
                    id: "polyhedra_rotation_bodies",
                    title: "多面体与旋转体",
                    subtitle: "数学",
                    icon: "🔲",
                    description: "多面体与旋转体（棱柱、棱锥、台体、柱体、锥体、球）的表面积与体积",
                    difficulty: "高级",
                    concepts: ["多面体", "旋转体", "棱柱", "棱锥", "台体", "表面积", "体积"],
                    formulas: ["表面积公式", "体积公式", "计算应用"]
                )
            ]
        case "analytic_geometry_conic_sections":
            return [
                ConcreteTopic(
                    id: "conic_sections_equations",
                    title: "圆锥曲线方程",
                    subtitle: "数学",
                    icon: "📐",
                    description: "椭圆、双曲线、抛物线的标准方程、几何性质与参数",
                    difficulty: "高级",
                    concepts: ["椭圆", "双曲线", "抛物线", "标准方程", "几何性质", "参数"],
                    formulas: ["椭圆: x²/a² + y²/b² = 1", "双曲线: x²/a² - y²/b² = 1", "抛物线: y² = 2px"]
                ),
                ConcreteTopic(
                    id: "conic_sections_applications",
                    title: "圆锥曲线应用",
                    subtitle: "数学",
                    icon: "📐",
                    description: "曲线与直线/圆的交点、切线、最值与范围问题",
                    difficulty: "高级",
                    concepts: ["交点", "切线", "最值", "范围", "应用问题", "综合计算"],
                    formulas: ["交点计算", "切线方程", "最值求法"]
                )
            ]
        case "derivatives_calculus_basic":
            return [
                ConcreteTopic(
                    id: "derivative_concepts",
                    title: "导数概念",
                    subtitle: "数学",
                    icon: "📈",
                    description: "导数的概念与几何意义、基本求导法则与复合函数求导",
                    difficulty: "高级",
                    concepts: ["导数", "概念", "几何意义", "求导法则", "复合函数", "链式法则"],
                    formulas: ["f'(x) = lim(h→0)[f(x+h) - f(x)]/h", "基本求导公式", "链式法则"]
                ),
                ConcreteTopic(
                    id: "derivative_applications",
                    title: "导数应用",
                    subtitle: "数学",
                    icon: "📈",
                    description: "利用导数研究函数的单调性、极值、最值与凹凸性、切线法线、相关变化率",
                    difficulty: "高级",
                    concepts: ["单调性", "极值", "最值", "凹凸性", "切线", "法线", "变化率"],
                    formulas: ["单调性判断", "极值条件", "凹凸性判断", "切线方程"]
                )
            ]
        case "complex_numbers":
            return [
                ConcreteTopic(
                    id: "complex_number_forms",
                    title: "复数形式",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "复数的代数形式与几何表示、模与辐角",
                    difficulty: "高级",
                    concepts: ["复数", "代数形式", "几何表示", "模", "辐角", "复平面"],
                    formulas: ["z = a + bi", "|z| = √(a² + b²)", "arg(z) = arctan(b/a)"]
                ),
                ConcreteTopic(
                    id: "complex_number_operations",
                    title: "复数运算",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "共轭、乘除与极形式的运算（棣莫弗定理入门）",
                    difficulty: "高级",
                    concepts: ["共轭复数", "乘法", "除法", "极形式", "棣莫弗定理"],
                    formulas: ["共轭: z̄ = a - bi", "极形式: z = r(cosθ + isinθ)", "棣莫弗定理"]
                )
            ]
        case "calculus_applications":
            return [
                ConcreteTopic(
                    id: "indefinite_integration",
                    title: "不定积分",
                    subtitle: "数学",
                    icon: "📈",
                    description: "不定积分与基本积分公式、换元与分部积分（基础）",
                    difficulty: "高级",
                    concepts: ["不定积分", "基本公式", "换元积分", "分部积分", "积分技巧"],
                    formulas: ["基本积分公式", "换元法", "分部积分法", "积分常数"]
                ),
                ConcreteTopic(
                    id: "definite_integration",
                    title: "定积分",
                    subtitle: "数学",
                    icon: "📈",
                    description: "定积分的概念、性质与几何意义（曲边梯形面积）、定积分的应用",
                    difficulty: "高级",
                    concepts: ["定积分", "概念", "性质", "几何意义", "曲边梯形", "应用"],
                    formulas: ["定积分定义", "几何意义", "面积计算", "体积计算"]
                )
            ]
        case "vectors_spatial_analytic_geometry":
            return [
                ConcreteTopic(
                    id: "spatial_vectors",
                    title: "空间向量",
                    subtitle: "数学",
                    icon: "➡️",
                    description: "空间向量运算与夹角、距离公式",
                    difficulty: "高级",
                    concepts: ["空间向量", "运算", "夹角", "距离", "空间几何", "向量关系"],
                    formulas: ["向量夹角", "距离公式", "空间向量运算"]
                ),
                ConcreteTopic(
                    id: "spatial_lines_planes",
                    title: "空间直线与平面",
                    subtitle: "数学",
                    icon: "🔲",
                    description: "空间直线与平面方程、相对位置（平行/相交/垂直）、线面角、二面角与投影",
                    difficulty: "高级",
                    concepts: ["空间直线", "空间平面", "方程", "相对位置", "线面角", "二面角", "投影"],
                    formulas: ["直线方程", "平面方程", "位置关系", "角度计算"]
                )
            ]
        case "conic_sections_comprehensive":
            return [
                ConcreteTopic(
                    id: "conic_sections_optimization",
                    title: "圆锥曲线优化",
                    subtitle: "数学",
                    icon: "📐",
                    description: "圆锥曲线与导数不等式向量的综合优化问题",
                    difficulty: "高级",
                    concepts: ["圆锥曲线", "导数", "不等式", "向量", "综合优化", "最值问题"],
                    formulas: ["优化条件", "约束方程", "目标函数", "最值求解"]
                ),
                ConcreteTopic(
                    id: "parametric_polar_coordinates",
                    title: "参数方程与极坐标",
                    subtitle: "数学",
                    icon: "📐",
                    description: "参数方程与极坐标描点（入门）、极坐标下的对称与面积",
                    difficulty: "高级",
                    concepts: ["参数方程", "极坐标", "描点", "对称性", "面积计算", "坐标变换"],
                    formulas: ["参数方程", "极坐标方程", "面积公式", "对称条件"]
                )
            ]
        case "sequences_limits_advanced":
            return [
                ConcreteTopic(
                    id: "limits_intuition",
                    title: "极限直观",
                    subtitle: "数学",
                    icon: "📊",
                    description: "单调有界与极限直观、错位相减法与裂项相消",
                    difficulty: "高级",
                    concepts: ["极限", "单调性", "有界性", "错位相减", "裂项相消", "收敛性"],
                    formulas: ["极限定义", "单调有界定理", "错位相减法", "裂项相消法"]
                ),
                ConcreteTopic(
                    id: "recurrence_relations",
                    title: "递推关系",
                    subtitle: "数学",
                    icon: "📊",
                    description: "递推关系的求解与应用、数学归纳法",
                    difficulty: "高级",
                    concepts: ["递推关系", "求解", "应用", "数学归纳法", "证明", "通项公式"],
                    formulas: ["递推公式", "通项求解", "归纳法步骤", "证明技巧"]
                )
            ]
        case "probability_statistics_comprehensive":
            return [
                ConcreteTopic(
                    id: "random_variables",
                    title: "随机变量",
                    subtitle: "数学",
                    icon: "📊",
                    description: "离散连续随机变量的期望与方差、正态分布入门",
                    difficulty: "高级",
                    concepts: ["随机变量", "离散", "连续", "期望", "方差", "正态分布"],
                    formulas: ["期望公式", "方差公式", "正态分布密度函数", "标准化"]
                ),
                ConcreteTopic(
                    id: "sampling_inference",
                    title: "抽样与推断",
                    subtitle: "数学",
                    icon: "📊",
                    description: "抽样分布、区间估计与显著性检验、概率模型建模与模拟",
                    difficulty: "高级",
                    concepts: ["抽样分布", "区间估计", "显著性检验", "概率模型", "建模", "模拟"],
                    formulas: ["置信区间", "假设检验", "p值", "显著性水平"]
                )
            ]
        case "mathematical_thinking_methods":
            return [
                ConcreteTopic(
                    id: "mathematical_ideas",
                    title: "数学思想",
                    subtitle: "数学",
                    icon: "🧠",
                    description: "函数与方程思想、数形结合、分类讨论、化归与递推",
                    difficulty: "高级",
                    concepts: ["函数思想", "方程思想", "数形结合", "分类讨论", "化归", "递推"],
                    formulas: ["思想方法", "解题策略", "思维模式", "方法总结"]
                ),
                ConcreteTopic(
                    id: "mathematical_methods",
                    title: "数学方法",
                    subtitle: "数学",
                    icon: "🧠",
                    description: "极值与估算、构造与转化、整体与局部、守恒与不变性、算法初步与流程图",
                    difficulty: "高级",
                    concepts: ["极值", "估算", "构造", "转化", "整体", "局部", "守恒", "算法"],
                    formulas: ["方法总结", "技巧归纳", "算法描述", "流程图"]
                )
            ]
        
        default:
            return [
                ConcreteTopic(
                    id: "default_topic",
                    title: "知识点详情",
                    subtitle: mainTopic.subtitle,
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
        case "lens_imaging", "refraction_reflection", "reflection_law":
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
