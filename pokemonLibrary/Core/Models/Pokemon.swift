import Foundation

struct Pokemon: Identifiable, Equatable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let imageUrl: String
    let description: String
    let height: Double
    let weight: Double
    let abilities: [String]
    let stats: Stats
    
    var formattedHeight: String {
        return String(format: "%.1f m", height / 10)
    }
    
    var formattedWeight: String {
        return String(format: "%.1f kg", weight / 10)
    }
    
    // 获取本地图片名称
    var localImageName: String {
        // 从名称中提取中文部分（假设格式为"中文 英文"）
        let chineseName = name.components(separatedBy: " ").first ?? ""
        // 返回资产名称，格式为"001_妙蛙种子"
        return "\(String(format: "%03d", id))_\(chineseName)"
    }
    
    // 获取系统图标名称，用于替代实际图片
    var systemIconName: String {
        switch id {
        case 1: return "leaf.fill" // 妙蛙种子
        case 4: return "flame.fill" // 小火龙
        case 6: return "flame.fill" // 喷火龙
        case 7: return "drop.fill" // 杰尼龟
        case 25: return "bolt.fill" // 皮卡丘
        case 94: return "moon.stars.fill" // 耿鬼
        case 130: return "tornado" // 暴鲤龙
        case 143: return "zzz" // 卡比兽
        case 149: return "wind" // 快龙
        case 150: return "brain" // 超梦
        default: return "questionmark.circle.fill"
        }
    }
    
    struct Stats: Equatable {
        let hp: Int
        let attack: Int
        let defense: Int
        let specialAttack: Int
        let specialDefense: Int
        let speed: Int
    }
}

enum PokemonType: String, CaseIterable {
    case normal = "一般 Normal"
    case fire = "火 Fire"
    case water = "水 Water"
    case electric = "电 Electric"
    case grass = "草 Grass"
    case ice = "冰 Ice"
    case fighting = "格斗 Fighting"
    case poison = "毒 Poison"
    case ground = "地面 Ground"
    case flying = "飞行 Flying"
    case psychic = "超能力 Psychic"
    case bug = "虫 Bug"
    case rock = "岩石 Rock"
    case ghost = "幽灵 Ghost"
    case dragon = "龙 Dragon"
} 