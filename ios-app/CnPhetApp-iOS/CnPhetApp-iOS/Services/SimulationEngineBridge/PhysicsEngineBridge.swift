import Foundation
import SceneKit

/// PhysicsEngineBridge.swift
/// 作用：将 PhysicsWorld（物理抽象世界）映射为 SceneKit 可渲染的 3D 场景。
/// 注意：这里只负责 **可视化**，而不是物理计算。物理计算由 PhysicsSimulator.swift 处理。

class PhysicsEngineBridge {
    
    /// 将物理世界（PhysicsWorld）转换为 SceneKit 场景
    /// - Parameter world: 从 DSL → Simulator 得到的 PhysicsWorld
    /// - Returns: SCNScene，包含所有渲染好的物体、灯光、运动动画
    static func buildScene(from world: PhysicsWorld) -> SCNScene {
        let scene = SCNScene()
        
        // ============ 1. 背景与灯光 ============
        // 创建一个点光源（omni light），放在 3D 场景的右上方
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 5, y: 5, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // 创建环境光（ambient light），保证阴影部分不会完全黑
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLight)
        
        // ============ 2. 渲染 DSL 定义的物体 ============
        // 遍历 PhysicsWorld 中的所有对象（particle、block、pendulum...）
        for obj in world.objects {
            // 为每个 DSL 对象创建一个对应的 SCNNode（球体、立方体等）
            let node = createNode(for: obj)
            scene.rootNode.addChildNode(node)
        }
        
        // ============ 3. 添加运动动画 ============
        // 遍历 motions，给目标节点绑定对应的 SCNAction 动画
        for motion in world.motions {
            if let targetNode = scene.rootNode.childNode(withName: motion.target, recursively: true) {
                applyMotion(motion, to: targetNode)
            }
        }
        
        // ============ 4. 力与场的可视化 ============
        // 遍历 forces，未来可以绘制场线、波前等效果
        for force in world.forces {
            visualizeForce(force, in: scene)
        }
        
        return scene
    }
    
    // =========================
    // MARK: - 物体构造
    // =========================
    
    /// 根据 DSL 中的 PhysicsObject 创建对应的 SceneKit 节点
    /// - Parameter obj: DSL 定义的物体
    /// - Returns: SCNNode（带有几何体和材质）
    private static func createNode(for obj: PhysicsObject) -> SCNNode {
        var geometry: SCNGeometry
        
        // 根据 type 类型选择不同几何体
        switch obj.type {
        case "particle": // 质点 → 球体
            geometry = SCNSphere(radius: CGFloat(obj.radius ?? 0.05))
            geometry.firstMaterial?.diffuse.contents = UIColor.red
            
        case "block": // 小车/方块 → 立方体
            let w = CGFloat(obj.size?.width ?? 0.5)
            let h = CGFloat(obj.size?.height ?? 0.2)
            geometry = SCNBox(width: w, height: h, length: 0.2, chamferRadius: 0.01)
            geometry.firstMaterial?.diffuse.contents = UIColor.blue
            
        case "pendulum": // 单摆球 → 球体
            geometry = SCNSphere(radius: 0.1)
            geometry.firstMaterial?.diffuse.contents = UIColor.orange
            
        case "spring": // 弹簧 → 圆柱体
            geometry = SCNCylinder(radius: 0.05, height: CGFloat(obj.restLength ?? 0.5))
            geometry.firstMaterial?.diffuse.contents = UIColor.green
            
        case "charge": // 电荷 → 球体（黄色）
            geometry = SCNSphere(radius: 0.1)
            geometry.firstMaterial?.diffuse.contents = UIColor.yellow
            
        case "light": // 光线源 → 锥体（表示方向）
            geometry = SCNCone(topRadius: 0, bottomRadius: 0.05, height: 0.2)
            geometry.firstMaterial?.diffuse.contents = UIColor.white
            
        default: // 未知物体 → 灰色小球
            geometry = SCNSphere(radius: 0.05)
            geometry.firstMaterial?.diffuse.contents = UIColor.gray
        }
        
        // 创建节点并设置位置
        let node = SCNNode(geometry: geometry)
        node.name = obj.id
        if let pos = obj.position {
            node.position = SCNVector3(pos.x, pos.y, 0)
        }
        
        return node
    }
    
    // =========================
    // MARK: - 运动模型
    // =========================
    
    /// 根据 DSL 中的运动模型（motions）为节点绑定动画
    /// - Parameters:
    ///   - motion: DSL 定义的运动
    ///   - node: 需要添加动画的 SceneKit 节点
    private static func applyMotion(_ motion: PhysicsMotion, to node: SCNNode) {
        switch motion.type {
        case "free_fall": // 自由落体
            if let g = motion.params["g"] as? Double {
                let action = SCNAction.moveBy(x: 0, y: -CGFloat(g), z: 0, duration: 1.0)
                let repeatAction = SCNAction.repeatForever(action)
                node.runAction(repeatAction)
            }
            
        case "oscillation": // 简谐振动（左右来回）
            if let amplitude = motion.params["amplitude"] as? Double {
                let moveRight = SCNAction.moveBy(x: CGFloat(amplitude), y: 0, z: 0, duration: 0.5)
                let moveLeft = SCNAction.moveBy(x: -CGFloat(amplitude), y: 0, z: 0, duration: 0.5)
                let sequence = SCNAction.sequence([moveRight, moveLeft])
                let repeatAction = SCNAction.repeatForever(sequence)
                node.runAction(repeatAction)
            }
            
        case "projectile": // 抛体运动（匀速近似）
            if let speed = motion.params["speed"] as? Double,
               let angle = motion.params["angle"] as? Double {
                let vx = speed * cos(angle * .pi / 180)
                let vy = speed * sin(angle * .pi / 180)
                let action = SCNAction.moveBy(x: CGFloat(vx), y: CGFloat(vy), z: 0, duration: 1.0)
                let repeatAction = SCNAction.repeatForever(action)
                node.runAction(repeatAction)
            }
            
        default:
            break
        }
    }
    
    // =========================
    // MARK: - 力与场可视化
    // =========================
    
    /// 力与场的可视化（目前是占位实现）
    /// - Parameters:
    ///   - force: DSL 定义的力（gravity, electric_field, magnetic_field...）
    ///   - scene: 当前场景，用于添加可视化节点
    private static func visualizeForce(_ force: PhysicsForce, in scene: SCNScene) {
        switch force.type {
        case "gravity":
            print("🌍 Gravity applied to \(force.target ?? [])")
        case "electric_field":
            print("⚡ Electric field visualized: \(String(describing: force.E))")
        case "magnetic_field":
            print("🧲 Magnetic field visualized: \(String(describing: force.B))")
        default:
            break
        }
    }
}
