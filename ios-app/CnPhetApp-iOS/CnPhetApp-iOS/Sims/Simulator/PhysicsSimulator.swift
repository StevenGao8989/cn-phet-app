//
//  PhysicsSimulator.swift
//  CnPhetApp-iOS
//
//  Created by 高秉嵩 on 2025/8/22.
//

import Foundation

/// PhysicsSimulator.swift
/// 将 PhysicsDSL（已通过 Validator 校验的 JSON）转化为内部物理世界模型
/// 并提供接口交给 PhysicsEngineBridge.swift 去执行

// ======================
// 物理世界数据结构
// ======================

/// 场景信息
struct PhysicsScene {
    let coordinateSystem: String
    let startTime: Double
    let endTime: Double
    let step: Double
    let ignore: [String]
}

/// 基础二维向量
struct Vector2D {
    let x: Double
    let y: Double
}

/// 物体（支持多类型：质点/小车/弹簧/电荷/光学元件等）
struct PhysicsObject {
    let id: String
    let type: String
    let mass: Double?
    let radius: Double?
    let size: (width: Double, height: Double)?
    let position: Vector2D?
    let velocity: Vector2D?
    let constraint: String?
    let angle: String?
    let length: Double?
    let k: Double?
    let restLength: Double?
    let attach: [String]?
    let frequency: Double?
    let amplitude: Double?
    let wavelength: Double?
    let power: Double?
    let capacity: Double?
    let q: Double?
    let I: Double?
    let direction: Vector2D?
    let R: Double?
    let C: Double?
    let L: Double?
    let turns: Double?
    let current: Double?
    let focalLength: Double?
    let shape: String?
    let d: Double?
    let screenDistance: Double?
    let energy: Double?
    let protons: Int?
    let neutrons: Int?
}

/// 运动模型
struct PhysicsMotion {
    let target: String
    let type: String
    let params: [String: Any]
}

/// 连接器（绳子/弹簧/电路等）
struct PhysicsConnector {
    let type: String
    let between: [String]?
    let elements: [String]?
    let source: String?
    let k: Double?
    let restLength: Double?
}

/// 力与场
struct PhysicsForce {
    let type: String
    let g: Double?
    let target: [String]?
    let mu: Double?
    let fluidDensity: Double?
    let E: Vector2D?
    let B: (x: Double, y: Double, z: Double)?
}

/// 初始条件
struct PhysicsInitial {
    let temperature: (object: String, T: Double)?
    let displacement: (object: String, dx: Double)?
    let releaseCondition: (object: String, velocity: Double, fromRest: Bool)?
}

/// 输出需求
struct PhysicsOutput {
    let type: String
    let objects: [String]?
    let components: [String]?
    let show: [String]?
}

/// 整个物理世界模型
struct PhysicsWorld {
    let scene: PhysicsScene
    let objects: [PhysicsObject]
    let motions: [PhysicsMotion]
    let connectors: [PhysicsConnector]
    let forces: [PhysicsForce]
    let initial: PhysicsInitial?
    let outputs: [PhysicsOutput]
}

// ======================
// PhysicsSimulator 主类
// ======================

class PhysicsSimulator {
    
    /// 将 DSL(JSON) 转换为 PhysicsWorld
    static func buildWorld(from dsl: [String: Any]) -> PhysicsWorld? {
        // 1. 解析 scene
        guard let sceneDict = dsl["scene"] as? [String: Any],
              let timeDict = sceneDict["time"] as? [String: Any] else {
            print("❌ 缺少 scene 配置")
            return nil
        }
        
        let scene = PhysicsScene(
            coordinateSystem: sceneDict["coordinate_system"] as? String ?? "cartesian",
            startTime: timeDict["start"] as? Double ?? 0,
            endTime: timeDict["end"] as? Double ?? 10,
            step: timeDict["step"] as? Double ?? 0.01,
            ignore: sceneDict["ignore"] as? [String] ?? []
        )
        
        // 2. 解析 objects
        var objects: [PhysicsObject] = []
        if let objArray = dsl["objects"] as? [[String: Any]] {
            for obj in objArray {
                let physicsObj = PhysicsObject(
                    id: obj["id"] as! String,
                    type: obj["type"] as! String,
                    mass: obj["mass"] as? Double,
                    radius: obj["radius"] as? Double,
                    size: {
                        if let sizeDict = obj["size"] as? [String: Any],
                           let w = sizeDict["width"] as? Double,
                           let h = sizeDict["height"] as? Double {
                            return (w, h)
                        }
                        return nil
                    }(),
                    position: {
                        if let pos = (obj["initial"] as? [String: Any])?["position"] as? [String: Any],
                           let x = pos["x"] as? Double, let y = pos["y"] as? Double {
                            return Vector2D(x: x, y: y)
                        }
                        return nil
                    }(),
                    velocity: {
                        if let vel = (obj["initial"] as? [String: Any])?["velocity"] as? [String: Any],
                           let x = vel["x"] as? Double, let y = vel["y"] as? Double {
                            return Vector2D(x: x, y: y)
                        }
                        return nil
                    }(),
                    constraint: obj["constraint"] as? String,
                    angle: obj["angle"] as? String,
                    length: obj["length"] as? Double,
                    k: obj["k"] as? Double,
                    restLength: obj["rest_length"] as? Double,
                    attach: obj["attach"] as? [String],
                    frequency: obj["frequency"] as? Double,
                    amplitude: obj["amplitude"] as? Double,
                    wavelength: obj["wavelength"] as? Double,
                    power: obj["power"] as? Double,
                    capacity: obj["capacity"] as? Double,
                    q: obj["q"] as? Double,
                    I: obj["I"] as? Double,
                    direction: {
                        if let dir = obj["direction"] as? [String: Any],
                           let x = dir["x"] as? Double, let y = dir["y"] as? Double {
                            return Vector2D(x: x, y: y)
                        }
                        return nil
                    }(),
                    R: obj["R"] as? Double,
                    C: obj["C"] as? Double,
                    L: obj["L"] as? Double,
                    turns: obj["turns"] as? Double,
                    current: obj["current"] as? Double,
                    focalLength: obj["focal_length"] as? Double,
                    shape: obj["shape"] as? String,
                    d: obj["d"] as? Double,
                    screenDistance: obj["screen_distance"] as? Double,
                    energy: obj["energy"] as? Double,
                    protons: obj["protons"] as? Int,
                    neutrons: obj["neutrons"] as? Int
                )
                objects.append(physicsObj)
            }
        }
        
        // 3. motions
        var motions: [PhysicsMotion] = []
        if let motionArray = dsl["motions"] as? [[String: Any]] {
            for m in motionArray {
                motions.append(PhysicsMotion(
                    target: m["target"] as! String,
                    type: m["type"] as! String,
                    params: m["params"] as? [String: Any] ?? [:]
                ))
            }
        }
        
        // 4. connectors
        var connectors: [PhysicsConnector] = []
        if let connArray = dsl["connectors"] as? [[String: Any]] {
            for c in connArray {
                connectors.append(PhysicsConnector(
                    type: c["type"] as! String,
                    between: c["between"] as? [String],
                    elements: c["elements"] as? [String],
                    source: c["source"] as? String,
                    k: c["k"] as? Double,
                    restLength: c["rest_length"] as? Double
                ))
            }
        }
        
        // 5. forces
        var forces: [PhysicsForce] = []
        if let forceArray = dsl["forces"] as? [[String: Any]] {
            for f in forceArray {
                forces.append(PhysicsForce(
                    type: f["type"] as! String,
                    g: f["g"] as? Double,
                    target: f["target"] as? [String],
                    mu: f["mu"] as? Double,
                    fluidDensity: f["fluid_density"] as? Double,
                    E: {
                        if let eDict = f["E"] as? [String: Any],
                           let x = eDict["x"] as? Double, let y = eDict["y"] as? Double {
                            return Vector2D(x: x, y: y)
                        }
                        return nil
                    }(),
                    B: {
                        if let bDict = f["B"] as? [String: Any],
                           let x = bDict["x"] as? Double,
                           let y = bDict["y"] as? Double,
                           let z = bDict["z"] as? Double {
                            return (x, y, z)
                        }
                        return nil
                    }()
                ))
            }
        }
        
        // 6. initial
        var initial: PhysicsInitial? = nil
        if let initDict = dsl["initial"] as? [String: Any] {
            initial = PhysicsInitial(
                temperature: {
                    if let t = initDict["temperature"] as? [String: Any],
                       let obj = t["object"] as? String,
                       let T = t["T"] as? Double {
                        return (obj, T)
                    }
                    return nil
                }(),
                displacement: {
                    if let d = initDict["displacement"] as? [String: Any],
                       let obj = d["object"] as? String,
                       let dx = d["dx"] as? Double {
                        return (obj, dx)
                    }
                    return nil
                }(),
                releaseCondition: {
                    if let r = initDict["release_condition"] as? [String: Any],
                       let obj = r["object"] as? String,
                       let v = r["velocity"] as? Double,
                       let fromRest = r["from_rest"] as? Bool {
                        return (obj, v, fromRest)
                    }
                    return nil
                }()
            )
        }
        
        // 7. outputs
        var outputs: [PhysicsOutput] = []
        if let outArray = dsl["outputs"] as? [[String: Any]] {
            for o in outArray {
                outputs.append(PhysicsOutput(
                    type: o["type"] as! String,
                    objects: o["objects"] as? [String],
                    components: o["components"] as? [String],
                    show: o["show"] as? [String]
                ))
            }
        }
        
        // 8. 组装 PhysicsWorld
        return PhysicsWorld(
            scene: scene,
            objects: objects,
            motions: motions,
            connectors: connectors,
            forces: forces,
            initial: initial,
            outputs: outputs
        )
    }
}
