//
//  LensSimView.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation
import SwiftUI

struct LensSimView: View {
    let title: String

    // 单位：cm（画布内做线性比例缩放）
    @State private var f: Double = 8       // 焦距，凸透镜 f>0（可改负值看凹透镜）
    @State private var u: Double = 20      // 物距（物在左侧）
    @State private var hObj: Double = 3    // 物高

    var v: Double? {
        // 1/f = 1/u + 1/v  ->  v = 1 / (1/f - 1/u)
        let denom = (1.0 / f) - (1.0 / u)
        if denom == 0 { return nil }
        return 1.0 / denom
    }
    var m: Double? { guard let v else { return nil }; return -v / u }
    var hImg: Double? { guard let m else { return nil }; return m * hObj }
    var isVirtual: Bool { (v ?? 0) < 0 } // v<0 在物方为虚像

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                Canvas { context, size in
                    let margin: CGFloat = 24
                    let W = size.width - margin*2
                    let H = size.height - margin*2

                    // 坐标：主光轴在中线，透镜位于 x=0
                    // 将 [-Umax, +Vmax] 压缩到画布宽，简化处理：按“最大距离”的 1.2 倍来定比例
                    let uMax: Double = max(10, u*1.2, abs(v ?? u)*1.2, abs(f)*2.0)
                    let scaleX = W / CGFloat(uMax * 2.0) // 左右各 uMax
                    let scaleY = H /  (CGFloat(max(abs(hObj), abs(hImg ?? hObj)) * 3.0))

                    func toPoint(x: Double, y: Double) -> CGPoint {
                        // 透镜在画布中心
                        let cx = size.width / 2
                        let cy = size.height / 2
                        return CGPoint(
                            x: cx + CGFloat(x) * scaleX,
                            y: cy - CGFloat(y) * scaleY
                        )
                    }

                    // 轴线
                    var axes = Path()
                    axes.move(to: CGPoint(x: margin, y: size.height/2))
                    axes.addLine(to: CGPoint(x: size.width - margin, y: size.height/2)) // 主光轴
                    context.stroke(axes, with: .color(.secondary), lineWidth: 1)

                    // 透镜（竖直线+椭圆表示）
                    let lensX = size.width / 2
                    var lens = Path()
                    lens.move(to: CGPoint(x: lensX, y: margin))
                    lens.addLine(to: CGPoint(x: lensX, y: size.height - margin))
                    context.stroke(lens, with: .color(.blue), lineWidth: 2)

                    // 焦点 F、F'
                    let F  = toPoint(x:  f, y: 0)
                    let Fp = toPoint(x: -f, y: 0)
                    context.fill(Path(ellipseIn: CGRect(x: F.x-3, y: F.y-3, width: 6, height: 6)), with: .color(.orange))
                    context.fill(Path(ellipseIn: CGRect(x: Fp.x-3, y: Fp.y-3, width: 6, height: 6)), with: .color(.orange))

                    // 物体（左侧 x=-u），用箭头
                    let objBase = toPoint(x: -u, y: 0)
                    let objTop  = toPoint(x: -u, y: hObj)
                    drawArrow(context: &context, from: objBase, to: objTop, color: .green)

                    // 成像
                    if let v, let hImg {
                        let imgBase = toPoint(x: v, y: 0)
                        let imgTop  = toPoint(x: v, y: hImg)
                        drawArrow(context: &context, from: imgBase, to: imgTop, color: isVirtual ? .gray : .red, dashed: isVirtual)

                        // 三条主光线（顶端）：
                        // 1) 平行主光轴 → 过焦点
                        var ray1 = Path()
                        let top = objTop
                        ray1.move(to: top)
                        // 到透镜
                        ray1.addLine(to: CGPoint(x: lensX, y: top.y))
                        // 出射：经过焦点 (右侧 F) 或延长线经过左焦点（虚像）
                        if !isVirtual {
                            ray1.addLine(to: F) // 真实折射朝 F
                        } else {
                            // 画出射虚线 + 延长线指向左焦点
                            var out = Path()
                            out.move(to: CGPoint(x: lensX, y: top.y))
                            out.addLine(to: toPoint(x: uMax, y: hImg)) // 任意延长
                            context.stroke(out, with: .color(.gray), style: StrokeStyle(lineWidth: 1, dash: [5,5]))
                            // 反向虚线回到 F'
                            var back = Path()
                            back.move(to: CGPoint(x: lensX, y: top.y))
                            back.addLine(to: Fp)
                            context.stroke(back, with: .color(.gray), style: StrokeStyle(lineWidth: 1, dash: [5,5]))
                        }
                        context.stroke(ray1, with: .color(.green))

                        // 2) 过光心（不偏折）
                        var ray2 = Path()
                        ray2.move(to: objTop)
                        ray2.addLine(to: CGPoint(x: lensX, y: objTop.y + (lensX - objTop.x) * ( (imgTop.y - objTop.y) / (toPoint(x: v, y: hImg).x - objTop.x) )))
                        context.stroke(ray2, with: .color(.green))

                        // 3) 过近焦点 → 出射平行主光轴
                        var ray3 = Path()
                        ray3.move(to: objTop)
                        // 朝近焦点 F'（左侧），到透镜位置
                        let dirToFp = CGPoint(x: Fp.x - objTop.x, y: Fp.y - objTop.y)
                        let tLens = (lensX - objTop.x) / (dirToFp.x == 0 ? 1 : dirToFp.x)
                        let hit = CGPoint(x: objTop.x + dirToFp.x * tLens,
                                          y: objTop.y + dirToFp.y * tLens)
                        ray3.addLine(to: hit)
                        // 出射平行
                        var out3 = Path()
                        out3.move(to: hit)
                        out3.addLine(to: CGPoint(x: size.width - margin, y: hit.y))
                        context.stroke(ray3, with: .color(.green))
                        context.stroke(out3, with: .color(.green))

                        // 文本
                        let kind = isVirtual ? "虚像" : "实像"
                        let info = "1/f=1/u+1/v  →  v=\(String(format: "%.2f", v))cm  m=\(String(format: "%.2f", m ?? 0))  （\(kind)）"
                        context.draw(Text(info).font(.footnote), at: CGPoint(x: margin + 6, y: margin + 8), anchor: .topLeading)
                    } else {
                        context.draw(Text("物距接近焦距，v 不存在（像在无穷远）").font(.footnote), at: CGPoint(x: margin + 6, y: margin + 8), anchor: .topLeading)
                    }
                }
            }
            .frame(height: 360)
            .padding(.bottom, 8)

            VStack(spacing: 12) {
                HStack { Text("f 焦距"); Spacer(); Text("\(String(format: "%.1f", f)) cm") }
                Slider(value: $f, in: -12...20, step: 0.5)

                HStack { Text("u 物距"); Spacer(); Text("\(String(format: "%.1f", u)) cm") }
                Slider(value: $u, in: 6...60, step: 0.5)

                HStack { Text("物高"); Spacer(); Text("\(String(format: "%.1f", hObj)) cm") }
                Slider(value: $hObj, in: 1...6, step: 0.5)
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .navigationTitle(title)
    }

    private func drawArrow(context: inout GraphicsContext, from: CGPoint, to: CGPoint, color: Color, dashed: Bool = false) {
        var line = Path()
        line.move(to: from); line.addLine(to: to)
        let style = StrokeStyle(lineWidth: 2, lineCap: .round, dash: dashed ? [5,5] : [])
        context.stroke(line, with: .color(color), style: style)
        // 箭头
        let v = CGVector(dx: to.x - from.x, dy: to.y - from.y)
        let len = max(1, hypot(v.dx, v.dy))
        let ux = v.dx / len, uy = v.dy / len
        let left = CGPoint(x: to.x - 10*ux + 6*uy, y: to.y - 10*uy - 6*ux)
        let right = CGPoint(x: to.x - 10*ux - 6*uy, y: to.y - 10*uy + 6*ux)
        var head = Path(); head.move(to: to); head.addLine(to: left); head.move(to: to); head.addLine(to: right)
        context.stroke(head, with: .color(color), style: style)
    }
}
