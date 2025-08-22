import Foundation
import SceneKit   // 用 SceneKit 做 3D 动画，2D 可以换 SpriteKit

class PhysicsEngineBridge {
    
    var scene: SCNScene
    
    init() {
        self.scene = SCNScene()
    }
    
    /// 根据 JSON 配置初始化物理世界
    func loadFromJSON(_ json: [String: Any]) {
        // 1. 加载物体
        if let objects = json["objects"] as? [[String: Any]] {
            for obj in objects {
                if let type = obj["type"] as? String {
                    switch type {
                    case "particle":
                        createParticle(obj)
                    case "block":
                        createBlock(obj)
                    case "pendulum":
                        createPendulum(obj)
                    case "spring":
                        createSpring(obj)
                    default:
                        print("⚠️ 未知对象类型: \(type)")
                    }
                }
            }
        }
        
        // 2. 加载力
        if let forces = json["forces"] as? [[String: Any]] {
            for force in forces {
                applyForce(force)
            }
        }
    }
    
    // ====== 示例: 创建小球 ======
    private func createParticle(_ obj: [String: Any]) {
        let radius = obj["radius"] as? Double ?? 0.1
        let sphere = SCNSphere(radius: CGFloat(radius))
        let node = SCNNode(geometry: sphere)
        
        if let initPos = (obj["initial"] as? [String: Any])?["position"] as? [String: Double] {
            node.position = SCNVector3(x: Float(initPos["x"] ?? 0.0),
                                       y: Float(initPos["y"] ?? 0.0),
                                       z: 0.0)
        }
        
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.physicsBody?.mass = obj["mass"] as? CGFloat ?? 1.0
        scene.rootNode.addChildNode(node)
    }
    
    // ====== 示例: 创建方块 ======
    private func createBlock(_ obj: [String: Any]) {
        let size = obj["size"] as? [String: Double] ?? ["width": 0.5, "height": 0.2]
        let box = SCNBox(width: CGFloat(size["width"] ?? 0.5),
                         height: CGFloat(size["height"] ?? 0.2),
                         length: 0.1,
                         chamferRadius: 0)
        let node = SCNNode(geometry: box)
        node.physicsBody = SCNPhysicsBody.dynamic()
        node.physicsBody?.mass = obj["mass"] as? CGFloat ?? 1.0
        scene.rootNode.addChildNode(node)
    }
    
    // ====== 示例: 简单施加重力 ======
    private func applyForce(_ force: [String: Any]) {
        if let type = force["type"] as? String, type == "gravity" {
            let g = force["g"] as? Double ?? 9.8
            scene.physicsWorld.gravity = SCNVector3(0, Float(-g), 0)
        }
    }
    
    func getScene() -> SCNScene {
        return scene
    }
}
