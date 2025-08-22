//
//  PhysicsDSLParser.swift
//  CnPhetApp-iOS
//
//  功能：负责读取 PhysicsDSL.yaml 文件，解析为 Swift 数据结构，并交给 Validator 校验
//  链路位置：AIParsingService.swift -> PhysicsDSLParser.swift -> PhysicsSchema.json -> PhysicsValidator.swift
//

import Foundation
import Yams   // 用于解析 YAML
import SwiftyJSON  // 用于更方便处理 JSON 数据

/// 物理 DSL 解析器
/// 作用：将 PhysicsDSL.yaml 文件转为 Swift 对象，供后续 Validator + Simulator 使用
class PhysicsDSLParser {
    
    /// 解析入口方法
    /// - Returns: 解析成功后的 JSON 对象（可用于校验）
    static func parsePhysicsDSL() -> JSON? {
        // 1. 定位 PhysicsDSL.yaml 文件
        guard let path = Bundle.main.path(forResource: "PhysicsDSL", ofType: "yaml") else {
            print("❌ 未找到 PhysicsDSL.yaml 文件")
            return nil
        }
        
        do {
            // 2. 读取文件内容（YAML 格式）
            let yamlString = try String(contentsOfFile: path, encoding: .utf8)
            
            // 3. 使用 Yams 转换 YAML -> Dictionary
            guard let yamlObject = try Yams.load(yaml: yamlString) as? [String: Any] else {
                print("❌ YAML 格式错误，无法解析为字典")
                return nil
            }
            
            // 4. 转为 SwiftyJSON 格式，方便后续处理
            let json = JSON(yamlObject)
            
            print("✅ PhysicsDSL 解析成功")
            return json
            
        } catch {
            print("❌ PhysicsDSL 解析失败: \(error.localizedDescription)")
            return nil
        }
    }
}
