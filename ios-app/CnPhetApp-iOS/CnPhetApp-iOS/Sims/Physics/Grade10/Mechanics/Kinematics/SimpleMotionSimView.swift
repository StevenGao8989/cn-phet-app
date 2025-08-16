//
//  SimpleMotionSimView.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/1/27.
//

import Foundation
import SwiftUI

struct SimpleMotionSimView: View {
    let title: String
    let motionType: String
    
    // 添加明确的公共初始化器
    init(title: String, motionType: String) {
        self.title = title
        self.motionType = motionType
    }
    
    @State private var v0: Double = 10.0     // 初速度 m/s
    @State private var a: Double = 2.0       // 加速度 m/s²
    @State private var playing = false
    @State private var t: Double = 0
    @State private var timer: Timer?
    
    private var isUniformMotion: Bool { motionType == "uniform_motion" }
    private var tMax: Double { isUniformMotion ? 10.0 : 8.0 } // 最大时间
    private var x: Double { isUniformMotion ? v0 * t : v0 * t + 0.5 * a * t * t } // 位移
    private var v: Double { isUniformMotion ? v0 : v0 + a * t } // 速度
    
    var body: some View {
        VStack(spacing: 0) {
            // 画布区域
            GeometryReader { geo in
                Canvas { context, size in
                    let margin: CGFloat = 28
                    let drawable = CGSize(width: size.width - margin*2, height: size.height - margin*2)
                    
                    // 计算合适的比例
                    let maxX = isUniformMotion ? v0 * tMax : max(v0 * tMax + 0.5 * a * tMax * tMax, v0 * tMax)
                    let scaleX = drawable.width / max(maxX, 1)
                    let scaleY = drawable.height / 2
                    
                    // 绘制坐标轴
                    let axes = Path { path in
                        // x轴（时间轴）
                        path.move(to: CGPoint(x: margin, y: size.height - margin))
                        path.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
                        
                        // y轴（位移轴）
                        path.move(to: CGPoint(x: margin, y: margin))
                        path.addLine(to: CGPoint(x: margin, y: size.height - margin))
                    }
                    context.stroke(axes, with: .color(.secondary), lineWidth: 1)
                    
                    // 绘制运动轨迹
                    let currentT = playing ? min(t, tMax) : tMax
                    var path = Path()
                    var first = true
                    let steps = 100
                    
                    for i in 0...steps {
                        let tt = currentT * Double(i) / Double(steps)
                        let xx = isUniformMotion ? v0 * tt : v0 * tt + 0.5 * a * tt * tt
                        let px = margin + CGFloat(xx) * scaleX
                        let py = size.height - margin - CGFloat(tt) * scaleY
                        
                        if first {
                            path.move(to: CGPoint(x: px, y: py))
                            first = false
                        } else {
                            path.addLine(to: CGPoint(x: px, y: py))
                        }
                    }
                    context.stroke(path, with: .color(.accentColor), lineWidth: 2)
                    
                    // 绘制当前点
                    let currentX = margin + CGFloat(x) * scaleX
                    let currentY = size.height - margin - CGFloat(t) * scaleY
                    let currentPoint = Path(ellipseIn: CGRect(x: currentX-4, y: currentY-4, width: 8, height: 8))
                    context.fill(currentPoint, with: .color(.orange))
                    
                    // 显示信息
                    let info = "t≈\(String(format: "%.1f", t))s  x≈\(String(format: "%.1f", x))m  v≈\(String(format: "%.1f", v))m/s"
                    context.draw(Text(info).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 10), anchor: .topLeading)
                }
                .background(Color(UIColor.systemBackground))
            }
            .frame(height: 360)
            .padding(.bottom, 8)
            
            // 参数控制
            VStack(spacing: 12) {
                HStack { Text("v₀ 初速度"); Spacer(); Text("\(Int(v0)) m/s") }
                Slider(value: $v0, in: 1...20, step: 1) { _ in resetIfNeeded() }
                
                if !isUniformMotion {
                    HStack { Text("a 加速度"); Spacer(); Text(String(format: "%.1f m/s²", a)) }
                    Slider(value: $a, in: -5.0...5.0, step: 0.1) { _ in resetIfNeeded() }
                }
                
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
    
    private func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 1/30.0, repeats: true) { _ in
            t += 1/30.0
            if t >= tMax {
                t = tMax
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
