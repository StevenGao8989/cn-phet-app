//
//  Topics.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation

enum Subject: String, Codable, CaseIterable, Identifiable, Hashable {
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
    
    var englishTitle: String {
        switch self {
        case .physics: return "Physics"
        case .math: return "Mathematics"
        case .chemistry: return "Chemistry"
        case .biology: return "Biology"
        }
    }
}

enum Grade: String, Codable, CaseIterable, Identifiable, Hashable {
    case grade7, grade8, grade9, grade10, grade11, grade12
    var id: String { rawValue }
    var title: String {
        switch self {
        case .grade7: return "初一"
        case .grade8: return "初二"
        case .grade9: return "初三"
        case .grade10: return "高一"
        case .grade11: return "高二"
        case .grade12: return "高三"
        }
    }
    
    var englishTitle: String {
        switch self {
        case .grade7: return "Grade 7"
        case .grade8: return "Grade 8"
        case .grade9: return "Grade 9"
        case .grade10: return "Grade 10"
        case .grade11: return "Grade 11"
        case .grade12: return "Grade 12"
        }
    }
}

enum SimType: String, Codable, Hashable {
    case projectile, freefall, lens, ohm, linear, quadratic, sine, idealGas, titration, enzyme
}

struct Topic: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subject: Subject
    let sim: SimType
    let thumb: String?
}

// 新的知识点模型，支持年级信息
struct PhysicsTopic: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let grade: Grade
    let difficulty: String
    let coreConcepts: [String]
    let parameters: [TopicParameter]
    let equations: [String]
    let formulaDescription: String
    let applicationScenarios: [String]
    let experimentType: String
    let experimentGoal: String
    let teachingFocus: [String]
    let commonErrors: [String]
    let thumbnail: String
    let teachingResources: TeachingResources
}

struct TopicParameter: Codable, Hashable {
    let symbol: String
    let name: String
    let unit: String
    let range: [Double]
    let defaultValue: Double
    let description: String
}

struct TeachingResources: Codable, Hashable {
    let videos: [String]
    let experiments: [String]
    let exercises: [String]
}

// 新增：大类知识点模型
struct PhysicsCategory: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let icon: String
    let description: String
    let topics: [PhysicsTopic]
}

// 新增：年级物理大纲模型
struct GradePhysicsOutline: Codable {
    let grade: String
    let gradeEnglish: String
    let categories: [PhysicsCategory]
    let teachingGoal: String
    let keyPoints: [String]
}

// 新增：实验资源模型
struct ExperimentResource: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let thumbnail: String
    let viewCount: String
    let isVIP: Bool
    let category: String
    let description: String
    let difficulty: String
    let estimatedTime: String
    let tags: [String]
}
