//
//  ContentStore.swift
//  
//
//  Created by 高秉嵩 on 2025/8/12.
//

import Foundation

final class ContentStore: ObservableObject {
    @Published var topics: [Topic] = []
    @Published var filter: Subject? = nil

    init() {
        load()
    }

    func load() {
        // 1) 尝试从 Bundle 读取你复制进来的 full_science_mvp_36.json
        if let url = Bundle.main.url(forResource: "full_science_mvp_36", withExtension: "json") {
            do {
                // 你那份 JSON 的结构我们暂时未知，这里做防御性解析：
                // 只要包含我们需要的最小字段，就映射成 Topic；否则走 fallback。
                let data = try Data(contentsOf: url)
                if let topics = try? JSONDecoder().decode([Topic].self, from: data) {
                    self.topics = topics
                    return
                }
                // TODO: 如果你的 JSON 是“科目→话题”的嵌套结构，可在这里写自定义映射
            } catch {
                print("JSON load error:", error.localizedDescription)
            }
        }
        // 2) 兜底：给一组可运行的样例（先覆盖 10 个目标里的“抛体”这一个）
        self.topics = [
            Topic(id: "physics_projectile", title: "抛体运动", subject: .physics, sim: .projectile, thumb: "thumb_physics_projectile"),
            // 其余 9 个先占位，页面会提示“开发中”
            Topic(id: "physics_freefall", title: "自由落体", subject: .physics, sim: .freefall, thumb: nil),
            Topic(id: "physics_lens", title: "透镜成像", subject: .physics, sim: .lens, thumb: nil),
            Topic(id: "physics_ohm", title: "欧姆定律", subject: .physics, sim: .ohm, thumb: nil),
            Topic(id: "math_linear", title: "一次函数 y=kx+b", subject: .math, sim: .linear, thumb: nil),
            Topic(id: "math_quadratic", title: "二次函数 y=ax²+bx+c", subject: .math, sim: .quadratic, thumb: nil),
            Topic(id: "math_sine", title: "三角函数 y=A·sin(ωx+φ)", subject: .math, sim: .sine, thumb: nil),
            Topic(id: "chem_ideal_gas", title: "理想气体 pV=nRT", subject: .chemistry, sim: .idealGas, thumb: nil),
            Topic(id: "chem_titration", title: "酸碱滴定等当点", subject: .chemistry, sim: .titration, thumb: nil),
            Topic(id: "bio_enzyme", title: "酶活性-温度/pH", subject: .biology, sim: .enzyme, thumb: nil)
        ]
    }

    var visibleTopics: [Topic] {
        guard let filter else { return topics }
        return topics.filter { $0.subject == filter }
    }
}
