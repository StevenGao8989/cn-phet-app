# 模拟器文件结构说明

## 🏗️ 文件组织结构

按照五级导航层次组织的模拟器文件结构：

```
CnPhetApp-iOS/Sims/
├── SimulatorIndex.swift                    # 模拟器索引管理器
├── Physics/                                # 第一级：学科
│   ├── Grade7/                            # 第二级：年级
│   │   ├── Mechanics/                     # 第三级：知识点分类
│   │   ├── Electricity/
│   │   ├── Optics/
│   │   └── Thermodynamics/
│   ├── Grade8/
│   │   ├── Mechanics/
│   │   ├── Electricity/
│   │   ├── Optics/
│   │   └── Thermodynamics/
│   ├── Grade9/
│   │   ├── Mechanics/
│   │   ├── Electricity/
│   │   ├── Optics/
│   │   └── Thermodynamics/
│   ├── Grade10/                           # 当前主要实现年级
│   │   ├── Mechanics/                     # 第三级：知识点分类
│   │   │   ├── Kinematics/               # 第四级：具体知识点
│   │   │   │   ├── ProjectileSimVIew.swift      # 第五级：模拟器文件
│   │   │   │   ├── FreefallSimView.swift
│   │   │   │   └── SimpleMotionSimView.swift
│   │   │   ├── ForceMotion/              # 第四级：具体知识点
│   │   │   │   └── ForceMotionSimView.swift
│   │   │   ├── WorkEnergy/               # 第四级：具体知识点
│   │   │   └── Momentum/                 # 第四级：具体知识点
│   │   ├── Electricity/                   # 第三级：知识点分类
│   │   ├── Optics/                        # 第三级：知识点分类
│   │   │   └── LensSimView.swift         # 第五级：模拟器文件
│   │   └── Thermodynamics/                # 第三级：知识点分类
│   ├── Grade11/
│   │   ├── Mechanics/
│   │   ├── Electricity/
│   │   ├── Optics/
│   │   └── Thermodynamics/
│   └── Grade12/
│       ├── Mechanics/
│       ├── Electricity/
│       ├── Optics/
│       └── Thermodynamics/
├── Chemistry/                              # 第一级：学科
│   ├── Grade7/
│   ├── Grade8/
│   ├── Grade9/
│   ├── Grade10/
│   ├── Grade11/
│   └── Grade12/
├── Mathematics/                            # 第一级：学科
│   ├── Grade7/
│   ├── Grade8/
│   ├── Grade9/
│   ├── Grade10/
│   ├── Grade11/
│   └── Grade12/
└── Biology/                                # 第一级：学科
    ├── Grade7/
    ├── Grade8/
    ├── Grade9/
    ├── Grade10/
    ├── Grade11/
    └── Grade12/
```

## 🎯 五级导航结构

### 第一级：学科选择
- **Physics** - 物理
- **Chemistry** - 化学  
- **Mathematics** - 数学
- **Biology** - 生物

### 第二级：年级选择
- **Grade7** - 初一
- **Grade8** - 初二
- **Grade9** - 初三
- **Grade10** - 高一
- **Grade11** - 高二
- **Grade12** - 高三

### 第三级：知识点分类
- **Mechanics** - 力学
- **Electricity** - 电学
- **Optics** - 光学
- **Thermodynamics** - 热学

### 第四级：具体知识点
- **Kinematics** - 运动学
- **ForceMotion** - 力与运动
- **WorkEnergy** - 功与能
- **Momentum** - 动量与冲量

### 第五级：模拟器文件
- **ProjectileSimView.swift** - 抛体运动模拟器
- **FreefallSimView.swift** - 自由落体模拟器
- **SimpleMotionSimView.swift** - 直线运动模拟器
- **ForceMotionSimView.swift** - 力与运动模拟器
- **LensSimView.swift** - 透镜成像模拟器

## 🔧 技术架构

### 1. 模拟器索引管理器 (SimulatorIndex.swift)

#### 核心功能
- **统一管理**：所有模拟器的导入和访问
- **类型安全**：使用静态类型确保编译时检查
- **工厂模式**：通过工厂类创建模拟器实例
- **分类管理**：按学科、年级、知识点分类组织

#### 主要结构
```swift
struct PhysicsSimulators {
    struct Kinematics {
        static let projectileMotion = ProjectileSimView.self
        static let freeFall = FreefallSimView.self
        // ...
    }
    struct ForceMotion {
        static let forceAnalysis = ForceMotionSimView.self
        // ...
    }
    // ...
}

struct SimulatorFactory {
    static func createSimulator(for topicId: String, title: String) -> AnyView?
}
```

### 2. 模拟器视图结构

每个模拟器都遵循统一的接口：
```swift
struct SimulatorView: View {
    let title: String
    
    // 状态变量
    @State private var parameters: [Parameter]
    @State private var playing: Bool
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            // 1. 画布区域 - 物理现象可视化
            GeometryReader { geo in
                Canvas { context, size in
                    // 绘制物理现象
                }
            }
            
            // 2. 参数控制 - 交互式参数调整
            VStack {
                // 滑块、按钮等控件
            }
        }
    }
}
```

## 📱 用户导航流程

### 完整导航路径示例
```
用户操作 → 文件路径 → 模拟器文件
↓
点击"物理" → Sims/Physics/ → 进入物理学科
↓
点击"高一" → Sims/Physics/Grade10/ → 进入高一年级
↓
点击"力学" → Sims/Physics/Grade10/Mechanics/ → 进入力学分类
↓
点击"运动学" → Sims/Physics/Grade10/Mechanics/Kinematics/ → 进入运动学
↓
点击"抛体运动" → ProjectileSimVIew.swift → 启动抛体运动模拟器
```

## 🚀 扩展指南

### 1. 添加新模拟器

#### 步骤1：创建模拟器文件
```swift
// 在对应路径创建新文件
// 例如：Sims/Physics/Grade10/Mechanics/WorkEnergy/WorkEnergySimView.swift

struct WorkEnergySimView: View {
    let title: String
    // 实现模拟器逻辑
}
```

#### 步骤2：更新索引管理器
```swift
// 在 SimulatorIndex.swift 中添加
struct PhysicsSimulators {
    struct WorkEnergy {
        static let workPowerEfficiency = WorkEnergySimView.self
        static let kineticEnergyTheorem = WorkEnergySimView.self
        static let conservativeMechanicalEnergy = WorkEnergySimView.self
    }
}
```

#### 步骤3：更新工厂方法
```swift
// 在 SimulatorFactory.createSimulator 中添加
case "work_power_efficiency", "kinetic_energy_theorem", "conservative_mechanical_energy":
    return AnyView(WorkEnergySimView(title: title))
```

### 2. 添加新学科

#### 步骤1：创建学科文件夹结构
```bash
mkdir -p Sims/NewSubject/Grade{7..12}/{Mechanics,Electricity,Optics,Thermodynamics}
```

#### 步骤2：创建学科模拟器结构
```swift
struct NewSubjectSimulators {
    struct Mechanics {
        // 新学科的力学模拟器
    }
    // ... 其他分类
}
```

#### 步骤3：更新工厂方法
```swift
// 在 SimulatorFactory 中添加新学科的处理逻辑
```

## 📊 当前状态

### 已实现的模拟器
- ✅ **物理 - 高一 - 力学 - 运动学**
  - 抛体运动模拟器
  - 自由落体模拟器
  - 直线运动模拟器
- ✅ **物理 - 高一 - 力学 - 力与运动**
  - 力与运动模拟器
- ✅ **物理 - 高一 - 光学**
  - 透镜成像模拟器

### 待实现的模拟器
- 🔄 **物理 - 高一 - 力学 - 功与能**
- 🔄 **物理 - 高一 - 力学 - 动量与冲量**
- 🔄 **物理 - 高一 - 电学**
- 🔄 **物理 - 高一 - 热学**
- 🔄 **其他年级的模拟器**
- 🔄 **其他学科的模拟器**

## 🎉 优势特点

### 1. 组织结构清晰
- **层次分明**：五级结构对应五级导航
- **易于维护**：每个模拟器都有明确的位置
- **便于扩展**：新模拟器可以轻松添加到对应位置

### 2. 技术架构合理
- **统一接口**：所有模拟器遵循相同的接口规范
- **类型安全**：编译时检查确保类型正确
- **工厂模式**：统一的创建和管理机制

### 3. 用户体验优秀
- **导航直观**：文件结构与用户操作完全对应
- **功能完整**：从知识点到模拟器的无缝连接
- **扩展性强**：支持更多学科和年级的扩展

## 📝 总结

通过重新组织模拟器文件结构，我们实现了：

1. **清晰的层次结构**：五级导航对应五级文件结构
2. **统一的访问接口**：通过 SimulatorIndex 统一管理
3. **便于维护和扩展**：新模拟器可以轻松添加到对应位置
4. **优秀的用户体验**：文件结构与用户操作完全对应

这种组织方式为未来的扩展奠定了坚实的基础，使得添加新的模拟器、学科或年级变得简单而有序。🎯
