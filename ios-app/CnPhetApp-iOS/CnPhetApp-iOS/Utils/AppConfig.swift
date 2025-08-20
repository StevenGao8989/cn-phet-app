//
//  AppConfig.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//


// Utils/AppConfig.swift
import Foundation

enum AppConfig {
    static var supabaseURL: URL {
        guard let raw = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let url = URL(string: raw),
              url.scheme == "https",
              let host = url.host,
              host.contains("supabase.")  // .co 或 .net 都行
        else {
            fatalError("❌ SUPABASE_URL 配置错误：请在 Secrets.xcconfig/Info.plist 填完整的项目 URL（形如 https://<projectRef>.supabase.co）")
        }
        // 额外校验：Host 必须形如 "<projectRef>.supabase.co"
        let parts = host.split(separator: ".")
        precondition(parts.count >= 3, "❌ SUPABASE_URL 必须包含项目子域，例如 https://<projectRef>.supabase.co")
        return url
    }

    static var supabaseAnonKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              key.count > 10 else {
            fatalError("❌ 缺少 SUPABASE_ANON_KEY，请在 Secrets.xcconfig/Info.plist 配置 anon 公钥")
        }
        return key
    }
}
