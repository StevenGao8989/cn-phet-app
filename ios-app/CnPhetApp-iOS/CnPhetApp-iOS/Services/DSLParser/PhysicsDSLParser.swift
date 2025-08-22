import Foundation
import Yams   // 一个常用的 Swift YAML 解析库

class DSLParser {
    static func parseDSL(fileName: String) -> [String: Any]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "yaml") else {
            print("❌ 找不到 DSL 文件")
            return nil
        }
        do {
            let yamlString = try String(contentsOfFile: path, encoding: .utf8)
            if let dict = try Yams.load(yaml: yamlString) as? [String: Any] {
                return dict
            }
        } catch {
            print("❌ YAML 解析失败: \(error)")
        }
        return nil
    }
}

