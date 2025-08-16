//
//  FreefallSimView.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation
import SwiftUI

struct FreefallSimView: View {
    let title: String

    // 添加明确的公共初始化器
    init(title: String) {
        self.title = title
    }

    @State private var H: Double = 20.0     // 初始高度 m
    @State private var g: Double = 9.8      // m/s²
    @State private var playing = false
    @State private var t: Double = 0
    @State private var timer: Timer?

    private var tTotal: Double { max(0.0001, sqrt(2.0 * H / g)) }
    private var y: Double { max(0.0, H - 0.5 * g * t * t) } // 距地高度
    private var v: Double { -g * t }                        // 速度（向下为负）

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                Canvas { context, size in
                    let margin: CGFloat = 28
                    let drawable = CGSize(width: size.width - margin*2, height: size.height - margin*2)
                    let scaleY = drawable.height / max(H * 1.1, 1)

                    // 轴线与地面
                    var axes = Path()
                    // y 轴（左侧）
                    axes.move(to: CGPoint(x: margin, y: margin))
                    axes.addLine(to: CGPoint(x: margin, y: size.height - margin))
                    // 地面
                    axes.move(to: CGPoint(x: margin, y: size.height - margin))
                    axes.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
                    context.stroke(axes, with: .color(.secondary), lineWidth: 1)

                    // 射程线：标出起始高度
                    let y0 = size.height - margin - CGFloat(H) * scaleY
                    context.stroke(Path { p in
                        p.move(to: CGPoint(x: margin, y: y0))
                        p.addLine(to: CGPoint(x: size.width - margin, y: y0))
                    }, with: .color(.gray.opacity(0.5)), style: StrokeStyle(dash: [4,4]))

                    // 小球当前位置
                    let cy = size.height - margin - CGFloat(y) * scaleY
                    let cx = margin + drawable.width * 0.5
                    let ball = Path(ellipseIn: CGRect(x: cx-8, y: cy-8, width: 16, height: 16))
                    context.fill(ball, with: .color(.accentColor))

                    // 文本
                    let info = "t落≈\(String(format: "%.2f", tTotal))s  高度≈\(String(format: "%.2f", y))m  速度≈\(String(format: "%.2f", v))m/s"
                    context.draw(Text(info).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 8), anchor: .topLeading)
                }
            }
            .frame(height: 360)
            .padding(.bottom, 8)

            VStack(spacing: 12) {
                HStack { Text("H 初始高度"); Spacer(); Text("\(Int(H)) m") }
                Slider(value: $H, in: 5...80, step: 1) { _ in resetIfNeeded() }

                HStack { Text("g 重力加速度"); Spacer(); Text(String(format: "%.1f m/s²", g)) }
                Slider(value: $g, in: 3.0...19.6, step: 0.1) { _ in resetIfNeeded() }

                HStack(spacing: 12) {
                    Button(playing ? "暂停" : "播放") {
                        playing.toggle()
                        playing ? start() : stop()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("重置") { stop(); t = 0; playing = false }
                        .buttonStyle(.bordered)

                    Spacer()
                }.padding(.top, 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .navigationTitle(title)
        .onDisappear { stop() }
    }

    private func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { _ in
            t += 1/60.0
            if t >= tTotal { t = tTotal; stop(); playing = false }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
    private func stop() { timer?.invalidate(); timer = nil }
    private func resetIfNeeded() { if playing { t = 0 } }
}
