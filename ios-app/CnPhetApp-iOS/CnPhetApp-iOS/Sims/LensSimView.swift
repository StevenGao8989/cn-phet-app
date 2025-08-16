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
                    
                    // 添加坐标轴数字标记（不显示刻度线）
                    let majorTickInterval: Double = 5.0 // 主刻度间隔（cm）
                    
                    // 只添加数字标记，不绘制刻度线
                    for tick in stride(from: -uMax, through: uMax, by: majorTickInterval) {
                        if tick != 0 { // 跳过透镜位置（x=0）
                            let tickX = toPoint(x: tick, y: 0).x
                            let tickText = "\(Int(tick))"
                            let textX = tickX - 10 // 估算文本宽度的一半
                            let textY = size.height/2 + 12 // 更贴近坐标轴
                            
                            // 确保文本不超出边界
                            if textX >= margin && textX + 20 <= size.width - margin {
                                context.draw(Text(tickText).font(.caption2).foregroundColor(.secondary), 
                                           at: CGPoint(x: textX, y: textY), anchor: .topLeading)
                            }
                        }
                    }
                    
                    // 在透镜位置（x=0）添加特殊标记
                    let lensTickX = size.width / 2
                    
                    // 在透镜位置添加"0"标记
                    let zeroText = "0"
                    context.draw(Text(zeroText).font(.caption2).foregroundColor(.blue), 
                               at: CGPoint(x: lensTickX - 5, y: size.height/2 + 12), 
                               anchor: .topLeading)
                    
                    // 在焦点位置添加标记
                    let F = toPoint(x: f, y: 0)
                    let Fp = toPoint(x: -f, y: 0)
                    
                    // 在右侧焦点添加"F"标记
                    if f > 0 {
                        let fText = "F"
                        context.draw(Text(fText).font(.caption2).foregroundColor(.orange), 
                                   at: CGPoint(x: F.x - 5, y: F.y - 20), 
                                   anchor: .bottomLeading)
                        
                        // 在右侧焦点添加焦距数值标记
                        let fValueText = "f=\(String(format: "%.1f", f))cm"
                        context.draw(Text(fValueText).font(.caption2).foregroundColor(.orange), 
                                   at: CGPoint(x: F.x - 25, y: F.y + 20), 
                                   anchor: .topLeading)
                    }
                    
                    // 在左侧焦点添加"F'"标记
                    if f > 0 {
                        let fpText = "F'"
                        context.draw(Text(fpText).font(.caption2).foregroundColor(.orange), 
                                   at: CGPoint(x: Fp.x - 10, y: Fp.y - 20), 
                                   anchor: .bottomLeading)
                        
                        // 在左侧焦点添加焦距数值标记
                        let fpValueText = "f=\(String(format: "%.1f", f))cm"
                        context.draw(Text(fpValueText).font(.caption2).foregroundColor(.orange), 
                                   at: CGPoint(x: Fp.x - 25, y: Fp.y + 20), 
                                   anchor: .topLeading)
                    }
                    
                    // 添加垂直方向的数字标记（不显示刻度线）
                    let verticalMajorInterval: Double = 2.0 // 主刻度间隔（cm）
                    let maxHeight = max(abs(hObj), abs(hImg ?? hObj), 6.0) // 确保至少有6cm的显示范围
                    
                    // 只添加数字标记，不绘制刻度线
                    for tick in stride(from: -maxHeight, through: maxHeight, by: verticalMajorInterval) {
                        if tick != 0 { // 跳过中心位置（y=0）
                            let tickY = toPoint(x: 0, y: tick).y
                            let tickText = "\(Int(tick))"
                            let textX = size.width/2 + 12 // 更贴近垂直轴
                            let textY = tickY - 8 // 估算文本高度的一半
                            
                            // 确保文本不超出边界
                            if textY >= margin && textY + 16 <= size.height - margin {
                                context.draw(Text(tickText).font(.caption2).foregroundColor(.secondary), 
                                           at: CGPoint(x: textX, y: textY), anchor: .leading)
                            }
                        }
                    }
                    
                    // 在垂直轴中心添加"0"标记
                    let verticalZeroText = "0"
                    context.draw(Text(verticalZeroText).font(.caption2).foregroundColor(.secondary), 
                               at: CGPoint(x: size.width/2 + 12, y: size.height/2 - 8), 
                               anchor: .leading)

                    // 透镜（竖直线+椭圆表示）
                    let lensX = size.width / 2
                    var lens = Path()
                    lens.move(to: CGPoint(x: lensX, y: margin))
                    lens.addLine(to: CGPoint(x: lensX, y: size.height - margin))
                    context.stroke(lens, with: .color(.blue), lineWidth: 2)

                    // 焦点 F、F'
                    context.fill(Path(ellipseIn: CGRect(x: F.x-3, y: F.y-3, width: 6, height: 6)), with: .color(.orange))
                    context.fill(Path(ellipseIn: CGRect(x: Fp.x-3, y: Fp.y-3, width: 6, height: 6)), with: .color(.orange))

                    // 物体（左侧 x=-u），用箭头
                    let objBase = toPoint(x: -u, y: 0)
                    let objTop  = toPoint(x: -u, y: hObj)
                    drawArrow(context: &context, from: objBase, to: objTop, color: .green)
                    
                    // 在物体位置添加距离和高度标记
                    let objDistanceText = "u=\(String(format: "%.1f", u))cm"
                    let objHeightText = "h=\(String(format: "%.1f", hObj))cm"
                    
                    // 距离标记（在物体下方）
                    context.draw(Text(objDistanceText).font(.caption2).foregroundColor(.green), 
                               at: CGPoint(x: objBase.x - 25, y: objBase.y + 20), 
                               anchor: .top)
                    
                    // 高度标记（在物体右侧）
                    context.draw(Text(objHeightText).font(.caption2).foregroundColor(.green), 
                               at: CGPoint(x: objBase.x + 15, y: objTop.y - 8), 
                               anchor: .leading)

                    // 成像
                    if let v, let hImg {
                        let imgBase = toPoint(x: v, y: 0)
                        let imgTop  = toPoint(x: v, y: hImg)
                        drawArrow(context: &context, from: imgBase, to: imgTop, color: isVirtual ? .gray : .red, dashed: isVirtual)
                        
                        // 在像的位置添加距离和高度标记
                        let imgDistanceText = "v=\(String(format: "%.1f", v))cm"
                        let imgHeightText = "h'=\(String(format: "%.1f", hImg))cm"
                        
                        // 距离标记（在像下方）
                        context.draw(Text(imgDistanceText).font(.caption2).foregroundColor(isVirtual ? .gray : .red), 
                                   at: CGPoint(x: imgBase.x - 25, y: imgBase.y + 20), 
                                   anchor: .top)
                        
                        // 高度标记（在像左侧）
                        context.draw(Text(imgHeightText).font(.caption2).foregroundColor(isVirtual ? .gray : .red), 
                                   at: CGPoint(x: imgBase.x - 15, y: imgTop.y - 8), 
                                   anchor: .trailing)

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
