//
//  PhysicsRender.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/22.
//
import SwiftUI
import SceneKit

/// PhysicsRenderer.swift
/// 作用：负责在界面上渲染物理世界（PhysicsWorld）
/// 数据流：
/// PhysicsDSL.yaml → PhysicsDSLParser.swift → PhysicsValidator.swift → PhysicsSimulator.swift → PhysicsEngineBridge.swift → PhysicsRenderer.swift

struct PhysicsRenderer: UIViewRepresentable {
    /// 输入：物理世界（由 DSL + Simulator 得到）
    let physicsWorld: PhysicsWorld
    
    // ====================================================
    // MARK: - UIViewRepresentable 协议实现
    // ====================================================
    
    /// 创建 SceneKit 视图
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        
        // 1. 调用 PhysicsEngineBridge，把 PhysicsWorld → SCNScene
        let scene = PhysicsEngineBridge.buildScene(from: physicsWorld)
        scnView.scene = scene
        
        // 2. 开启 SceneKit 配置
        scnView.allowsCameraControl = true  // 支持手势拖动旋转、缩放
        scnView.showsStatistics = true      // 显示 FPS、draw call 等性能指标
        scnView.backgroundColor = UIColor.black  // 背景色（黑色方便突出物体）
        
        return scnView
    }
    
    /// 更新视图（当 SwiftUI 状态变化时调用）
    func updateUIView(_ scnView: SCNView, context: Context) {
        // 可以在这里响应 SwiftUI 的状态更新，比如暂停/恢复仿真
        scnView.scene = PhysicsEngineBridge.buildScene(from: physicsWorld)
    }
}
