import SwiftUI

struct FrictionSlidingSimView: View {
    @State private var angle: Double = 30.0
    @State private var mass: Double = 1.0
    @State private var frictionCoefficient: Double = 0.3
    @State private var isAnimating = false
    @State private var time: Double = 0
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("摩擦滑动模拟")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                // 背景网格
                SimulatorGridBackground()
                
                // 斜面
                InclinedPlane(angle: angle)
                    .stroke(Color.gray, lineWidth: 3)
                
                // 滑动物体
                SlidingObject(
                    angle: angle,
                    mass: mass,
                    frictionCoefficient: frictionCoefficient,
                    time: time,
                    isAnimating: isAnimating
                )
                
                // 力向量
                if isAnimating {
                    ForceVectors(
                        angle: angle,
                        mass: mass,
                        frictionCoefficient: frictionCoefficient
                    )
                }
            }
            .frame(height: 300)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            
            VStack(spacing: 16) {
                // 角度控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("斜面角度: \(String(format: "%.1f", angle))°")
                        .font(.headline)
                    Slider(value: $angle, in: 5...60, step: 1)
                        .disabled(isAnimating)
                }
                
                // 质量控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("物体质量: \(String(format: "%.1f", mass)) kg")
                        .font(.headline)
                    Slider(value: $mass, in: 0.5...3.0, step: 0.1)
                        .disabled(isAnimating)
                }
                
                // 摩擦系数控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("摩擦系数: \(String(format: "%.2f", frictionCoefficient))")
                        .font(.headline)
                    Slider(value: $frictionCoefficient, in: 0.1...0.8, step: 0.05)
                        .disabled(isAnimating)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            HStack(spacing: 20) {
                Button(action: {
                    isAnimating.toggle()
                    if !isAnimating {
                        time = 0
                    }
                }) {
                    HStack {
                        Image(systemName: isAnimating ? "pause.fill" : "play.fill")
                        Text(isAnimating ? "暂停" : "开始")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(isAnimating ? Color.orange : Color.green)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    isAnimating = false
                    time = 0
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("重置")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            
            // 物理信息显示
            if isAnimating {
                PhysicsInfo(
                    angle: angle,
                    mass: mass,
                    frictionCoefficient: frictionCoefficient,
                    time: time
                )
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .onReceive(timer) { _ in
            if isAnimating {
                time += 0.05
            }
        }
    }
}

// 斜面
struct InclinedPlane: Shape {
    let angle: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let centerX = rect.width / 2
        let centerY = rect.height / 2
        let length: CGFloat = 200
        
        let startX = centerX - length / 2
        let startY = centerY + 50
        let endX = centerX + length / 2
        let endY = startY - length * tan(angle * .pi / 180)
        
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        
        return path
    }
}

// 滑动物体
struct SlidingObject: View {
    let angle: Double
    let mass: Double
    let frictionCoefficient: Double
    let time: Double
    let isAnimating: Bool
    
    private var position: CGPoint {
        let centerX: CGFloat = 200
        let centerY: CGFloat = 150
        let length: CGFloat = 200
        
        let startX = centerX - length / 2
        let startY = centerY + 50
        
        if !isAnimating {
            return CGPoint(x: startX + 20, y: startY - 20 * tan(angle * .pi / 180))
        }
        
        // 计算滑动位置
        let g: Double = 9.81
        let acceleration = g * sin(angle * .pi / 180) - g * cos(angle * .pi / 180) * frictionCoefficient
        
        let distance = 0.5 * acceleration * time * time
        let maxDistance = length * 0.8
        
        let actualDistance = min(distance, maxDistance)
        let x = startX + 20 + actualDistance * cos(angle * .pi / 180)
        let y = startY - 20 * tan(angle * .pi / 180) - actualDistance * sin(angle * .pi / 180)
        
        return CGPoint(x: x, y: y)
    }
    
    var body: some View {
        Circle()
            .fill(Color.red)
            .frame(width: 20, height: 20)
            .position(position)
            .shadow(radius: 3)
    }
}

// 力向量
struct ForceVectors: View {
    let angle: Double
    let mass: Double
    let frictionCoefficient: Double
    
    private var centerPoint: CGPoint {
        CGPoint(x: 200, y: 150)
    }
    
    var body: some View {
        ZStack {
            // 重力向量
            SimulatorArrowView(
                start: centerPoint,
                end: CGPoint(
                    x: centerPoint.x,
                    y: centerPoint.y + 40
                ),
                color: .blue,
                label: "G"
            )
            
            // 支持力向量
            SimulatorArrowView(
                start: centerPoint,
                end: CGPoint(
                    x: centerPoint.x + 40 * sin(angle * .pi / 180),
                    y: centerPoint.y - 40 * cos(angle * .pi / 180)
                ),
                color: .green,
                label: "N"
            )
            
            // 摩擦力向量
            SimulatorArrowView(
                start: centerPoint,
                end: CGPoint(
                    x: centerPoint.x - 30 * cos(angle * .pi / 180),
                    y: centerPoint.y - 30 * sin(angle * .pi / 180)
                ),
                color: .red,
                label: "f"
            )
        }
    }
}

// 物理信息显示
struct PhysicsInfo: View {
    let angle: Double
    let mass: Double
    let frictionCoefficient: Double
    let time: Double
    
    private var acceleration: Double {
        let g: Double = 9.81
        return g * sin(angle * .pi / 180) - g * cos(angle * .pi / 180) * frictionCoefficient
    }
    
    private var velocity: Double {
        acceleration * time
    }
    
    private var distance: Double {
        0.5 * acceleration * time * time
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("物理参数")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Text("加速度:")
                Spacer()
                Text("\(String(format: "%.2f", acceleration)) m/s²")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("当前速度:")
                Spacer()
                Text("\(String(format: "%.2f", velocity)) m/s")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("滑动距离:")
                Spacer()
                Text("\(String(format: "%.2f", distance)) m")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("重力分量:")
                Spacer()
                Text("\(String(format: "%.2f", 9.81 * sin(angle * .pi / 180))) m/s²")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("摩擦力:")
                Spacer()
                Text("\(String(format: "%.2f", 9.81 * cos(angle * .pi / 180) * frictionCoefficient)) m/s²")
                    .fontWeight(.medium)
            }
        }
        .font(.subheadline)
    }
}



#Preview {
    FrictionSlidingSimView()
}
