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
                    id: "basic_arithmetic",
                    title: "基础运算",
                    subtitle: "数学",
                    icon: "数",
                    description: "整数运算、分数运算、小数运算、混合运算",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "algebra_basic",
                    title: "代数基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "代数式、一元一次方程、不等式",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "geometry_basic",
                    title: "几何基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "平面图形、周长面积、立体图形、表面积体积",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "quadratic_equation",
                    title: "一元二次方程",
                    subtitle: "数学",
                    icon: "数",
                    description: "配方法、公式法、因式分解法、根的判别式",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "function_basic",
                    title: "函数基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "函数概念、函数图像、函数性质",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "similarity",
                    title: "相似形",
                    subtitle: "数学",
                    icon: "数",
                    description: "相似三角形、相似多边形、相似比",
                    difficulty: "中等"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "trigonometry_basic",
                    title: "三角函数基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "正弦、余弦、正切、特殊角值",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "circle_properties",
                    title: "圆的性质",
                    subtitle: "数学",
                    icon: "数",
                    description: "圆心角、圆周角、切线、弦切角",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "statistics_basic",
                    title: "统计基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "平均数、中位数、众数、方差",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一 - 完全按照截图配置
            return [
                GradeTopic(
                    id: "linear_function",
                    title: "一次函数 y=kx+b",
                    subtitle: "数学",
                    icon: "数",
                    description: "线性函数的基本性质和图像",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "quadratic_function",
                    title: "二次函数 y=ax²+bx+c",
                    subtitle: "数学",
                    icon: "数",
                    description: "二次函数的图像和性质",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "trigonometric_function",
                    title: "三角函数 y=A·sin(ωx+φ)",
                    subtitle: "数学",
                    icon: "数",
                    description: "正弦函数的图像和变换",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "exponential_function",
                    title: "指数函数 y=a^x",
                    subtitle: "数学",
                    icon: "数",
                    description: "指数函数的图像和性质、对数函数",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "derivative_basic",
                    title: "导数基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "导数的定义、求导法则、导数的应用",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "probability",
                    title: "概率论",
                    subtitle: "数学",
                    icon: "数",
                    description: "随机事件、概率计算、条件概率",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "integral_basic",
                    title: "积分基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "定积分、不定积分、积分的应用",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "complex_number",
                    title: "复数",
                    subtitle: "数学",
                    icon: "数",
                    description: "复数的运算、复平面、欧拉公式",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "vector_basic",
                    title: "向量基础",
                    subtitle: "数学",
                    icon: "数",
                    description: "向量的运算、向量的几何意义",
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
                    id: "matter_basic",
                    title: "物质基础",
                    subtitle: "化学",
                    icon: "化",
                    description: "物质的三态变化、纯净物与混合物",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "air_composition",
                    title: "空气组成",
                    subtitle: "化学",
                    icon: "化",
                    description: "空气的成分、氧气的性质、燃烧",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "water_properties",
                    title: "水的性质",
                    subtitle: "化学",
                    icon: "化",
                    description: "水的物理性质、水的净化、水污染",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "element_compound",
                    title: "元素与化合物",
                    subtitle: "化学",
                    icon: "化",
                    description: "元素符号、化学式、化合价",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "chemical_reaction_basic",
                    title: "化学反应基础",
                    subtitle: "化学",
                    icon: "化",
                    description: "化学方程式、质量守恒定律",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "acid_base_basic",
                    title: "酸碱基础",
                    subtitle: "化学",
                    icon: "化",
                    description: "酸碱指示剂、pH值、中和反应",
                    difficulty: "中等"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "solution_concentration",
                    title: "溶液浓度",
                    subtitle: "化学",
                    icon: "化",
                    description: "质量分数、体积分数、物质的量浓度",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "redox_reaction",
                    title: "氧化还原反应",
                    subtitle: "化学",
                    icon: "化",
                    description: "氧化剂、还原剂、电子转移",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "organic_basic",
                    title: "有机化学基础",
                    subtitle: "化学",
                    icon: "化",
                    description: "烃类、醇类、羧酸类",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一 - 完全按照截图配置
            return [
                GradeTopic(
                    id: "ideal_gas",
                    title: "理想气体 pV=nRT",
                    subtitle: "化学",
                    icon: "化",
                    description: "理想气体状态方程",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "chemical_reaction",
                    title: "化学反应方程式",
                    subtitle: "化学",
                    icon: "化",
                    description: "化学反应的平衡和计算",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "chemical_equilibrium",
                    title: "化学平衡",
                    subtitle: "化学",
                    icon: "化",
                    description: "平衡常数、勒夏特列原理、平衡移动",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "electrochemistry",
                    title: "电化学",
                    subtitle: "化学",
                    icon: "化",
                    description: "原电池、电解池、电极电势",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "reaction_kinetics",
                    title: "反应动力学",
                    subtitle: "化学",
                    icon: "化",
                    description: "反应速率、活化能、催化剂",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "coordination_chemistry",
                    title: "配位化学",
                    subtitle: "化学",
                    icon: "化",
                    description: "配位键、配位数、配位化合物",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "polymer_chemistry",
                    title: "高分子化学",
                    subtitle: "化学",
                    icon: "化",
                    description: "聚合反应、高分子材料、生物高分子",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "analytical_chemistry",
                    title: "分析化学",
                    subtitle: "化学",
                    icon: "化",
                    description: "滴定分析、仪器分析、误差分析",
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
                    id: "living_organisms",
                    title: "生物的特征",
                    subtitle: "生物",
                    icon: "生",
                    description: "生物的基本特征、生物的分类",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "cell_basic",
                    title: "细胞基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "细胞的结构、细胞的分裂",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "plant_basic",
                    title: "植物基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "植物的结构、光合作用",
                    difficulty: "基础"
                )
            ]
        case .grade8: // 初二
            return [
                GradeTopic(
                    id: "animal_basic",
                    title: "动物基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "动物的分类、动物的行为",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "human_body_basic",
                    title: "人体基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "人体的系统、血液循环",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "ecosystem_basic",
                    title: "生态系统基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "食物链、食物网、生态平衡",
                    difficulty: "中等"
                )
            ]
        case .grade9: // 初三
            return [
                GradeTopic(
                    id: "genetics_basic",
                    title: "遗传学基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "基因、染色体、遗传规律",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "evolution_basic",
                    title: "进化基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "自然选择、适者生存、物种形成",
                    difficulty: "中等"
                ),
                GradeTopic(
                    id: "biotechnology_basic",
                    title: "生物技术基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "基因工程、克隆技术、转基因",
                    difficulty: "中等"
                )
            ]
        case .grade10: // 高一 - 完全按照截图配置
            return [
                GradeTopic(
                    id: "cell_structure",
                    title: "细胞结构",
                    subtitle: "生物",
                    icon: "生",
                    description: "细胞的基本结构和功能",
                    difficulty: "基础"
                ),
                GradeTopic(
                    id: "genetics",
                    title: "遗传学基础",
                    subtitle: "生物",
                    icon: "生",
                    description: "基因的传递和表达",
                    difficulty: "中等"
                )
            ]
        case .grade11: // 高二
            return [
                GradeTopic(
                    id: "molecular_biology",
                    title: "分子生物学",
                    subtitle: "生物",
                    icon: "生",
                    description: "DNA复制、转录、翻译",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "immunology",
                    title: "免疫学",
                    subtitle: "生物",
                    icon: "生",
                    description: "免疫系统、抗体、疫苗",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "neurobiology",
                    title: "神经生物学",
                    subtitle: "生物",
                    icon: "生",
                    description: "神经元、神经递质、大脑功能",
                    difficulty: "高级"
                )
            ]
        case .grade12: // 高三
            return [
                GradeTopic(
                    id: "developmental_biology",
                    title: "发育生物学",
                    subtitle: "生物",
                    icon: "生",
                    description: "胚胎发育、器官形成、干细胞",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "ecology_advanced",
                    title: "生态学高级",
                    subtitle: "生物",
                    icon: "生",
                    description: "种群生态学、群落生态学、生态系统",
                    difficulty: "高级"
                ),
                GradeTopic(
                    id: "conservation_biology",
                    title: "保护生物学",
                    subtitle: "生物",
                    icon: "生",
                    description: "生物多样性、濒危物种、环境保护",
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
