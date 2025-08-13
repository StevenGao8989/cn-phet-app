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
    private init() {
        client = SupabaseClient(
            supabaseURL: AppConfig.supabaseURL,
            supabaseKey: AppConfig.supabaseAnonKey
        )
    }
}
