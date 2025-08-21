import SwiftUI

struct UniformLinearMotionSimView: View {
    @State private var animationProgress: CGFloat = 0
    @State private var isAnimating = false
    @State private var velocity: Double = 100 // 速度 (像素/秒)
    @State private var distance: Double = 300 // 距离 (像素)
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("匀速直线运动")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 模拟区域
            ZStack {
                // 背景网格
                SimulatorGridBackground()
                
                // 运动轨迹线
                Path { path in
                    path.move(to: CGPoint(x: 50, y: 200))
                    path.addLine(to: CGPoint(x: 350, y: 200))
                }
                .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                
                // 运动小球
                Circle()
                    .fill(Color.red)
                    .frame(width: 20, height: 20)
                    .offset(x: 50 + animationProgress * distance, y: 0)
                    .animation(.linear(duration: distance / velocity), value: animationProgress)
                
                // 起始点标记
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                    .offset(x: 50, y: 200)
                
                // 终点标记
                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)
                    .offset(x: 350, y: 200)
                
                // 速度向量
                SimulatorArrowView(
                    start: CGPoint(x: 50 + animationProgress * distance, y: 200),
                    end: CGPoint(x: 50 + animationProgress * distance + 30, y: 200),
                    color: .blue,
                    label: "v"
                )
                .opacity(isAnimating ? 1 : 0)
            }
            .frame(height: 300)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // 控制面板
            VStack(spacing: 16) {
                // 速度控制
                HStack {
                    Text("速度:")
                        .font(.headline)
                    Slider(value: $velocity, in: 50...200, step: 10)
                    Text("\(Int(velocity)) px/s")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 距离控制
                HStack {
                    Text("距离:")
                        .font(.headline)
                    Slider(value: $distance, in: 200...400, step: 20)
                    Text("\(Int(distance)) px")
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
            
            // 物理信息显示
            VStack(alignment: .leading, spacing: 8) {
                Text("物理原理:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("• 匀速直线运动：物体在直线上以恒定速度运动")
                Text("• 速度大小和方向保持不变")
                Text("• 位移与时间成正比：s = v × t")
                Text("• 加速度为零：a = 0")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("匀速直线运动")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startAnimation() {
        isAnimating = true
        withAnimation(.linear(duration: distance / velocity)) {
            animationProgress = 1.0
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
        withAnimation(.easeInOut(duration: 0.3)) {
            animationProgress = 0
        }
    }
}



#Preview {
    NavigationView {
        UniformLinearMotionSimView()
    }
}
