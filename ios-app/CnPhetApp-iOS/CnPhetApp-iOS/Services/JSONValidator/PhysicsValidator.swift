//
//  PhysicsValidator.swift
//  CnPhetApp-iOS
//
//  功能：根据 PhysicsSchema.json 校验 PhysicsDSL.yaml 解析结果
//

import Foundation
import SwiftyJSON
import JSONSchema

/// 物理 DSL 校验器
class PhysicsValidator {
    
    /// 校验 PhysicsDSL JSON
    /// - Parameter dslJson: 由 PhysicsDSLParser 解析得到的 JSON 对象 (SwiftyJSON)
    /// - Returns: Bool 表示是否校验成功
    static func validate(dslJson: JSON) -> Bool {
        
        // 1. 找到 PhysicsSchema.json 文件路径
        guard let schemaPath = Bundle.main.path(forResource: "PhysicsSchema", ofType: "json"),
              let schemaData = try? Data(contentsOf: URL(fileURLWithPath: schemaPath)) else {
            print("❌ 找不到 PhysicsSchema.json 文件")
            return false
        }
        
        do {
            // 2. 将 Schema Data 转换为 JSON 对象
            guard let schemaObject = try JSONSerialization.jsonObject(with: schemaData, options: []) as? [String: Any] else {
                print("❌ Schema 文件解析失败")
                return false
            }
            
            // 3. 创建 Schema
            let schema = try JSONSchema.Schema(schemaObject)
            
            // 4. 将 DSL JSON 转换为 Data
            let dslData = try dslJson.rawData()
            
            // 5. 执行校验
            let _: ValidationResult = try schema.validate(dslData)
            
            print("✅ PhysicsDSL 校验通过")
            return true
            
        } catch {
            print("❌ PhysicsDSL 校验失败: \(error)")
            return false
        }
    }
}
