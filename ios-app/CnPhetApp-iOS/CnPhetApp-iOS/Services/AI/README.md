# AI模块说明文档

## 概述
AI模块是CnPhetApp-iOS应用中的核心功能模块，提供智能问答、内容解析、知识解释等服务。

## 目录结构

```
Services/AI/
├── README.md                 # 本文档
├── AIModule.swift            # AI模块主入口
├── AIServiceIndex.swift      # AI服务索引和管理器
└── AIParsingService.swift    # AI解析服务（从原位置移动）

Views/AI/
├── AIAssistantView.swift     # AI助手主入口视图
├── AIChatView.swift          # AI聊天主视图
├── AIViewModel.swift         # AI聊天视图模型
└── ConversationView.swift    # 对话显示组件

Models/AI/
└── AIModels.swift            # AI相关数据模型
```

## 功能特性

### 1. AI聊天服务 (Chat Service)
- **功能**: 提供智能问答服务
- **状态**: ✅ 已实现
- **文件**: `AIChatView.swift`, `AIViewModel.swift`, `ConversationView.swift`
- **API**: 集成通义千问模型

### 2. AI解析服务 (Parsing Service)
- **功能**: 将自然语言问题转换为DSL格式
- **状态**: ✅ 已实现
- **文件**: `AIParsingService.swift`
- **用途**: 为模拟器提供DSL输入

### 3. AI解释服务 (Explanation Service)
- **功能**: 提供知识点详细说明
- **状态**: 🚧 开发中
- **文件**: 待实现

### 4. AI生成服务 (Generation Service)
- **功能**: 创建教学内容和模型
- **状态**: 🚧 开发中
- **文件**: 待实现

## 使用方法

### 使用AI模块主入口
```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            // 直接使用AI模块
            NavigationLink(destination: AIModule.chatView()) {
                Text("打开AI聊天")
            }
            
            // 使用便捷扩展
            Button("AI助手") {
                // 导航到AI助手
            }
            .navigateToAIAssistant()
        }
    }
}
```

### 在视图中使用AI聊天功能
```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        NavigationLink(destination: AIChatView()) {
            Text("打开AI助手")
        }
    }
}
```

### 使用AI解析服务
```swift
import Foundation

let aiService = AIParsingService()
aiService.parseQuestionToDSL(question: "如何计算自由落体运动？") { dsl in
    if let dsl = dsl {
        print("生成的DSL: \(dsl)")
    }
}
```

## 配置说明

### API配置
AI聊天功能使用Supabase Functions调用通义千问模型：
- **端点**: `https://yveexbmtnlnsfwrpumgy.supabase.co/functions/v1/ask-qwen`
- **认证**: 使用Supabase匿名密钥
- **请求格式**: JSON格式，包含prompt字段

### 环境变量
确保在Info.plist中配置了以下键：
- `SUPABASE_URL`: Supabase项目URL
- `SUPABASE_ANON_KEY`: Supabase匿名密钥

## 扩展指南

### 添加新的AI服务
1. 在`AIServiceIndex.swift`中添加新的服务类型
2. 实现相应的服务类
3. 在`Views/AI/`目录下创建对应的视图
4. 更新服务状态和描述

### 集成新的AI模型
1. 修改`AIConfig.apiEndpoint`指向新的API端点
2. 更新`AIViewModel.swift`中的API调用逻辑
3. 调整请求和响应的数据格式

## 注意事项

1. **网络请求**: 所有AI API调用都是异步的，需要适当的错误处理
2. **状态管理**: 使用`@Published`属性包装器确保UI状态同步
3. **内存管理**: 使用`[weak self]`避免循环引用
4. **用户体验**: 提供加载状态和错误提示

## 更新日志

- **2025-01-27**: 创建AI模块，整理AI相关代码
- **2025-01-27**: 实现AI聊天功能
- **2025-01-27**: 实现AI解析服务
- **2025-01-27**: 创建AI助手界面
