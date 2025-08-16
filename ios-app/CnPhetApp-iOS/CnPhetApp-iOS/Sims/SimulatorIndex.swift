//
//  SimulatorIndex.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import Foundation
import SwiftUI

// 导入所有模拟器文件
// 注意：这些文件现在位于不同的文件夹中，但Swift会自动找到它们

// MARK: - 模拟器索引管理器
/// 统一管理所有模拟器的导入和访问
/// 按照五级导航结构组织：
/// 第一级：学科 (Physics, Chemistry, Mathematics, Biology)
/// 第二级：年级 (Grade7-Grade12)
/// 第三级：知识点分类 (Mechanics, Electricity, Optics, Thermodynamics)
/// 第四级：具体知识点 (Kinematics, ForceMotion, WorkEnergy, Momentum)
/// 第五级：模拟器文件 (具体的.swift文件)

// MARK: - 物理模拟器
struct PhysicsSimulators {
    
    // MARK: - 运动学模拟器
    struct Kinematics {
        // 使用字符串路径引用，避免编译时依赖
        static let projectileMotion = "ProjectileSimView"
        static let freeFall = "FreefallSimView"
        static let uniformMotion = "SimpleMotionSimView"
        static let uniformlyAcceleratedMotion = "SimpleMotionSimView"
    }
    
    // MARK: - 力与运动模拟器
    struct ForceMotion {
        static let forceAnalysis = "ForceMotionSimView"
        static let newtonThirdLaw = "ForceMotionSimView"
        static let frictionConstraint = "ForceMotionSimView"
    }
    
    // MARK: - 功与能模拟器
    struct WorkEnergy {
        // 待实现
    }
    
    // MARK: - 动量与冲量模拟器
    struct Momentum {
        // 待实现
    }
    
    // MARK: - 光学模拟器
    struct Optics {
        static let lensImaging = "LensSimView"
    }
    
    // MARK: - 热学模拟器
    struct Thermodynamics {
        // 待实现
    }
    
    // MARK: - 电学模拟器
    struct Electricity {
        // 待实现
    }
}

// MARK: - 化学模拟器
struct ChemistrySimulators {
    // 待实现
}

// MARK: - 数学模拟器
struct MathematicsSimulators {
    // 待实现
}

// MARK: - 生物模拟器
struct BiologySimulators {
    // 待实现
}

// MARK: - 模拟器工厂
struct SimulatorFactory {
    
    /// 根据知识点ID获取对应的模拟器类型
    /// - Parameter topicId: 知识点ID
    /// - Returns: 模拟器标识符，如果没有对应的模拟器则返回nil
    static func getSimulatorType(for topicId: String) -> String? {
        switch topicId {
        // 运动学相关
        case "projectile_motion":
            return PhysicsSimulators.Kinematics.projectileMotion
        case "free_fall":
            return PhysicsSimulators.Kinematics.freeFall
        case "uniform_motion", "uniformly_accelerated_motion":
            return PhysicsSimulators.Kinematics.uniformMotion
            
        // 力与运动相关
        case "force_analysis", "newton_third_law", "friction_constraint":
            return PhysicsSimulators.ForceMotion.forceAnalysis
            
        // 光学相关
        case "lens_imaging", "refraction_reflection":
            return PhysicsSimulators.Optics.lensImaging
            
        default:
            return nil
        }
    }
    
    /// 创建模拟器实例
    /// - Parameters:
    ///   - topicId: 知识点ID
    ///   - title: 模拟器标题
    /// - Returns: 模拟器视图，如果没有对应的模拟器则返回nil
    static func createSimulator(for topicId: String, title: String) -> AnyView? {
        guard let simulatorType = getSimulatorType(for: topicId) else {
            return nil
        }
        
        // 根据模拟器类型创建实例
        switch simulatorType {
        case "ProjectileSimView":
            return AnyView(ProjectileSimView(title: title))
        case "FreefallSimView":
            return AnyView(FreefallSimView(title: title))
        case "SimpleMotionSimView":
            return AnyView(SimpleMotionSimView(title: title, motionType: topicId))
        case "ForceMotionSimView":
            return AnyView(ForceMotionSimView(title: title, forceType: topicId))
        case "LensSimView":
            return AnyView(LensSimView(title: title))
        default:
            return nil
        }
    }
}

// MARK: - 模拟器分类信息
struct SimulatorCategory {
    let name: String
    let description: String
    let icon: String
    let topics: [SimulatorTopic]
}

struct SimulatorTopic {
    let id: String
    let name: String
    let description: String
    let hasSimulator: Bool
}

// MARK: - 模拟器统计信息
extension SimulatorFactory {
    
    /// 获取所有可用的模拟器统计信息
    static func getSimulatorStats() -> [String: Int] {
        var stats: [String: Int] = [:]
        
        // 物理模拟器统计
        stats["Physics"] = 5 // 当前实现的物理模拟器数量
        stats["Chemistry"] = 0
        stats["Mathematics"] = 0
        stats["Biology"] = 0
        
        return stats
    }
    
    /// 获取指定学科的模拟器列表
    static func getSimulatorsForSubject(_ subject: String) -> [String] {
        switch subject.lowercased() {
        case "physics":
            return [
                "ProjectileSimView - 抛体运动",
                "FreefallSimView - 自由落体",
                "SimpleMotionSimView - 直线运动",
                "ForceMotionSimView - 力与运动",
                "LensSimView - 透镜成像"
            ]
        case "chemistry":
            return []
        case "mathematics":
            return []
        case "biology":
            return []
        default:
            return []
        }
    }
}
