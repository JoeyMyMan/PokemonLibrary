import SwiftUI

// 这个扩展提供了对Assets.xcassets中颜色资产的便捷访问
// 与直接在代码中定义颜色不同，这里只是引用Assets.xcassets中已存在的颜色
extension Color {
    // 宝可梦类型颜色 - 从Assets.xcassets中加载
    static var pokemonNormal: Color { Color("normalType") }
    static var pokemonFire: Color { Color("fireType") }
    static var pokemonWater: Color { Color("waterType") }
    static var pokemonElectric: Color { Color("electricType") }
    static var pokemonGrass: Color { Color("grassType") }
    static var pokemonIce: Color { Color("iceType") }
    static var pokemonFighting: Color { Color("fightingType") }
    static var pokemonPoison: Color { Color("poisonType") }
    static var pokemonGround: Color { Color("groundType") }
    static var pokemonFlying: Color { Color("flyingType") }
    static var pokemonPsychic: Color { Color("psychicType") }
    static var pokemonBug: Color { Color("bugType") }
    static var pokemonRock: Color { Color("rockType") }
    static var pokemonGhost: Color { Color("ghostType") }
    static var pokemonDragon: Color { Color("dragonType") }
    
    // 根据宝可梦类型获取对应颜色
    static func forType(_ type: PokemonType) -> Color {
        switch type {
        case .normal: return .pokemonNormal
        case .fire: return .pokemonFire
        case .water: return .pokemonWater
        case .electric: return .pokemonElectric
        case .grass: return .pokemonGrass
        case .ice: return .pokemonIce
        case .fighting: return .pokemonFighting
        case .poison: return .pokemonPoison
        case .ground: return .pokemonGround
        case .flying: return .pokemonFlying
        case .psychic: return .pokemonPsychic
        case .bug: return .pokemonBug
        case .rock: return .pokemonRock
        case .ghost: return .pokemonGhost
        case .dragon: return .pokemonDragon
        }
    }
} 