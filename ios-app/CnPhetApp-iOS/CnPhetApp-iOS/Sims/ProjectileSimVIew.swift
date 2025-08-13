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

    @State private var v0: Double = 20     // 初速度 m/s
    @State private var theta: Double = 45  // 角度 °
    @State private var g: Double = 9.8     // 重力 m/s²

    @State private var playing = false
    @State private var t: Double = 0       // 已播放时间 s
    @State private var timer: Timer?

    private var vx: Double { v0 * cos(deg2rad(theta)) }
    private var vy: Double { v0 * sin(deg2rad(theta)) }
    private var tFlight: Double { max(0.0001, 2 * vy / g) }
    private var range: Double { vx * tFlight }
    private var hMax: Double { vy * vy / (2 * g) }

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
                        let y = max(0, vy * tt - 0.5 * g * tt * tt)
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
                    let info = "t飞行≈\(String(format: "%.2f", tFlight))s  射程≈\(String(format: "%.2f", range))m  最高点≈\(String(format: "%.2f", hMax))m"
                    let attr = AttributedString(info)
                    context.draw(Text(attr).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 10), anchor: .topLeading)
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
        var axes = Path()
        // x 轴
        axes.move(to: CGPoint(x: margin, y: size.height - margin))
        axes.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
        // y 轴
        axes.move(to: CGPoint(x: margin, y: size.height - margin))
        axes.addLine(to: CGPoint(x: margin, y: margin))
        context.stroke(axes, with: .color(.secondary), lineWidth: 1)
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
}
