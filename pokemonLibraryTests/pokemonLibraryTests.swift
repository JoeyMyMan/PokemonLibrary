//
//  pokemonLibraryTests.swift
//  pokemonLibraryTests
//
//  Created by 小麦克 on 2025/7/13.
//

import XCTest
@testable import pokemonLibrary

final class pokemonLibraryTests: XCTestCase {

    func testPokemonModel() {
        // 创建测试Pokemon实例
        let testPokemon = Pokemon(
            id: 25,
            name: "皮卡丘",
            types: [.electric],
            imageUrl: "pikachu",
            description: "皮卡丘有储存电力的电囊。",
            height: 4.0,
            weight: 60.0,
            abilities: ["静电", "避雷针"],
            stats: Pokemon.Stats(
                hp: 35,
                attack: 55,
                defense: 40,
                specialAttack: 50,
                specialDefense: 50,
                speed: 90
            )
        )
        
        // 测试属性
        XCTAssertEqual(testPokemon.id, 25)
        XCTAssertEqual(testPokemon.name, "皮卡丘")
        XCTAssertEqual(testPokemon.types.count, 1)
        XCTAssertEqual(testPokemon.types.first, .electric)
        XCTAssertEqual(testPokemon.imageUrl, "pikachu")
        XCTAssertEqual(testPokemon.description, "皮卡丘有储存电力的电囊。")
        XCTAssertEqual(testPokemon.height, 4.0)
        XCTAssertEqual(testPokemon.weight, 60.0)
        XCTAssertEqual(testPokemon.abilities.count, 2)
        XCTAssertEqual(testPokemon.stats.hp, 35)
        
        // 测试计算属性
        XCTAssertEqual(testPokemon.formattedHeight, "0.4 m")
        XCTAssertEqual(testPokemon.formattedWeight, "6.0 kg")
    }
    
    func testPokemonService() {
        let service = PokemonService.shared
        let allPokemon = service.getPokemonList()
        
        // 测试Pokemon列表
        XCTAssertFalse(allPokemon.isEmpty)
        XCTAssertEqual(allPokemon.count, 10)
        
        // 测试获取特定Pokemon
        let pikachu = service.getPokemon(byId: 25)
        XCTAssertNotNil(pikachu)
        XCTAssertEqual(pikachu?.name, "皮卡丘")
        
        // 测试不存在的ID
        let nonExistent = service.getPokemon(byId: 999)
        XCTAssertNil(nonExistent)
        
        // 测试搜索功能
        let fireResults = service.searchPokemon(query: "火")
        XCTAssertEqual(fireResults.count, 2) // 小火龙和喷火龙
        
        let emptyResults = service.searchPokemon(query: "不存在的名字")
        XCTAssertTrue(emptyResults.isEmpty)
        
        let allResults = service.searchPokemon(query: "")
        XCTAssertEqual(allResults.count, allPokemon.count)
    }
    
    func testPokemonType() {
        // 测试类型颜色
        XCTAssertEqual(PokemonType.fire.color, "fireType")
        XCTAssertEqual(PokemonType.water.color, "waterType")
        XCTAssertEqual(PokemonType.grass.color, "grassType")
        XCTAssertEqual(PokemonType.electric.color, "electricType")
    }
}
