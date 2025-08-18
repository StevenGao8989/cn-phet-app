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
    @State private var showVelocityComponents = true  // 控制是否显示速度分量
    @State private var vySnapshot: Double? = nil    // 暂停时的Vy快照，用于固定坐标轴中的分速度显示

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

                    // 轨迹（只显示已运动过的部分）
                    let currentT = playing ? t : t  // 使用当前时间，而不是tFlight
                    var path = Path()
                    var first = true
                    let steps = 240
                    for i in 0...steps {
                        let tt = currentT * Double(i) / Double(steps)
                        if tt > currentT { break }  // 只绘制到当前时间
                        let x = vx * tt
                        let y = max(0, h0 + vy * tt - 0.5 * g * tt * tt)
                        let p = toPoint(x: x, y: y)
                        if first { path.move(to: p); first = false } else { path.addLine(to: p) }
                    }
                    context.stroke(path, with: .color(.accentColor), lineWidth: 2)

                    // 当前运动点（红色圆点）
                    let currentX = vx * t
                    let currentY = max(0, h0 + vy * t - 0.5 * g * t * t)
                    let currentPoint = toPoint(x: currentX, y: currentY)
                    
                    // 绘制红色圆点
                    context.fill(Path(ellipseIn: CGRect(x: currentPoint.x-4, y: currentPoint.y-4, width: 8, height: 8)), with: .color(.red))
                    
                    // 绘制速度分量箭头（受状态变量控制）
                    if showVelocityComponents {
                        let arrowLength: CGFloat = 20
                        let vxCurrent = vx
                        let vyCurrent = vySnapshot ?? (vy - g * min(t, tFlight))
                        
                        // Vx 箭头（水平）
                        let vxEnd = CGPoint(x: currentPoint.x + arrowLength, y: currentPoint.y)
                        let vxArrow = Path { path in
                            path.move(to: currentPoint)
                            path.addLine(to: vxEnd)
                            // 箭头头部
                            path.move(to: vxEnd)
                            path.addLine(to: CGPoint(x: vxEnd.x - 6, y: vxEnd.y - 3))
                            path.move(to: vxEnd)
                            path.addLine(to: CGPoint(x: vxEnd.x - 6, y: vxEnd.y + 3))
                        }
                        context.stroke(vxArrow, with: .color(.black), lineWidth: 2)
                        
                        // Vy 箭头（垂直）
                        let vyEnd: CGPoint
                        let vyArrowHead1: CGPoint
                        let vyArrowHead2: CGPoint
                        
                        if vyCurrent >= 0 {
                            // 向上运动：箭头向上
                            vyEnd = CGPoint(x: currentPoint.x, y: currentPoint.y - arrowLength)
                            vyArrowHead1 = CGPoint(x: vyEnd.x - 3, y: vyEnd.y + 6)
                            vyArrowHead2 = CGPoint(x: vyEnd.x + 3, y: vyEnd.y + 6)
                        } else {
                            // 向下运动：箭头向下
                            vyEnd = CGPoint(x: currentPoint.x, y: currentPoint.y + arrowLength)
                            vyArrowHead1 = CGPoint(x: vyEnd.x - 3, y: vyEnd.y - 6)
                            vyArrowHead2 = CGPoint(x: vyEnd.x + 3, y: vyEnd.y - 6)
                        }
                        
                        let vyArrow = Path { path in
                            path.move(to: currentPoint)
                            path.addLine(to: vyEnd)
                            // 箭头头部
                            path.move(to: vyEnd)
                            path.addLine(to: vyArrowHead1)
                            path.move(to: vyEnd)
                            path.addLine(to: vyArrowHead2)
                        }
                        context.stroke(vyArrow, with: .color(.black), lineWidth: 2)
                        
                        // 速度分量标签
                        let vxLabel = "Vx=\(String(format: "%.1f", vxCurrent))"
                        let vyLabel = "Vy=\(String(format: "%.1f", vyCurrent))"
                        
                        let vxLabelAttr = AttributedString(vxLabel)
                        let vyLabelAttr = AttributedString(vyLabel)
                        
                        context.draw(Text(vxLabelAttr).font(.caption2).foregroundColor(.black), 
                                   at: CGPoint(x: vxEnd.x + 5, y: vxEnd.y), 
                                   anchor: .leading)
                        
                        // Vy标签位置根据箭头方向动态调整
                        let vyLabelY: CGFloat
                        let vyLabelAnchor: UnitPoint
                        if vyCurrent >= 0 {
                            // 向上运动：标签在箭头上方
                            vyLabelY = vyEnd.y - 5
                            vyLabelAnchor = .bottom
                        } else {
                            // 向下运动：标签在箭头下方
                            vyLabelY = vyEnd.y + 5
                            vyLabelAnchor = .top
                        }
                        
                        context.draw(Text(vyLabelAttr).font(.caption2).foregroundColor(.black), 
                                   at: CGPoint(x: vyEnd.x, y: vyLabelY), 
                                   anchor: vyLabelAnchor)
                    }

                    // 标注：射程
                    let groundEnd = toPoint(x: range, y: 0)
                    context.stroke(Path { p in
                        p.move(to: CGPoint(x: groundEnd.x, y: groundEnd.y))
                        p.addLine(to: CGPoint(x: groundEnd.x, y: size.height - margin))
                    }, with: .color(.gray.opacity(0.6)), style: StrokeStyle(dash: [4,4]))

                    
                }
                .background(Color(UIColor.systemBackground))
            }
            .frame(height: 360)
            .padding(.bottom, 8)

            // 实时参数数值表格
            VStack(spacing: 8) {
                Text("实时参数数值 (随动画更新)")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // 参数表格 - 一个大表格包含两列
                VStack(spacing: 0) {
                    // 第一行
                    HStack(spacing: 0) {
                        // 左列 - 不可编辑的变量
                        HStack {
                            Text("t (s)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "%.2f", min(t, tFlight)))
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // 右列 - 可编辑的变量
                        HStack {
                            Text("v₀ (m/s)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("20.0", value: $v0, format: .number.precision(.fractionLength(1)))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .keyboardType(.decimalPad)
                                .onChange(of: v0) { restartIfNeeded() }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    // 第二行
                    HStack(spacing: 0) {
                        // 左列
                        HStack {
                            Text("x (m)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "%.2f", min(vx * min(t, tFlight), range)))
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // 右列
                        HStack {
                            Text("θ (°)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("45.0", value: $theta, format: .number.precision(.fractionLength(1)))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .keyboardType(.decimalPad)
                                .onChange(of: theta) { restartIfNeeded() }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    // 第三行
                    HStack(spacing: 0) {
                        // 左列
                        HStack {
                            Text("y (m)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "%.2f", max(0, h0 + vy * min(t, tFlight) - 0.5 * g * min(t, tFlight) * min(t, tFlight))))
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // 右列
                        HStack {
                            Text("g (m/s²)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("9.8", value: $g, format: .number.precision(.fractionLength(1)))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .keyboardType(.decimalPad)
                                .onChange(of: g) { restartIfNeeded() }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    // 第四行
                    HStack(spacing: 0) {
                        // 左列
                        HStack {
                            Text("Vx (m/s)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "%.2f", vx))
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .frame(height: 40)
                        
                        // 右列
                        HStack {
                            Text("h₀ (m)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextField("0.0", value: $h0, format: .number.precision(.fractionLength(1)))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                                .keyboardType(.decimalPad)
                                .onChange(of: h0) { restartIfNeeded() }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    // 第五行 - Vy跨两列
                    HStack {
                        Text("Vy (m/s)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(String(format: "%.2f", vySnapshot ?? (vy - g * min(t, tFlight))))
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.3), lineWidth: 1))
            }
            .padding(.horizontal)
            .padding(.bottom, 12)

            // 控制按钮
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Button(playing ? "暂停" : "播放") {
                        if playing {
                            // 即将从播放切换到暂停：记录当前Vy
                            vySnapshot = vy - g * min(t, tFlight)
                            playing = false
                            stopTimer()
                        } else {
                            // 从暂停切回播放：清除快照并继续计时
                            vySnapshot = nil
                            playing = true
                            startTimer()
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("重置") {
                        stopTimer()
                        t = 0
                        playing = false
                    }
                    .buttonStyle(.bordered)

                    Button(showVelocityComponents ? "隐藏分速度" : "显示分速度") {
                        showVelocityComponents.toggle()
                    }
                    .buttonStyle(.bordered)
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
                   at: CGPoint(x: size.width - 12, y: size.height - 45), 
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
        // 参数验证和限制
        v0 = max(1.0, min(100.0, v0))        // 初速度限制在1-100 m/s
        theta = max(0.0, min(90.0, theta))   // 角度限制在0-90度
        g = max(0.1, min(50.0, g))           // 重力加速度限制在0.1-50 m/s²
        h0 = max(0.0, min(100.0, h0))        // 初始高度限制在0-100 m
        
        if playing {
            t = 0
        }
    }
    
    // 角度转弧度
    private func deg2rad(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
}
