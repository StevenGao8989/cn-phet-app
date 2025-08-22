import Foundation
import JSONSchema

class JSONValidator {
    static func validate(json: [String: Any], schemaFile: String) -> Bool {
        guard let path = Bundle.main.path(forResource: schemaFile, ofType: "json"),
              let schemaData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("❌ 找不到 Schema 文件")
            return false
        }
        
        do {
            // 1. 加载 Schema - 先将 Data 转换为 JSON 对象，然后创建 Schema
            let schemaObject = try JSONSerialization.jsonObject(with: schemaData, options: []) as! [String: Any]
            let schema = try JSONSchema.Schema(schemaObject)
            
            // 2. 输入 JSON 转换为 Data
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            
            // 3. 验证 - 明确指定使用 ValidationResult 版本
            let _: ValidationResult = try schema.validate(jsonData)
            
            print("✅ JSON 校验通过")
            return true
        } catch {
            print("❌ JSON 校验失败: \(error)")
            return false
        }
    }
}