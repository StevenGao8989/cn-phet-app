//
//  ProjectileSimVIew.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation
import SwiftUI

struct ProjectileSimView: View {
    let title: String

    // 添加明确的公共初始化器
    init(title: String) {
        self.title = title
    }

    @State private var v0: Double = 20     // 初速度 m/s
    @State private var theta: Double = 45  // 角度 °
    @State private var g: Double = 9.8     // 重力 m/s²
    @State private var h0: Double = 0      // 初始高度 m

    @State private var playing = false
    @State private var t: Double = 0       // 已播放时间 s
    @State private var timer: Timer?

    private var vx: Double { v0 * cos(deg2rad(theta)) }
    private var vy: Double { v0 * sin(deg2rad(theta)) }
    private var tFlight: Double { 
        // 考虑初始高度的飞行时间计算
        let discriminant = vy * vy + 2 * g * h0
        if discriminant < 0 { return 0.0001 }
        return max(0.0001, (vy + sqrt(discriminant)) / g)
    }
    private var range: Double { vx * tFlight }
    private var hMax: Double { h0 + vy * vy / (2 * g) }

    var body: some View {
        VStack(spacing: 0) {
            // 画布区域
            GeometryReader { geo in
                Canvas { context, size in
                    drawAxes(context: &context, size: size)

                    // 世界坐标 -> 画布坐标（保留边距并适配比例）
                    let margin: CGFloat = 28
                    let drawable = CGSize(width: size.width - margin*2, height: size.height - margin*2)
                    let scaleX = drawable.width / max(range, 1)      // m → px
                    let scaleY = drawable.height / max(hMax * 1.2, 1)

                    func toPoint(x: Double, y: Double) -> CGPoint {
                        let px = margin + CGFloat(x) * scaleX
                        let py = size.height - margin - CGFloat(y) * scaleY // y 轴向上
                        return CGPoint(x: px, y: py)
                    }

                    // 轨迹（到当前时间）
                    let currentT = playing ? min(t, tFlight) : tFlight
                    var path = Path()
                    var first = true
                    let steps = 240
                    for i in 0...steps {
                        let tt = currentT * Double(i) / Double(steps)
                        let x = vx * tt
                        let y = max(0, h0 + vy * tt - 0.5 * g * tt * tt)
                        let p = toPoint(x: x, y: y)
                        if first { path.move(to: p); first = false } else { path.addLine(to: p) }
                    }
                    context.stroke(path, with: .color(.accentColor), lineWidth: 2)

                    // 标注：最高点与射程
                    let apex = toPoint(x: range/2, y: hMax)
                    let groundEnd = toPoint(x: range, y: 0)
                    context.fill(Path(ellipseIn: CGRect(x: apex.x-3, y: apex.y-3, width: 6, height: 6)), with: .color(.orange))
                    context.stroke(Path { p in
                        p.move(to: CGPoint(x: groundEnd.x, y: groundEnd.y))
                        p.addLine(to: CGPoint(x: groundEnd.x, y: size.height - margin))
                    }, with: .color(.gray.opacity(0.6)), style: StrokeStyle(dash: [4,4]))

                    // 文本信息（简）
                    let info = "时间≈\(String(format: "%.2f", tFlight))s 水平距离≈\(String(format: "%.2f", range))m  最高点≈\(String(format: "%.2f", hMax))m"
                    let attr = AttributedString(info)
                    context.draw(Text(attr).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 30), anchor: .topLeading)
                }
                .background(Color(UIColor.systemBackground))
            }
            .frame(height: 360)
            .padding(.bottom, 8)

            // 参数控制
            VStack(spacing: 12) {
                HStack { Text("v₀ 初速度"); Spacer(); Text("\(Int(v0)) m/s") }
                Slider(value: $v0, in: 5...60, step: 1) { _ in restartIfNeeded() }

                HStack { Text("θ 发射角"); Spacer(); Text("\(Int(theta)) °") }
                Slider(value: $theta, in: 5...85, step: 1) { _ in restartIfNeeded() }

                HStack { Text("g 重力加速度"); Spacer(); Text(String(format: "%.1f m/s²", g)) }
                Slider(value: $g, in: 3.0...19.6, step: 0.1) { _ in restartIfNeeded() }

                HStack { Text("h₀ 初始高度"); Spacer(); Text(String(format: "%.1f m", h0)) }
                Slider(value: $h0, in: 0...20, step: 0.1) { _ in restartIfNeeded() }

                HStack(spacing: 12) {
                    Button(playing ? "暂停" : "播放") {
                        playing.toggle()
                        playing ? startTimer() : stopTimer()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("重置") {
                        stopTimer()
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
        .onDisappear { stopTimer() }
    }

    private func drawAxes(context: inout GraphicsContext, size: CGSize) {
        let margin: CGFloat = 28
        let drawable = CGSize(width: size.width - margin*2, height: size.height - margin*2)
        
        // 计算坐标轴刻度
        let xMax = max(range, 1)
        let yMax = max(hMax * 1.2, 1)
        
        // 计算合适的刻度间隔
        let xStep = calculateStep(maxValue: xMax)
        let yStep = calculateStep(maxValue: yMax)
        
        var axes = Path()
        
        // x 轴
        axes.move(to: CGPoint(x: margin, y: size.height - margin))
        axes.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
        
        // y 轴
        axes.move(to: CGPoint(x: margin, y: size.height - margin))
        axes.addLine(to: CGPoint(x: margin, y: margin))
        
        // 绘制坐标轴
        context.stroke(axes, with: .color(.secondary), lineWidth: 1)
        
        // 绘制 x 轴刻度和标签
        let scaleX = drawable.width / xMax
        for i in stride(from: 0, through: xMax, by: xStep) {
            let x = margin + CGFloat(i) * scaleX
            if x <= size.width - margin {
                // 刻度线
                let tickPath = Path { path in
                    path.move(to: CGPoint(x: x, y: size.height - margin))
                    path.addLine(to: CGPoint(x: x, y: size.height - margin + 6))
                }
                context.stroke(tickPath, with: .color(.secondary), lineWidth: 1)
                
                // 标签
                let label = "\(Int(i))"
                let attr = AttributedString(label)
                context.draw(Text(attr).font(.caption2).foregroundColor(.secondary), 
                           at: CGPoint(x: x, y: size.height - margin + 12), 
                           anchor: .top)
            }
        }
        
        // 绘制 y 轴刻度和标签
        let scaleY = drawable.height / yMax
        for i in stride(from: 0, through: yMax, by: yStep) {
            let y = size.height - margin - CGFloat(i) * scaleY
            if y >= margin {
                // 刻度线
                let tickPath = Path { path in
                    path.move(to: CGPoint(x: margin, y: y))
                    path.addLine(to: CGPoint(x: margin - 6, y: y))
                }
                context.stroke(tickPath, with: .color(.secondary), lineWidth: 1)
                
                // 标签
                let label = "\(Int(i))"
                let attr = AttributedString(label)
                context.draw(Text(attr).font(.caption2).foregroundColor(.secondary), 
                           at: CGPoint(x: margin - 12, y: y), 
                           anchor: .trailing)
            }
        }
        
        // 添加坐标轴标签
        let xAxisLabel = "距离 (m)"
        let yAxisLabel = "高度 h (m)"
        
        // x 轴标签 - 移到最右端，确保完全可见
        let xLabelAttr = AttributedString(xAxisLabel)
        context.draw(Text(xLabelAttr).font(.caption).foregroundColor(.secondary), 
                   at: CGPoint(x: size.width - 12, y: size.height - 8), 
                   anchor: .topTrailing)
        
        // y 轴标签 - 移到最上端
        let yLabelAttr = AttributedString(yAxisLabel)
        context.draw(Text(yLabelAttr).font(.caption).foregroundColor(.secondary), 
                   at: CGPoint(x: margin + 8, y: margin + 8), 
                   anchor: .topLeading)
    }
    
    // 计算合适的刻度间隔
    private func calculateStep(maxValue: Double) -> Double {
        let magnitude = pow(10, floor(log10(maxValue)))
        let normalized = maxValue / magnitude
        
        if normalized < 2 {
            return magnitude / 5
        } else if normalized < 5 {
            return magnitude / 2
        } else {
            return magnitude
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
            t += 1.0/60.0
            if t >= tFlight {
                t = tFlight
                stopTimer()
                playing = false
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func restartIfNeeded() {
        if playing {
            t = 0
        }
    }
    
    // 角度转弧度
    private func deg2rad(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
}
