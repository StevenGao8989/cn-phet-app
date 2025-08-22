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
    
    // ====== 示例: 创建单摆 ======
    private func createPendulum(_ obj: [String: Any]) {
        let length = obj["length"] as? Double ?? 1.0
        let mass = obj["mass"] as? Double ?? 1.0
        
        // 创建摆球
        let sphere = SCNSphere(radius: CGFloat(mass * 0.1))
        let ballNode = SCNNode(geometry: sphere)
        ballNode.position = SCNVector3(0, Float(-length), 0)
        ballNode.physicsBody = SCNPhysicsBody.dynamic()
        ballNode.physicsBody?.mass = CGFloat(mass)
        
        // 创建摆线（约束）- 使用固定点作为锚点
        let anchorNode = SCNNode()
        anchorNode.position = SCNVector3(0, 0, 0)
        anchorNode.physicsBody = SCNPhysicsBody.static()
        
        let constraint = SCNPhysicsBallSocketJoint(
            bodyA: ballNode.physicsBody!,
            anchorA: SCNVector3(0, 0, 0),
            bodyB: anchorNode.physicsBody!,
            anchorB: SCNVector3(0, 0, 0)
        )
        
        scene.rootNode.addChildNode(anchorNode)
        scene.rootNode.addChildNode(ballNode)
        scene.physicsWorld.addBehavior(constraint)
    }
    
    // ====== 示例: 创建弹簧 ======
    private func createSpring(_ obj: [String: Any]) {
        let stiffness = obj["stiffness"] as? Double ?? 100.0
        let damping = obj["damping"] as? Double ?? 10.0
        let restLength = obj["restLength"] as? Double ?? 1.0
        
        // 创建弹簧端点
        let endPoint1 = SCNNode()
        endPoint1.position = SCNVector3(0, 0, 0)
        endPoint1.physicsBody = SCNPhysicsBody.static()
        
        let endPoint2 = SCNNode()
        endPoint2.position = SCNVector3(0, Float(-restLength), 0)
        endPoint2.physicsBody = SCNPhysicsBody.dynamic()
        endPoint2.physicsBody?.mass = 1.0
        
        // 创建弹簧约束 - 使用 SCNPhysicsBallSocketJoint 模拟弹簧效果
        let springConstraint = SCNPhysicsBallSocketJoint(
            bodyA: endPoint1.physicsBody!,
            anchorA: SCNVector3(0, 0, 0),
            bodyB: endPoint2.physicsBody!,
            anchorB: SCNVector3(0, 0, 0)
        )
        
        scene.rootNode.addChildNode(endPoint1)
        scene.rootNode.addChildNode(endPoint2)
        scene.physicsWorld.addBehavior(springConstraint)
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
