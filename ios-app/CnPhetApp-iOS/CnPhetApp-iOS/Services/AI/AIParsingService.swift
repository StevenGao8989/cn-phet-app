
import Foundation

class AIParsingService {
    
    /// 模拟 AI 调用，这里返回固定的 DSL 示例
    func parseQuestionToDSL(question: String, completion: @escaping (String?) -> Void) {
        // TODO: 这里未来接入 ChatGPT / 通义千问
        // 调用 API → prompt = question → 输出 DSL 字符串
        
        // 先用 mock 数据方便调试
        let mockDSL = """
        subject: physics
        objects:
          - id: particle1
            type: particle
            mass: 1.0
            radius: 0.05
            initial:
              position: {x: 0, y: 1}
              velocity: {x: 0, y: 0}
        forces:
          - type: gravity
            g: 9.8
            target: [particle1]
        motions:
          - target: particle1
            type: free_fall
            params:
              g: 9.8
        """
        completion(mockDSL)
    }
}
