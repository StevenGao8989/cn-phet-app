//
//  SupabaseService.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

// Services/SupabaseService.swift
import Foundation
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()
    let client: SupabaseClient

    // 你的 Edge Function 地址（已经部署好的 delete-user）
    private let deleteUserEndpoint = URL(string:
      "https://yveexbmtnlnsfwrpumgy.supabase.co/functions/v1/delete-user"
    )!

    private init() {
        // 从 Info.plist 读取（你之前已把 Xcode 的 User-Defined 映射到 Info）
        let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
        let anonKey   = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""

        guard let url = URL(string: urlString), !anonKey.isEmpty else {
            // 如果取不到，说明 Info.plist 没写好；给出清晰报错
            fatalError("缺少 SUPABASE_URL / SUPABASE_ANON_KEY（请在 Info.plist 填好这两个键）")
        }

        client = SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }

    /// 调用受保护的 Edge Function，后端用 service-role 删除账号
    func deleteCurrentUserViaEdge(jwt: String) async throws {
        var req = URLRequest(url: deleteUserEndpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        req.httpBody = try JSONSerialization.data(
            withJSONObject: ["reason": "user_initiated"],
            options: []
        )

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "delete-user failed"
            throw NSError(domain: "DeleteUser",
                          code: (resp as? HTTPURLResponse)?.statusCode ?? -1,
                          userInfo: [NSLocalizedDescriptionKey: msg])
        }
    }
}
