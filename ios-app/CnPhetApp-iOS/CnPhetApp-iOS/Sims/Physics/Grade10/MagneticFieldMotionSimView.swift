import SwiftUI

struct MagneticFieldMotionSimView: View {
    @State private var magneticField: Double = 0.1
    @State private var particleCharge: Double = 1.6e-19
    @State private var particleMass: Double = 9.1e-31
    @State private var initialVelocity: Double = 1000000.0
    @State private var isAnimating = false
    @State private var time: Double = 0
    
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("磁场中带电粒子运动")
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                // 背景网格
                SimulatorGridBackground()
                
                // 磁场指示
                MagneticFieldIndicators(fieldStrength: magneticField)
                
                // 带电粒子轨迹
                ParticleTrajectory(
                    magneticField: magneticField,
                    charge: particleCharge,
                    mass: particleMass,
                    velocity: initialVelocity,
                    time: time,
                    isAnimating: isAnimating
                )
                
                // 带电粒子
                MagneticParticle(
                    magneticField: magneticField,
                    charge: particleCharge,
                    mass: particleMass,
                    velocity: initialVelocity,
                    time: time,
                    isAnimating: isAnimating
                )
                
                // 洛伦兹力向量
                if isAnimating {
                    LorentzForceVector(
                        magneticField: magneticField,
                        charge: particleCharge,
                        velocity: initialVelocity,
                        time: time
                    )
                }
            }
            .frame(height: 300)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            
            VStack(spacing: 16) {
                // 磁感应强度控制
                VStack(alignment: .leading, spacing: 8) {
                    Text("磁感应强度: \(String(format: "%.2f", magneticField)) T")
                        .font(.headline)
                    Slider(value: $magneticField, in: 0.05...0.3, step: 0.01)
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
                MagneticPhysicsInfo(
                    magneticField: magneticField,
                    charge: particleCharge,
                    mass: particleMass,
                    velocity: initialVelocity,
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

// 磁场指示器
struct MagneticFieldIndicators: View {
    let fieldStrength: Double
    
    var body: some View {
        Canvas { context, size in
            let rows = 6
            let cols = 8
            let spacingX = size.width / Double(cols + 1)
            let spacingY = size.height / Double(rows + 1)
            
            for i in 1...rows {
                for j in 1...cols {
                    let x = spacingX * Double(j)
                    let y = spacingY * Double(i)
                    
                    // 磁场进入纸面的符号 (×)
                    context.draw(
                        Text("×")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.purple),
                        at: CGPoint(x: x, y: y)
                    )
                }
            }
        }
    }
}

// 粒子轨迹
struct ParticleTrajectory: View {
    let magneticField: Double
    let charge: Double
    let mass: Double
    let velocity: Double
    let time: Double
    let isAnimating: Bool
    
    private var radius: Double {
        guard magneticField != 0 && charge != 0 else { return 100 }
        return abs(mass * velocity / (charge * magneticField)) * 1e8
    }
    
    var body: some View {
        if isAnimating {
            Circle()
                .stroke(
                    charge > 0 ? Color.red.opacity(0.3) : Color.blue.opacity(0.3),
                    lineWidth: 2
                )
                .frame(width: min(radius * 2, 200), height: min(radius * 2, 200))
                .position(x: 200, y: 150)
        }
    }
}

// 带电粒子
struct MagneticParticle: View {
    let magneticField: Double
    let charge: Double
    let mass: Double
    let velocity: Double
    let time: Double
    let isAnimating: Bool
    
    private var position: CGPoint {
        let centerX: CGFloat = 200
        let centerY: CGFloat = 150
        
        if !isAnimating {
            return CGPoint(x: centerX + 50, y: centerY)
        }
        
        // 计算圆周运动
        guard magneticField != 0 && charge != 0 else {
            return CGPoint(x: centerX + 50, y: centerY)
        }
        
        let radius = abs(mass * velocity / (charge * magneticField)) * 1e8
        let limitedRadius = min(radius, 100)
        
        // 角频率
        let omega = abs(charge * magneticField / mass)
        let angle = omega * time
        
        // 根据电荷正负决定旋转方向
        let direction: Double = charge > 0 ? 1 : -1
        
        let x = centerX + limitedRadius * cos(direction * angle)
        let y = centerY + limitedRadius * sin(direction * angle)
        
        return CGPoint(x: x, y: y)
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

// 洛伦兹力向量
struct LorentzForceVector: View {
    let magneticField: Double
    let charge: Double
    let velocity: Double
    let time: Double
    
    private var particlePosition: CGPoint {
        let centerX: CGFloat = 200
        let centerY: CGFloat = 150
        
        guard magneticField != 0 && charge != 0 else {
            return CGPoint(x: centerX + 50, y: centerY)
        }
        
        let radius = abs(9.1e-31 * velocity / (charge * magneticField)) * 1e8
        let limitedRadius = min(radius, 100)
        
        let omega = abs(charge * magneticField / 9.1e-31)
        let angle = omega * time
        
        let direction: Double = charge > 0 ? 1 : -1
        
        let x = centerX + limitedRadius * cos(direction * angle)
        let y = centerY + limitedRadius * sin(direction * angle)
        
        return CGPoint(x: x, y: y)
    }
    
    private var forceDirection: CGPoint {
        let omega = abs(charge * magneticField / 9.1e-31)
        let angle = omega * time
        let direction: Double = charge > 0 ? 1 : -1
        
        // 洛伦兹力垂直于速度方向，指向圆心
        let forceAngle = direction * angle - .pi / 2
        let forceX = particlePosition.x + 30 * cos(forceAngle)
        let forceY = particlePosition.y + 30 * sin(forceAngle)
        
        return CGPoint(x: forceX, y: forceY)
    }
    
    var body: some View {
        SimulatorArrowView(
            start: particlePosition,
            end: forceDirection,
            color: .green,
            label: "F"
        )
    }
}

// 物理信息显示
struct MagneticPhysicsInfo: View {
    let magneticField: Double
    let charge: Double
    let mass: Double
    let velocity: Double
    let time: Double
    
    private var lorentzForce: Double {
        abs(charge * velocity * magneticField)
    }
    
    private var radius: Double {
        guard magneticField != 0 && charge != 0 else { return 0 }
        return abs(mass * velocity / (charge * magneticField))
    }
    
    private var period: Double {
        guard magneticField != 0 && charge != 0 else { return 0 }
        return 2 * .pi * mass / (abs(charge) * magneticField)
    }
    
    private var frequency: Double {
        guard period != 0 else { return 0 }
        return 1 / period
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("物理参数")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Text("洛伦兹力:")
                Spacer()
                Text("\(String(format: "%.2e", lorentzForce)) N")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("轨道半径:")
                Spacer()
                Text("\(String(format: "%.2e", radius)) m")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("周期:")
                Spacer()
                Text("\(String(format: "%.2e", period)) s")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("频率:")
                Spacer()
                Text("\(String(format: "%.2e", frequency)) Hz")
                    .fontWeight(.medium)
            }
            
            HStack {
                Text("运动方向:")
                Spacer()
                Text(charge > 0 ? "顺时针" : "逆时针")
                    .fontWeight(.medium)
                    .foregroundColor(charge > 0 ? .red : .blue)
            }
        }
        .font(.subheadline)
    }
}



#Preview {
    MagneticFieldMotionSimView()
}
