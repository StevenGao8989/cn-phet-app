//
//  TopicRow.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation
import SwiftUI

struct TopicRow: View {
    let topic: Topic
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.12))
                    .frame(width: 56, height: 56)
                Text(topic.subject.title.prefix(1))
                    .font(.headline)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title).font(.headline)
                Text(topic.subject.title).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
