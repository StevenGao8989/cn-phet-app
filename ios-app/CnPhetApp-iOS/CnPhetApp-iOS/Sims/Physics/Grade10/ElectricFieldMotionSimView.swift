import SwiftUI

struct ElectricFieldMotionSimView: View {
    @State private var electricField: Double = 1000.0
    @State private var particleCharge: Double = 1.6e-19
    @State private var particleMass: Double = 9.1e-31
    @State private var initialVelocity: Double = 1000000.0
    @State private var isAnimating = false
    @State private var time: Double = 0
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("电场中带电粒子运动")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                // 背景网格
                SimulatorGridBackground()
                
                // 电场线
                ElectricFieldLines(fieldStrength: electricField)
                
                // 带电粒子
                ChargedParticle(
                    electricField: electricField,
                    charge: particleCharge,
                    mass: particleMass,
                    initialVelocity: initialVelocity,
                    time: time,
                    isAnimating: isAnimating
                )
                
                // 电场力向量
                if isAnimating {
                    ElectricForceVector(
                        electricField: electricField,
                        charge: particleCharge
                    )
                }
            }
            .frame(height: 300)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            
            VStack(spacing: 16) {
                // 电场强度控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("电场强度: \(String(format: "%.0f", electricField)) N/C")
                        .font(.headline)
                    Slider(value: $electricField, in: 500...3000, step: 100)
                        .disabled(isAnimating)
                }
                
                // 粒子电荷控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("粒子电荷: \(particleCharge > 0 ? "+" : "")\(String(format: "%.1e", particleCharge)) C")
                        .font(.headline)
                    Slider(value: $particleCharge, in: -3.2e-19...3.2e-19, step: 1.6e-19)
                        .disabled(isAnimating)
                }
                
                // 初始速度控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("初始速度: \(String(format: "%.1e", initialVelocity)) m/s")
                        .font(.headline)
                    Slider(value: $initialVelocity, in: 500000...2000000, step: 100000)
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
                ElectricPhysicsInfo(
                    electricField: electricField,
                    charge: particleCharge,
                    mass: particleMass,
                    initialVelocity: initialVelocity,
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

// 电场线
struct ElectricFieldLines: View {
    let fieldStrength: Double
    
    var body: some View {
        Canvas { context, size in
            let lineCount = 8
            let spacing = size.width / Double(lineCount + 1)
            
            for i in 1...lineCount {
                let x = spacing * Double(i)
                
                // 电场线（垂直向下）
                var path = Path()
                path.move(to: CGPoint(x: x, y: 20))
                path.addLine(to: CGPoint(x: x, y: size.height - 20))
                
                context.stroke(path, with: .color(.blue.opacity(0.6)), lineWidth: 2)
                
                // 箭头指示方向
                let arrowY = size.height / 2
                var arrowPath = Path()
                arrowPath.move(to: CGPoint(x: x, y: arrowY))
                arrowPath.addLine(to: CGPoint(x: x - 5, y: arrowY - 8))
                arrowPath.move(to: CGPoint(x: x, y: arrowY))
                arrowPath.addLine(to: CGPoint(x: x + 5, y: arrowY - 8))
                
                context.stroke(arrowPath, with: .color(.blue.opacity(0.8)), lineWidth: 2)
            }
        }
    }
}

// 带电粒子
struct ChargedParticle: View {
    let electricField: Double
    let charge: Double
    let mass: Double
    let initialVelocity: Double
    let time: Double
    let isAnimating: Bool
    
    private var position: CGPoint {
        let centerX: CGFloat = 200
        let centerY: CGFloat = 50
        
        if !isAnimating {
            return CGPoint(x: centerX, y: centerY)
        }
        
        // 计算在电场中的运动
        let force = charge * electricField
        let acceleration = force / mass
        
        // 水平位移（匀速）
        let x = centerX + initialVelocity * time * 0.0001
        
        // 垂直位移（匀加速）
        let y = centerY + 0.5 * acceleration * time * time * 1e15
        
        // 限制在屏幕范围内
        let limitedX = min(max(x, 20), 380)
        let limitedY = min(max(y, 20), 280)
        
        return CGPoint(x: limitedX, y: limitedY)
    }
    
    var body: some View {
        Circle()
            .fill(charge > 0 ? Color.red : Color.blue)
            .frame(width: 16, height: 16)
            .position(position)
            .shadow(radius: 3)
            .overlay(
                Text(charge > 0 ? "+" : "−")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .position(position)
            )
    }
}

// 电场力向量
struct ElectricForceVector: View {
    let electricField: Double
    let charge: Double
    
    private var centerPoint: CGPoint {
        CGPoint(x: 200, y: 150)
    }
    
    private var forceDirection: Double {
        charge > 0 ? 1.0 : -1.0
    }
    
    var body: some View {
        SimulatorArrowView(
            start: centerPoint,
            end: CGPoint(
                x: centerPoint.x,
                y: centerPoint.y + 40 * forceDirection
            ),
            color: charge > 0 ? .red : .blue,
            label: "F"
        )
    }
}

// 物理信息显示
struct ElectricPhysicsInfo: View {
    let electricField: Double
    let charge: Double
    let mass: Double
    let initialVelocity: Double
    let time: Double
    
    private var force: Double {
        charge * electricField
    }
    
    private var acceleration: Double {
        force / mass
    }
    
    private var verticalVelocity: Double {
        acceleration * time
    }
    
    private var totalVelocity: Double {
        sqrt(initialVelocity * initialVelocity + verticalVelocity * verticalVelocity)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("物理参数")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Text("电场力:")
                Spacer()
                Text("\(String(format: "%.2e", force)) N")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("加速度:")
                Spacer()
                Text("\(String(format: "%.2e", acceleration)) m/s²")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("垂直速度:")
                Spacer()
                Text("\(String(format: "%.2e", verticalVelocity)) m/s")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("总速度:")
                Spacer()
                Text("\(String(format: "%.2e", totalVelocity)) m/s")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("运动轨迹:")
                Spacer()
                Text(charge > 0 ? "向下偏转" : "向上偏转")
                    .fontWeight(.medium)
                    .foregroundColor(charge > 0 ? .red : .blue)
            }
        }
        .font(.subheadline)
    }
}



#Preview {
    ElectricFieldMotionSimView()
}
