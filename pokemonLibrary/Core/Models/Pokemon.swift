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
        return "\(String(format: "%03d", id))_\(name)"
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
    case normal = "一般"
    case fire = "火"
    case water = "水"
    case electric = "电"
    case grass = "草"
    case ice = "冰"
    case fighting = "格斗"
    case poison = "毒"
    case ground = "地面"
    case flying = "飞行"
    case psychic = "超能力"
    case bug = "虫"
    case rock = "岩石"
    case ghost = "幽灵"
    case dragon = "龙"
} 