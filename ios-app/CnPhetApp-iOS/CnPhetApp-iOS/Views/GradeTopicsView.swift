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
