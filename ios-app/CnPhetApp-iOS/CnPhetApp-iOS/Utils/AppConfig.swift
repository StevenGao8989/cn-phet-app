3.1 Config 读取（AppConfig.swift）
swift
Copy
Edit
// Utils/AppConfig.swift
import Foundation

enum AppConfig {
    static var supabaseURL: URL {
        let s = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
        return URL(string: s)!
    }
    static var supabaseAnonKey: String {
        Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""
    }
}