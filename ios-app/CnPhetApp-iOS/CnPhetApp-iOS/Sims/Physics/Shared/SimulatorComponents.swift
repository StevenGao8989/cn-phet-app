import SwiftUI

// MARK: - 共享的模拟器组件

// 箭头视图
struct SimulatorArrowView: View {
    let start: CGPoint
    let end: CGPoint
    let color: Color
    let label: String
    
    var body: some View {
        ZStack {
            // 箭头线
            Path { path in
                path.move(to: start)
                path.addLine(to: end)
            }
            .stroke(color, lineWidth: 2)
            
            // 箭头头部
            Path { path in
                let angle = atan2(end.y - start.y, end.x - start.x)
                let arrowLength: CGFloat = 8
                let arrowAngle: CGFloat = .pi / 6
                
                let point1 = CGPoint(
                    x: end.x - arrowLength * cos(angle - arrowAngle),
                    y: end.y - arrowLength * sin(angle - arrowAngle)
                )
                let point2 = CGPoint(
                    x: end.x - arrowLength * cos(angle + arrowAngle),
                    y: end.y - arrowLength * sin(angle + arrowAngle)
                )
                
                path.move(to: end)
                path.addLine(to: point1)
                path.move(to: end)
                path.addLine(to: point2)
            }
            .stroke(color, lineWidth: 2)
            
            // 标签
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
                .position(
                    x: (start.x + end.x) / 2,
                    y: (start.y + end.y) / 2 - 15
                )
        }
    }
}

// 网格背景
struct SimulatorGridBackground: View {
    var body: some View {
        Canvas { context, size in
            let gridSize: CGFloat = 20
            
            // 绘制垂直线
            for x in stride(from: 0, through: size.width, by: gridSize) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.gray.opacity(0.3)), lineWidth: 0.5)
            }
            
            // 绘制水平线
            for y in stride(from: 0, through: size.height, by: gridSize) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.gray.opacity(0.3)), lineWidth: 0.5)
            }
        }
    }
}
