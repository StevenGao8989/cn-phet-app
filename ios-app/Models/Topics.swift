//
//  Topics.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation

enum Subject: String, Codable, CaseIterable, Identifiable {
    case physics, math, chemistry, biology
    var id: String { rawValue }
    var title: String {
        switch self {
        case .physics: return "物理"
        case .math: return "数学"
        case .chemistry: return "化学"
        case .biology: return "生物"
        }
    }
}

enum SimType: String, Codable {
    case projectile    // 抛体（已实现）
    case freefall, lens, ohm
    case linear, quadratic, sine
    case idealGas, titration, enzyme
}

struct Topic: Identifiable, Codable {
    let id: String
    let title: String
    let subject: Subject
    let sim: SimType
    let thumb: String?   // 例如 "thumb_physics_projectile"
}
