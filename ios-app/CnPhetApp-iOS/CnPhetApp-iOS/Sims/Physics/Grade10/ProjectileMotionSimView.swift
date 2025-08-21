import SwiftUI

struct ProjectileMotionSimView: View {
    @State private var animationProgress: CGFloat = 0
    @State private var isAnimating = false
    @State private var initialVelocity: Double = 150 // 初速度 (像素/秒)
    @State private var launchAngle: Double = 45 // 发射角度 (度)
    @State private var gravity: Double = 500 // 重力加速度 (像素/秒²)
    @State private var time: Double = 0 // 时间 (秒)
    
    private var radians: Double {
        launchAngle * .pi / 180
    }
    
    private var horizontalVelocity: Double {
        initialVelocity * cos(radians)
    }
    
    private var verticalVelocity: Double {
        initialVelocity * sin(radians)
    }
    
    private var flightTime: Double {
        2 * verticalVelocity / gravity
    }
    
    private var range: Double {
        horizontalVelocity * flightTime
    }
    
    private var maxHeight: Double {
        (verticalVelocity * verticalVelocity) / (2 * gravity)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("抛体运动")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 模拟区域
            ZStack {
                // 背景网格
                SimulatorGridBackground()
                
                // 地面线
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 350))
                    path.addLine(to: CGPoint(x: 400, y: 350))
                }
                .stroke(Color.brown, lineWidth: 3)
                
                // 发射点
                Circle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                    .offset(x: 50, y: 350)
                
                // 运动小球
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .offset(
                        x: 50 + horizontalVelocity * time,
                        y: 350 - (verticalVelocity * time - 0.5 * gravity * time * time)
                    )
                    .opacity(isAnimating ? 1 : 0)
                
                // 轨迹线
                Path { path in
                    path.move(to: CGPoint(x: 50, y: 350))
                    
                    for t in stride(from: 0, through: flightTime, by: 0.05) {
                        let x = 50 + horizontalVelocity * t
                        let y = 350 - (verticalVelocity * t - 0.5 * gravity * t * t)
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                .opacity(isAnimating ? 1 : 0)
                
                // 速度向量
                SimulatorArrowView(
                    start: CGPoint(x: 50, y: 350),
                    end: CGPoint(x: 50 + horizontalVelocity * 0.3, y: 350 - verticalVelocity * 0.3),
                    color: .blue,
                    label: "v"
                )
                .opacity(isAnimating ? 1 : 0)
                
                // 重力向量
                SimulatorArrowView(
                    start: CGPoint(x: 50 + horizontalVelocity * time, y: 350 - (verticalVelocity * time - 0.5 * gravity * time * time)),
                    end: CGPoint(x: 50 + horizontalVelocity * time, y: 350 - (verticalVelocity * time - 0.5 * gravity * time * time) + gravity * 0.1),
                    color: .green,
                    label: "g"
                )
                .opacity(isAnimating ? 1 : 0)
            }
            .frame(height: 400)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // 控制面板
            VStack(spacing: 16) {
                // 初速度控制
                HStack {
                    Text("初速度:")
                        .font(.headline)
                    Slider(value: $initialVelocity, in: 100...300, step: 10)
                    Text("\(Int(initialVelocity)) px/s")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 发射角度控制
                HStack {
                    Text("发射角度:")
                        .font(.headline)
                    Slider(value: $launchAngle, in: 0...90, step: 5)
                    Text("\(Int(launchAngle))°")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 重力控制
                HStack {
                    Text("重力加速度:")
                        .font(.headline)
                    Slider(value: $gravity, in: 200...800, step: 50)
                    Text("\(Int(gravity)) px/s²")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 控制按钮
                HStack(spacing: 20) {
                    Button(action: startAnimation) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("开始")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                    .disabled(isAnimating)
                    
                    Button(action: stopAnimation) {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("停止")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                    }
                    .disabled(!isAnimating)
                    
                    Button(action: resetAnimation) {
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
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // 运动参数显示
            VStack(alignment: .leading, spacing: 8) {
                Text("运动参数:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("水平速度: \(String(format: "%.1f", horizontalVelocity)) px/s")
                    Spacer()
                    Text("垂直速度: \(String(format: "%.1f", verticalVelocity)) px/s")
                }
                
                HStack {
                    Text("飞行时间: \(String(format: "%.2f", flightTime)) s")
                    Spacer()
                    Text("射程: \(String(format: "%.1f", range)) px")
                }
                
                HStack {
                    Text("最大高度: \(String(format: "%.1f", maxHeight)) px")
                    Spacer()
                    Text("当前时间: \(String(format: "%.2f", time)) s")
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // 物理信息显示
            VStack(alignment: .leading, spacing: 8) {
                Text("物理原理:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("• 抛体运动：物体在重力作用下的曲线运动")
                Text("• 水平方向：匀速运动 vₓ = v₀cosθ")
                Text("• 垂直方向：匀加速运动 vᵧ = v₀sinθ - gt")
                Text("• 轨迹方程：y = xtanθ - gx²/(2v₀²cos²θ)")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("抛体运动")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { _ in
            if isAnimating {
                time += 0.05
                if time >= flightTime {
                    stopAnimation()
                }
            }
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        time = 0
        withAnimation(.easeInOut(duration: flightTime)) {
            // 动画通过Timer控制
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        withAnimation(.easeInOut(duration: 0.3)) {
            // 保持当前位置
        }
    }
    
    private func resetAnimation() {
        isAnimating = false
        time = 0
        withAnimation(.easeInOut(duration: 0.3)) {
            // 重置位置
        }
    }
}

#Preview {
    NavigationView {
        ProjectileMotionSimView()
    }
}
