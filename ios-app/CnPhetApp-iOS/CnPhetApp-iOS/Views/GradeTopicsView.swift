//
//  GradeTopicsView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import SwiftUI

struct GradeTopicsView: View {
    let subject: Subject
    let grade: Grade
    @State private var topics: [GradeTopic] = []
    @State private var isLoading = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 年级标题 - 居中
            HStack {
                Spacer()
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
            } else if topics.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("暂无知识点")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("该年级暂未配置\(subject.title)知识点")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(topics) { topic in
                    NavigationLink(destination: ConcreteTopicsListView(mainTopic: topic)) {
                        GradeTopicRow(topic: topic)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(grade.title)
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            loadTopics()
        }
    }
    
    private func loadTopics() {
        isLoading = true
        
        print("🔍 开始加载知识点...")
        print("📚 学科: \(subject.title) (\(subject.rawValue))")
        print("🎓 年级: \(grade.title) (\(grade.rawValue))")
        
        // 根据学科和年级加载对应的知识点
        topics = getTopicsForSubjectAndGrade(subject: subject, grade: grade)
        
        print("📊 找到 \(topics.count) 个知识点")
        for (index, topic) in topics.enumerated() {
            print("  \(index + 1). \(topic.title) - \(topic.description)")
        }
        
        isLoading = false
        
        print("✅ 知识点加载完成")
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
    
    private func getPhysicsTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        switch grade {
        case .grade7: // 初一
            return [
                GradeTopic(
                    id: "scientific_method",
                    title: "科学探究方法",
                    subtitle: "物理",
                    icon: "🔬",
                    description: "理想化、控制变量、对照实验、数据记录与处理",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "physical_quantities",
                    title: "物理量与单位",
                    subtitle: "物理",
                    icon: "📏",
                    description: "SI基本单位与常用换算、量纲意识",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "measurement_error",
                    title: "测量与误差",
                    subtitle: "物理",
                    icon: "📊",
                    description: "读数规则、有效数字、绝对/相对误差、重复测量与平均值",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "motion_force",
                    title: "运动与力",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "质点与参考系、位移与路程、标量/矢量、速度与加速度、匀变速直线运动三公式",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "pressure_buoyancy",
                    title: "压强与浮力",
                    subtitle: "物理",
                    icon: "💧",
                    description: "压强与面积关系、液体压强p=ρgh、气压与连通器、阿基米德原理与浮沉条件",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "acoustics",
                    title: "声学",
                    subtitle: "物理",
                    icon: "🔊",
                    description: "声音的产生与传播介质、音调/响度/音色、回声、噪声与降噪、多普勒现象",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "geometric_optics_basic",
                    title: "几何光学基础",
                    subtitle: "物理",
                    icon: "💡",
                    description: "光的直线传播、阴影与小孔成像、反射定律与平面镜成像规律、折射现象与全反射",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "simple_circuit",
                    title: "简单电路入门",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "电路元件与电路图、串并联基本规律、电流/电压/电阻的认识与测量、安全用电常识",
                    difficulty: "基础"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "electricity_deep",
                    title: "电学深化",
                    subtitle: "物理",
                    icon: "🔌",
                    description: "欧姆定律、串并联电路定量计算、电功与电功率、焦耳定律、家庭电路与安全",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "work_mechanical_energy",
                    title: "功与机械能",
                    subtitle: "物理",
                    icon: "⚙️",
                    description: "功与功率、杠杆与滑轮、机械效率、动能/重力势能/弹性势能、机械能守恒与动能定理",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "thermodynamics_phase",
                    title: "热学与物态变化",
                    subtitle: "物理",
                    icon: "🌡️",
                    description: "温度与热量、比热容与热量计算、物态变化与潜热、热传导/对流/辐射与生活应用",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一
            return [
                GradeTopic(
                    id: "kinematics",
                    title: "运动学",
                    subtitle: "物理",
                    icon: "📈",
                    description: "x-t、v-t、a-t图像的物理含义与相互转化、匀变速直线运动系统求解、自由落体、圆周运动",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "force_motion_newton",
                    title: "力与运动（牛顿定律）",
                    subtitle: "物理",
                    icon: "⚖️",
                    description: "受力分析与等效简化、牛顿三定律、超重/失重、摩擦与约束、多物体系统/连接体/斜面模型",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "work_energy_advanced",
                    title: "功与能",
                    subtitle: "物理",
                    icon: "🔋",
                    description: "变力做功与F-x曲线面积、功率（平均/瞬时）、保守力/非保守力、机械能守恒的适用与破坏",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "momentum_impulse_advanced",
                    title: "动量与冲量",
                    subtitle: "物理",
                    icon: "🚀",
                    description: "冲量-动量定理、动量守恒（一维/二维）、碰撞（弹性/非弹性）与反冲/爆炸模型",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "electrostatics",
                    title: "静电场",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "点电荷作用（库仑定律）、电场强度与叠加、电势能与电势、等势面、带电粒子在匀强电场中的类抛体",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "experiment_methods",
                    title: "实验与方法",
                    subtitle: "物理",
                    icon: "🧪",
                    description: "打点计时器/光电门测v,a、摩擦系数测定、动量守恒/能量守恒验证、不确定度评估、线性拟合与误差来源分析",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "magnetic_field_particles",
                    title: "磁场与带电粒子",
                    subtitle: "物理",
                    icon: "🧲",
                    description: "磁感线与右手定则、通电导线/线圈的磁场、洛伦兹力与带电粒子在匀强磁场中的圆周/螺旋运动",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "electromagnetic_induction_ac",
                    title: "电磁感应与交流电",
                    subtitle: "物理",
                    icon: "⚡",
                    description: "磁通量、法拉第电磁感应定律、楞次定律、感应电动势产生的多情境分析、正弦交流、有效值、相位、阻抗RLC",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "vibration_waves",
                    title: "振动与波",
                    subtitle: "物理",
                    icon: "🌊",
                    description: "简谐振动、单摆/弹簧振子周期、简谐合成与拍频、机械波、波速、波的能量传递、反射/干涉/衍射/共振",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "optics_advanced",
                    title: "光学深化",
                    subtitle: "物理",
                    icon: "🔬",
                    description: "薄透镜成像规律与作图、放大率、光学仪器、杨氏双缝干涉、薄膜干涉现象、单缝衍射与衍射角条件",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "thermodynamics_gas",
                    title: "热学与气体分子动理论",
                    subtitle: "物理",
                    icon: "🌡️",
                    description: "理想气体状态方程与过程、气体分子运动论要点、压强微观解释、平均动能与温度关系、热力学第一定律",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "modern_physics_advanced",
                    title: "近代物理",
                    subtitle: "物理",
                    icon: "⚛️",
                    description: "光量子假说与光电效应、原子模型与能级跃迁、氢原子玻尔模型、谱线、物质波与德布罗意波长",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "nuclear_radioactivity",
                    title: "原子核与放射性",
                    subtitle: "物理",
                    icon: "☢️",
                    description: "放射性衰变规律与半衰期、核反应方程配平、质量亏损与结合能、核裂变/聚变与核能利用的利弊",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "comprehensive_practice",
                    title: "综合与实践",
                    subtitle: "物理",
                    icon: "🎯",
                    description: "多主题综合题、图像法、极值/临界、能动量混合、实验设计与评估、控制变量、重复性/灵敏度",
                    difficulty: "高级"
                )
            ]
        }
    }
    
    private func getMathTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        switch grade {
        case .grade7: // 初一
            return [
                GradeTopic(
                    id: "numbers_expressions",
                    title: "数与式",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "整数与分数的运算、约分通分、幂与开方、因数与倍数、比比例与百分数、简单代数式与整式运算",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "equations_inequalities",
                    title: "方程与不等式",
                    subtitle: "数学",
                    icon: "⚖️",
                    description: "一元一次方程与应用题建模、一元一次不等式、函数与图像入门",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "geometry_graphics",
                    title: "几何与图形",
                    subtitle: "数学",
                    icon: "📐",
                    description: "基本几何概念与作图、三角形与四边形的基本性质、圆的认识、图形的平移旋转对称",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "statistics_probability_basic",
                    title: "统计与概率（入门）",
                    subtitle: "数学",
                    icon: "📊",
                    description: "统计图表、平均数众数中位数、简单随机事件与频率",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "algebra_equations",
                    title: "代数与方程",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "二元一次方程组的解法与应用、整式的乘法与平方公式、分式的基本性质与运算、一次函数",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "geometry_advanced",
                    title: "几何",
                    subtitle: "数学",
                    icon: "📐",
                    description: "平行线性质与判定、三角形全等及判定应用、勾股定理与逆定理、轴对称中心对称与图形变换",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "statistics_probability_intermediate",
                    title: "统计与概率",
                    subtitle: "数学",
                    icon: "📊",
                    description: "组距频数与频率分布表直方图、简单概率模型、古典概型入门",
                    difficulty: "基础"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "algebra_functions_advanced",
                    title: "代数与函数深化",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "二次函数、因式分解系统法、一元二次方程、反比例函数与应用",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "geometry_trigonometry",
                    title: "几何与三角",
                    subtitle: "数学",
                    icon: "📐",
                    description: "相似三角形的判定与性质、圆的性质与切线弦圆周角圆心角、解直角三角形、坐标几何综合",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "statistics_probability_advanced",
                    title: "统计与概率",
                    subtitle: "数学",
                    icon: "📊",
                    description: "抽样方法、用频率估计概率、简单独立事件与互斥事件",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一
            return [
                GradeTopic(
                    id: "sets_logic_basic",
                    title: "集合与逻辑初步",
                    subtitle: "数学",
                    icon: "🔗",
                    description: "集合表示与运算、子集与真子集、命题充分必要条件、简单逻辑推理",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "functions_equations",
                    title: "函数与方程",
                    subtitle: "数学",
                    icon: "📈",
                    description: "函数的性质、基本初等函数、函数与方程的关系、方程不等式的图像法",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "trigonometry_basic",
                    title: "三角函数",
                    subtitle: "数学",
                    icon: "📐",
                    description: "任意角与弧度制、正弦余弦正切的定义与图像、三角恒等式、两角和差公式入门",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "vectors_analytic_geometry",
                    title: "向量与解析几何（平面）",
                    subtitle: "数学",
                    icon: "➡️",
                    description: "平面向量的加减与数乘、基底表示与坐标表示、线段的向量表示、点到点直线的距离、直线的方程与位置关系",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "sequences",
                    title: "数列",
                    subtitle: "数学",
                    icon: "📊",
                    description: "等差等比数列的通项与前n项和、递推关系入门",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "statistics_probability_foundation",
                    title: "统计与概率（基础）",
                    subtitle: "数学",
                    icon: "📊",
                    description: "随机抽样、数据的离散程度、古典概率与几何概型入门",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "trigonometry_triangle_solving",
                    title: "三角与解三角形（深化）",
                    subtitle: "数学",
                    icon: "📐",
                    description: "倍角半角、积化和差与和差化积公式、正弦定理余弦定理、面积公式与解三角形综合",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "solid_geometry_spatial_concepts",
                    title: "立体几何与空间观念",
                    subtitle: "数学",
                    icon: "🔲",
                    description: "空间点线面的位置关系、多面体与旋转体的表面积与体积、截面投影与三视图、空间向量入门",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "analytic_geometry_conic_sections",
                    title: "解析几何（圆锥曲线）",
                    subtitle: "数学",
                    icon: "📐",
                    description: "椭圆双曲线抛物线的标准方程几何性质与参数、曲线与直线圆的交点切线、最值与范围问题",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "derivatives_calculus_basic",
                    title: "导数与微积分初步",
                    subtitle: "数学",
                    icon: "📈",
                    description: "导数的概念与几何意义、基本求导法则与复合函数求导、利用导数研究函数的单调性极值最值与凹凸性、切线法线、相关变化率",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "complex_numbers",
                    title: "复数（平面代数）",
                    subtitle: "数学",
                    icon: "🔢",
                    description: "复数的代数形式与几何表示、模与辐角、共轭乘除与极形式的运算、棣莫弗定理入门",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "probability_statistics_advanced",
                    title: "概率与统计（提升）",
                    subtitle: "数学",
                    icon: "📊",
                    description: "条件概率与全概率公式、贝叶斯公式、随机变量及其分布、二项分布、抽样分布直观、区间估计假设检验入门",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "calculus_applications",
                    title: "微积分与应用（综合）",
                    subtitle: "数学",
                    icon: "📈",
                    description: "不定积分与基本积分公式、换元与分部积分、定积分的概念性质与几何意义、定积分的应用、简单微分方程模型",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "vectors_spatial_analytic_geometry",
                    title: "向量与空间解析几何（进阶）",
                    subtitle: "数学",
                    icon: "➡️",
                    description: "空间向量运算与夹角距离公式、空间直线与平面方程、相对位置、线面角二面角与投影",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "conic_sections_comprehensive",
                    title: "圆锥曲线综合与参数极坐标",
                    subtitle: "数学",
                    icon: "📐",
                    description: "圆锥曲线与导数不等式向量的综合优化问题、参数方程与极坐标描点、极坐标下的对称与面积",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "sequences_limits_advanced",
                    title: "数列与极限（进阶）",
                    subtitle: "数学",
                    icon: "📊",
                    description: "单调有界与极限直观、错位相减法与裂项相消、递推关系的求解与应用、数学归纳法",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "probability_statistics_comprehensive",
                    title: "概率统计（综合）",
                    subtitle: "数学",
                    icon: "📊",
                    description: "离散连续随机变量的期望与方差、正态分布入门、抽样分布、区间估计与显著性检验、概率模型建模与模拟",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "mathematical_thinking_methods",
                    title: "数学思想与方法",
                    subtitle: "数学",
                    icon: "🧠",
                    description: "函数与方程思想、数形结合、分类讨论、化归与递推、极值与估算、构造与转化、整体与局部、守恒与不变性、算法初步与流程图",
                    difficulty: "高级"
                )
            ]
        }
    }
    
    private func getChemistryTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        switch grade {
        case .grade7: // 初一
            return [
                GradeTopic(
                    id: "chemical_concepts_experiment",
                    title: "化学观念与实验启蒙",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "化学研究对象与物理/化学变化的区分、基本实验仪器与实验安全",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "matter_properties",
                    title: "物质及其性质",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "纯净物/混合物、物理性质/化学性质、常见分离与提纯方法",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "solution_basics",
                    title: "溶液基础",
                    subtitle: "化学",
                    icon: "💧",
                    description: "溶解/溶解度、饱和/不饱和溶液、影响因素（温度、搅拌、粒度）",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "particle_view_formula",
                    title: "微粒观与化学式",
                    subtitle: "化学",
                    icon: "⚛️",
                    description: "原子、分子、离子概念、元素与同位素、化学符号、化学式与式量",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "solution_concentration",
                    title: "溶液与浓度",
                    subtitle: "化学",
                    icon: "📊",
                    description: "溶解度曲线阅读与应用、浓度表示、质量分数、稀释计算",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "gas_introduction",
                    title: "气体初识",
                    subtitle: "化学",
                    icon: "💨",
                    description: "常见气体性质与制取/检验、气体收集方法（排水/向上、向下排空气法）",
                    difficulty: "基础"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "chemical_reactions_equations",
                    title: "化学反应与方程式",
                    subtitle: "化学",
                    icon: "⚡",
                    description: "质量守恒定律、化学方程式的书写与配平、反应类型、氧化还原反应入门",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "acid_base_salt",
                    title: "酸碱盐与溶液",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "酸、碱、盐的性质与相互转化、中和反应、酸碱强弱与指示剂、滴定基本操作",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "metals_nonmetals",
                    title: "金属与非金属",
                    subtitle: "化学",
                    icon: "🔩",
                    description: "活泼性顺序与置换反应、金属的腐蚀与防护、重要非金属单质与化合物",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "chemistry_life_environment",
                    title: "化学与生活/环境",
                    subtitle: "化学",
                    icon: "🌍",
                    description: "燃料与燃烧、空气与水的污染和治理基本思路",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一
            return [
                GradeTopic(
                    id: "atomic_structure_periodic",
                    title: "原子结构与元素周期律",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "电子排布、核外电子层与副层、价电子与化学性质、周期律与周期性",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "chemical_bonds_structure",
                    title: "化学键与物质结构",
                    subtitle: "化学",
                    icon: "🔗",
                    description: "离子键、共价键、金属键、价键理论与八隅体规则、分子间作用力、晶体类型",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "gas_state_equation",
                    title: "气体与状态方程",
                    subtitle: "化学",
                    icon: "📈",
                    description: "理想气体方程pV=nRT的应用、等温/等压/等容变化定性分析",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "thermochemistry_basic",
                    title: "热化学基础",
                    subtitle: "化学",
                    icon: "🔥",
                    description: "反应热与焓变、量热法、亥斯定律的应用",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "reaction_rate",
                    title: "反应速率与影响因素",
                    subtitle: "化学",
                    icon: "⚡",
                    description: "速率的定义与测定方式、温度、浓度、催化剂、表面积的影响、碰撞理论与活化能",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "chemical_equilibrium_basic",
                    title: "化学平衡基础",
                    subtitle: "化学",
                    icon: "⚖️",
                    description: "可逆反应与平衡常数、勒沙特列原理、温度、压强、浓度变化对平衡的影响",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "electrolyte_acid_base",
                    title: "电解质溶液与酸碱",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "强/弱电解质、电离平衡与电导概念、酸碱理论、pH与指示剂、简单缓冲体系概念",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "solubility_equilibrium",
                    title: "溶解平衡与溶度积",
                    subtitle: "化学",
                    icon: "💧",
                    description: "溶度积Ksp、共离子效应、沉淀溶解判据、选择性沉淀与分离的设计思路",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "acid_base_equilibrium",
                    title: "酸碱平衡深化",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "弱酸/弱碱的电离常数、pKa/pKb、Henderson–Hasselbalch公式与缓冲溶液配制",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "chemical_kinetics_advanced",
                    title: "化学动力学进阶",
                    subtitle: "化学",
                    icon: "⚡",
                    description: "速率方程、反应级数与半衰期、阿伦尼乌斯方程、活化能的实验求取",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "electrochemistry",
                    title: "电化学",
                    subtitle: "化学",
                    icon: "🔋",
                    description: "原电池/电解池、电极反应、标准电极电势、能斯特方程、电解与法拉第定律",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "organic_chemistry_basic",
                    title: "有机化学基础",
                    subtitle: "化学",
                    icon: "⚛️",
                    description: "命名与同分异构、烷烃、烯烃、炔烃、芳香烃、卤代烃、醇、醛酮、羧酸及其衍生物",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "polymers_materials",
                    title: "高分子与材料",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "加聚/缩聚反应、常见聚合物性质与应用、材料化学：陶瓷、半导体、复合材料",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "organic_chemistry_advanced",
                    title: "有机化学深化与合成",
                    subtitle: "化学",
                    icon: "⚛️",
                    description: "反应机理与选择性、芳香性与取代定位规则、多步合成与官能团互变策略",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "analytical_chemistry",
                    title: "分析化学与仪器分析",
                    subtitle: "化学",
                    icon: "🔬",
                    description: "容量分析、基本光谱、IR识别官能团、NMR化学位移与裂分、MS分子峰",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "chemical_thermodynamics",
                    title: "化学热力学与自发性",
                    subtitle: "化学",
                    icon: "🔥",
                    description: "ΔH、ΔS、ΔG与反应自发性判据、ΔG°与平衡常数的关系、温度对K的影响",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "electrochemistry_energy",
                    title: "电化学与能源材料",
                    subtitle: "化学",
                    icon: "🔋",
                    description: "二次电池工作原理与比较、燃料电池与电极催化、超级电容、腐蚀机理与防护",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "green_sustainable_chemistry",
                    title: "绿色与可持续化学",
                    subtitle: "化学",
                    icon: "🌱",
                    description: "原子经济性、危害最小化、可再生原料、能效、可降解材料、环境化学与治理",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "comprehensive_experiment",
                    title: "综合实验与探究",
                    subtitle: "化学",
                    icon: "🧪",
                    description: "实验设计、变量控制、数据处理、有效数字、不确定度评估、常见操作要点、安全文化",
                    difficulty: "高级"
                )
            ]
        }
    }
    
    private func getBiologyTopicsForGrade(_ grade: Grade) -> [GradeTopic] {
        switch grade {
        case .grade7: // 初一
            return [
                GradeTopic(
                    id: "life_characteristics_scientific_method",
                    title: "生命的特征与科学方法",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "生命体共同特征、科学探究、显微镜结构与使用、放大倍数计算与切片制备",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "cells_biomolecules",
                    title: "细胞与生物分子",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "细胞学说、原核/真核差异、细胞器功能、生物大分子组成与功能、物质跨膜运输",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "tissue_organ_system",
                    title: "组织—器官—系统",
                    subtitle: "生物",
                    icon: "🫀",
                    description: "植物组织与器官、动物组织与系统、稳态概念与体内环境",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "ecology_basics",
                    title: "生态学基础",
                    subtitle: "生物",
                    icon: "🌿",
                    description: "生态系统组成、能量流动与物质循环、食物链/食物网、种群特征与群落演替",
                    difficulty: "基础"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "genetics_variation",
                    title: "遗传与变异",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "基因与等位基因、孟德尔遗传定律、减数分裂、变异来源",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "metabolism_photosynthesis_respiration",
                    title: "代谢：光合作用与呼吸作用",
                    subtitle: "生物",
                    icon: "🌱",
                    description: "光合作用光反应与碳反应、细胞呼吸、酶的本质与作用特点",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一
            return [
                GradeTopic(
                    id: "cell_structure_function_advanced",
                    title: "细胞结构与功能深化",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "生物膜系统与跨膜运输、细胞骨架、细胞周期与有丝分裂、表面积/体积比影响",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "physiology_homeostasis",
                    title: "生理与稳态（植物/动物）",
                    subtitle: "生物",
                    icon: "🫀",
                    description: "植物生理、动物生理、体液与内环境、神经调节与体液调节、渗透调节与排泄",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "molecular_genetics_biotechnology",
                    title: "分子遗传学与生物技术",
                    subtitle: "生物",
                    icon: "🧬",
                    description: "DNA双螺旋与染色质、复制转录翻译、基因表达调控、生物技术原理与伦理",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "ecosystem_behavior",
                    title: "生态系统与行为",
                    subtitle: "生物",
                    icon: "🌍",
                    description: "群落多样性、种群动力学、行为生态学、先天行为与学习行为、社会行为",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "evolution_speciation",
                    title: "进化与物种形成",
                    subtitle: "生物",
                    icon: "🦕",
                    description: "进化驱动力、物种概念与生殖隔离、适应与趋同/分歧进化、系统发生与分子钟",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "human_physiology_special",
                    title: "人体生理专题",
                    subtitle: "生物",
                    icon: "👤",
                    description: "循环系统、呼吸系统、消化系统、泌尿系统、神经-内分泌整合、免疫系统",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "scientific_inquiry_biosafety",
                    title: "科学探究与生物安全",
                    subtitle: "生物",
                    icon: "🔬",
                    description: "实验设计、数据处理、生物安全与伦理、人类受试者保护、动物福利",
                    difficulty: "高级"
                )
            ]
        }
    }
}

struct GradeTopic: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let description: String
    let difficulty: String
}

struct GradeTopicRow: View {
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

struct GradeTopicDetailView: View {
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
                        GradeLearningTipRow(
                            icon: "lightbulb.fill",
                            color: .yellow,
                            title: "理解概念",
                            description: "先理解基本概念和定义，建立知识框架"
                        )
                        
                        GradeLearningTipRow(
                            icon: "flask.fill",
                            color: .green,
                            title: "实验验证",
                            description: "通过实验验证理论，加深理解"
                        )
                        
                        GradeLearningTipRow(
                            icon: "pencil.circle.fill",
                            color: .blue,
                            title: "练习应用",
                            description: "多做练习题，掌握应用方法"
                        )
                        
                        GradeLearningTipRow(
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

struct GradeLearningTipRow: View {
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
        GradeTopicsView(subject: .physics, grade: .grade10)
    }
}
