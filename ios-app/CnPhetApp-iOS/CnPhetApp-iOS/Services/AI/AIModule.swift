//
//  AIModule.swift
//  CnPhetApp-iOS
//
//  Created by AI Assistant on 2025/1/27.
//

import Foundation
import SwiftUI

// MARK: - AI模块主入口

/// AI模块的统一入口点
/// 提供所有AI相关功能的访问接口
struct AIModule {
    
    // MARK: - 服务
    /// AI解析服务
    static let parsingService = AIParsingService()
    
    /// AI服务索引
    static let serviceIndex = AIServiceIndex.self
    
    // MARK: - 视图
    /// AI助手主视图
    static let assistantView = AIAssistantView.self
    
    /// AI聊天视图
    static let chatView = AIChatView.self
    
    /// AI聊天视图模型
    static let chatViewModel = AIViewModel.self
    
    /// 对话视图组件
    static let conversationView = ConversationView.self
}

// MARK: - 便捷访问扩展

/// 为SwiftUI View提供便捷的AI功能访问
extension View {
    /// 导航到AI助手
    func navigateToAIAssistant() -> some View {
        NavigationLink(destination: AIAssistantView()) {
            self
        }
    }
    
    /// 导航到AI聊天
    func navigateToAIChat() -> some View {
        NavigationLink(destination: AIChatView()) {
            self
        }
    }
}
