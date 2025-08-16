//
//  ForceMotionSimView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import Foundation
import SwiftUI

struct ForceMotionSimView: View {
    let title: String
    let forceType: String
    
    // 添加明确的公共初始化器
    init(title: String, forceType: String) {
        self.title = title
        self.forceType = forceType
    }
    
    @State private var mass: Double = 5.0      // 质量 kg
    @State private var appliedForce: Double = 20.0  // 施加力 N
    @State private var frictionCoef: Double = 0.3   // 摩擦系数
    @State private var angle: Double = 0.0     // 力的角度 °
    @State private var playing = false
    @State private var t: Double = 0
    @State private var timer: Timer?
    
    private var g: Double = 9.8  // 重力加速度
    private var normalForce: Double { mass * g }  // 支持力
    private var frictionForce: Double { frictionCoef * normalForce }  // 摩擦力
    private var netForce: Double {  // 合力
        let fx = appliedForce * cos(deg2rad(angle))
        let fy = appliedForce * sin(deg2rad(angle)) - mass * g
        return sqrt(fx * fx + fy * fy)
    }
    private var acceleration: Double { netForce / mass }  // 加速度
    private var velocity: Double { acceleration * t }  // 速度
    private var displacement: Double { 0.5 * acceleration * t * t }  // 位移
    
    var body: some View {
        VStack(spacing: 0) {
            // 画布区域
            GeometryReader { geo in
                Canvas { context, size in
                    let margin: CGFloat = 28
                    let drawable = CGSize(width: size.width - margin*2, height: size.height - margin*2)
                    
                    // 绘制地面
                    let ground = Path { path in
                        path.move(to: CGPoint(x: margin, y: size.height - margin))
                        path.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
                    }
                    context.stroke(ground, with: .color(.brown), lineWidth: 3)
                    
                    // 绘制物体
                    let objectSize: CGFloat = 40
                    let objectX = margin + 100 + CGFloat(displacement) * 10.0
                    let objectY = size.height - margin - objectSize
                    let object = Path(ellipseIn: CGRect(x: objectX, y: objectY, width: objectSize, height: objectSize))
                    context.fill(object, with: .color(.blue))
                    
                    // 绘制力的箭头
                    let arrowStart = CGPoint(x: objectX + objectSize/2, y: objectY + objectSize/2)
                    let arrowEnd = CGPoint(
                        x: arrowStart.x + CGFloat(appliedForce) * 2.0 * cos(deg2rad(angle)),
                        y: arrowStart.y - CGFloat(appliedForce) * 2.0 * sin(deg2rad(angle))
                    )
                    
                    // 力的箭头
                    let forceArrow = Path { path in
                        path.move(to: arrowStart)
                        path.addLine(to: arrowEnd)
                        // 箭头头部
                        let headLength: CGFloat = 10
                        let angleRad = atan2(arrowEnd.y - arrowStart.y, arrowEnd.x - arrowStart.x)
                        let head1 = CGPoint(
                            x: arrowEnd.x - headLength * cos(angleRad - 0.3),
                            y: arrowEnd.y - headLength * sin(angleRad - 0.3)
                        )
                        let head2 = CGPoint(
                            x: arrowEnd.x - headLength * cos(angleRad + 0.3),
                            y: arrowEnd.y - headLength * sin(angleRad + 0.3)
                        )
                        path.move(to: arrowEnd)
                        path.addLine(to: head1)
                        path.move(to: arrowEnd)
                        path.addLine(to: head2)
                    }
                    context.stroke(forceArrow, with: .color(.red), lineWidth: 3)
                    
                    // 绘制重力箭头
                    let gravityArrow = Path { path in
                        let gravityStart = CGPoint(x: objectX + objectSize/2, y: objectY + objectSize/2)
                        let gravityEnd = CGPoint(x: gravityStart.x, y: gravityStart.y + CGFloat(mass * g) * 2.0)
                        path.move(to: gravityStart)
                        path.addLine(to: gravityEnd)
                    }
                    context.stroke(gravityArrow, with: .color(.green), lineWidth: 2)
                    
                    // 绘制摩擦力箭头
                    if abs(velocity) > 0.1 {
                        let frictionArrow = Path { path in
                            let frictionStart = CGPoint(x: objectX + objectSize/2, y: objectY + objectSize/2)
                            let frictionEnd = CGPoint(x: frictionStart.x - CGFloat(frictionForce) * 2.0, y: frictionStart.y)
                            path.move(to: frictionStart)
                            path.addLine(to: frictionEnd)
                        }
                        context.stroke(frictionArrow, with: .color(.orange), lineWidth: 2)
                    }
                    
                    // 显示信息
                    let info = "m=\(String(format: "%.1f", mass))kg  F=\(String(format: "%.1f", appliedForce))N  a=\(String(format: "%.2f", acceleration))m/s²"
                    context.draw(Text(info).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 10), anchor: .topLeading)
                    
                    let motionInfo = "v=\(String(format: "%.1f", velocity))m/s  x=\(String(format: "%.1f", displacement))m"
                    context.draw(Text(motionInfo).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 30), anchor: .topLeading)
                }
                .background(Color(UIColor.systemBackground))
            }
            .frame(height: 360)
            .padding(.bottom, 8)
            
            // 参数控制
            VStack(spacing: 12) {
                HStack { Text("质量 m"); Spacer(); Text("\(String(format: "%.1f", mass)) kg") }
                Slider(value: $mass, in: 1...20, step: 0.5) { _ in resetIfNeeded() }
                
                HStack { Text("施加力 F"); Spacer(); Text("\(Int(appliedForce)) N") }
                Slider(value: $appliedForce, in: 5...100, step: 5) { _ in resetIfNeeded() }
                
                HStack { Text("角度 θ"); Spacer(); Text("\(Int(angle)) °") }
                Slider(value: $angle, in: -90...90, step: 5) { _ in resetIfNeeded() }
                
                HStack { Text("摩擦系数 μ"); Spacer(); Text(String(format: "%.2f", frictionCoef)) }
                Slider(value: $frictionCoef, in: 0...1, step: 0.05) { _ in resetIfNeeded() }
                
                HStack(spacing: 12) {
                    Button(playing ? "暂停" : "播放") {
                        playing.toggle()
                        playing ? start() : stop()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("重置") {
                        stop()
                        t = 0
                        playing = false
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .navigationTitle(title)
        .onDisappear { stop() }
    }
    
    private func deg2rad(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    private func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 1/30.0, repeats: true) { _ in
            t += 1/30.0
            if t >= 10.0 { // 10秒后停止
                t = 10.0
                stop()
                playing = false
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func resetIfNeeded() {
        if playing {
            t = 0
        }
    }
}
