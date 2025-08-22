//
//  AIServiceIndex.swift
//  CnPhetApp-iOS
//
//  Created by AI Assistant on 2025/1/27.
//

import Foundation

// MARK: - AI服务索引

/// AI功能模块的统一入口和管理器
/// 包含所有AI相关的服务和功能
struct AIServiceIndex {
    
    // MARK: - 服务类型
    enum ServiceType {
        case chat           // AI聊天
        case parsing        // AI解析
        case explanation    // AI解释
        case generation     // AI生成
    }
    
    // MARK: - 服务状态
    struct ServiceStatus {
        let isAvailable: Bool
        let lastUpdate: Date
        let errorMessage: String?
    }
    
    // MARK: - 获取服务状态
    static func getServiceStatus(for type: ServiceType) -> ServiceStatus {
        switch type {
        case .chat:
            return ServiceStatus(
                isAvailable: true,
                lastUpdate: Date(),
                errorMessage: nil
            )
        case .parsing:
            return ServiceStatus(
                isAvailable: true,
                lastUpdate: Date(),
                errorMessage: nil
            )
        case .explanation:
            return ServiceStatus(
                isAvailable: false,
                lastUpdate: Date(),
                errorMessage: "功能开发中"
            )
        case .generation:
            return ServiceStatus(
                isAvailable: false,
                lastUpdate: Date(),
                errorMessage: "功能开发中"
            )
        }
    }
    
    // MARK: - 获取可用服务列表
    static func getAvailableServices() -> [ServiceType] {
        return [.chat, .parsing]
    }
    
    // MARK: - 服务描述
    static func getServiceDescription(for type: ServiceType) -> String {
        switch type {
        case .chat:
            return "AI聊天助手，提供智能问答服务"
        case .parsing:
            return "AI解析服务，将自然语言转换为DSL"
        case .explanation:
            return "AI解释服务，提供知识点详细说明"
        case .generation:
            return "AI生成服务，创建教学内容和模型"
        }
    }
}
