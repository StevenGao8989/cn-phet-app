import SwiftUI

struct WaveMotionSimView: View {
    @State private var time: Double = 0
    @State private var isAnimating = false
    @State private var amplitude: Double = 30 // 振幅 (像素)
    @State private var frequency: Double = 1 // 频率 (Hz)
    @State private var wavelength: Double = 200 // 波长 (像素)
    @State private var waveSpeed: Double = 100 // 波速 (像素/秒)
    
    private var angularFrequency: Double {
        2 * .pi * frequency
    }
    
    private var waveNumber: Double {
        2 * .pi / wavelength
    }
    
    private var phaseVelocity: Double {
        angularFrequency / waveNumber
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 标题
            Text("简谐波")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 模拟区域
            ZStack {
                // 背景网格
                SimulatorGridBackground()
                
                // 坐标轴
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 200))
                    path.addLine(to: CGPoint(x: 400, y: 200))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                Path { path in
                    path.move(to: CGPoint(x: 200, y: 0))
                    path.addLine(to: CGPoint(x: 200, y: 400))
                }
                .stroke(Color.gray, lineWidth: 1)
                
                // 简谐波
                WavePath(
                    amplitude: amplitude,
                    waveNumber: waveNumber,
                    angularFrequency: angularFrequency,
                    time: time
                )
                .stroke(Color.blue, lineWidth: 3)
                
                // 波峰标记
                ForEach(0..<max(1, Int(400/wavelength)), id: \.self) { i in
                    let x = Double(i) * wavelength
                    let y = 200 + amplitude * sin(waveNumber * x - angularFrequency * time)
                    
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: x - 200, y: y - 200)
                        .opacity(isAnimating ? 1 : 0)
                }
                
                // 波谷标记
                ForEach(0..<max(1, Int(400/wavelength)), id: \.self) { i in
                    let x = Double(i) * wavelength + wavelength / 2
                    let y = 200 + amplitude * sin(waveNumber * x - angularFrequency * time)
                    
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .offset(x: x - 200, y: y - 200)
                        .opacity(isAnimating ? 1 : 0)
                }
                
                // 相位标记
                Circle()
                    .fill(Color.orange)
                    .frame(width: 12, height: 12)
                    .offset(x: 100 - 200, y: 200 + amplitude * sin(waveNumber * 100 - angularFrequency * time) - 200)
                    .opacity(isAnimating ? 1 : 0)
                
                // 波长标记
                Path { path in
                    path.move(to: CGPoint(x: 50, y: 50))
                    path.addLine(to: CGPoint(x: 50 + wavelength, y: 50))
                }
                .stroke(Color.purple, lineWidth: 2)
                .opacity(isAnimating ? 1 : 0)
                
                // 波长数值
                Text("λ = \(Int(wavelength)) px")
                    .font(.caption)
                    .foregroundColor(.purple)
                    .offset(x: 50 + wavelength/2 - 200, y: 30 - 200)
                    .opacity(isAnimating ? 1 : 0)
            }
            .frame(height: 400)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            // 控制面板
            VStack(spacing: 16) {
                // 振幅控制
                HStack {
                    Text("振幅:")
                        .font(.headline)
                    Slider(value: $amplitude, in: 20...50, step: 5)
                    Text("\(Int(amplitude)) px")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 频率控制
                HStack {
                    Text("频率:")
                        .font(.headline)
                    Slider(value: $frequency, in: 0.5...3, step: 0.1)
                    Text("\(String(format: "%.1f", frequency)) Hz")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 波长控制
                HStack {
                    Text("波长:")
                        .font(.headline)
                    Slider(value: $wavelength, in: 100...300, step: 20)
                    Text("\(Int(wavelength)) px")
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
                Text("波动参数:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Text("振幅: \(Int(amplitude)) px")
                    Spacer()
                    Text("频率: \(String(format: "%.2f", frequency)) Hz")
                }
                
                HStack {
                    Text("波长: \(Int(wavelength)) px")
                    Spacer()
                    Text("波速: \(String(format: "%.1f", phaseVelocity)) px/s")
                }
                
                HStack {
                    Text("角频率: \(String(format: "%.2f", angularFrequency)) rad/s")
                    Spacer()
                    Text("当前时间: \(String(format: "%.2f", time)) s")
                }
                
                HStack {
                    Text("周期: \(String(format: "%.2f", 1/frequency)) s")
                    Spacer()
                    Text("波数: \(String(format: "%.3f", waveNumber)) rad/px")
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
                
                Text("• 简谐波：y(x,t) = A sin(kx - ωt + φ)")
                Text("• 波数：k = 2π/λ (λ为波长)")
                Text("• 角频率：ω = 2πf (f为频率)")
                Text("• 波速：v = λf = ω/k")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("简谐波")
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { _ in
            if isAnimating {
                time += 0.05
            }
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        time = 0
    }
    
    private func stopAnimation() {
        isAnimating = false
    }
    
    private func resetAnimation() {
        isAnimating = false
        time = 0
    }
}

// 波形路径
struct WavePath: Shape {
    let amplitude: Double
    let waveNumber: Double
    let angularFrequency: Double
    let time: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 200))
        
        for x in stride(from: 0, through: 400, by: 2) {
            let xDouble = Double(x)
            let y = 200 + amplitude * sin(waveNumber * xDouble - angularFrequency * time)
            path.addLine(to: CGPoint(x: xDouble, y: y))
        }
        
        return path
    }
}

#Preview {
    NavigationView {
        WaveMotionSimView()
    }
}
