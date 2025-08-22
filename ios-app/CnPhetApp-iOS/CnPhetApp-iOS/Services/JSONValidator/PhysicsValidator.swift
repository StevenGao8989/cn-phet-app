import Foundation
import JSONSchema // 你可以用一个 JSON Schema 验证库

class JSONValidator {
    static func validate(json: [String: Any], schemaFile: String) -> Bool {
        guard let path = Bundle.main.path(forResource: schemaFile, ofType: "json"),
              let schemaData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            print("❌ 找不到 Schema 文件")
            return false
        }
        
        do {
            let schema = try JSONSchema(data: schemaData)
            try schema.validate(json)
            return true
        } catch {
            print("❌ JSON 校验失败: \(error)")
            return false
        }
    }
}

