//
//  Profile.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/13.
//

import Foundation
// Models/Profile.swift


// 数据库存取的 Profile（字段与表一致）
// 注意：display_name / avatar_url 用蛇形，便于直接映射 Postgres 列

struct UserProfile: Codable, Identifiable {
    let id: UUID
    var email: String?
    var display_name: String?
    var avatar_url: String?
    var created_at: Date?
    var updated_at: Date?
}


