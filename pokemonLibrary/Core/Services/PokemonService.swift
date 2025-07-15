import Foundation

class PokemonService {
    static let shared = PokemonService()
    
    private init() {}
    
    // 获取所有Pokemon
    func getPokemonList() -> [Pokemon] {
        return pokemonData
    }
    
    // 根据ID查询Pokemon
    func getPokemon(byId id: Int) -> Pokemon? {
        return pokemonData.first { $0.id == id }
    }
    
    // 根据关键词搜索Pokemon
    func searchPokemon(query: String) -> [Pokemon] {
        guard !query.isEmpty else { return pokemonData }
        
        let lowercasedQuery = query.lowercased()
        
        return pokemonData.filter { pokemon in
            pokemon.name.lowercased().contains(lowercasedQuery) ||
            pokemon.types.map { $0.rawValue.lowercased() }.contains { $0.contains(lowercasedQuery) } ||
            pokemon.description.lowercased().contains(lowercasedQuery) ||
            pokemon.abilities.joined(separator: " ").lowercased().contains(lowercasedQuery)
        }
    }
    
    // 第一代10个代表性Pokemon数据
    private let pokemonData: [Pokemon] = [
        Pokemon(
            id: 1,
            name: "妙蛙种子 Bulbasaur",
            types: [.grass, .poison],
            imageUrl: "bulbasaur",
            description: "妙蛙种子的背上有一个种子，从出生的那一刻起就伴随着它。种子会慢慢地长大。\nA seed is planted on its back at birth. The seed slowly grows larger.",
            height: 7.0,
            weight: 69.0,
            abilities: ["茂盛 Overgrow", "叶绿素 Chlorophyll"],
            stats: Pokemon.Stats(
                hp: 45,
                attack: 49,
                defense: 49,
                specialAttack: 65,
                specialDefense: 65,
                speed: 45
            )
        ),
        Pokemon(
            id: 4,
            name: "小火龙 Charmander",
            types: [.fire],
            imageUrl: "charmander",
            description: "小火龙尾巴上的火焰是表示它生命力的象征。如果它健康强壮，火焰就会燃烧得很旺盛。\nThe flame on its tail shows the strength of its life force. If it is weak, the flame also burns weakly.",
            height: 6.0,
            weight: 85.0,
            abilities: ["猛火 Blaze", "太阳之力 Solar Power"],
            stats: Pokemon.Stats(
                hp: 39,
                attack: 52,
                defense: 43,
                specialAttack: 60,
                specialDefense: 50,
                speed: 65
            )
        ),
        Pokemon(
            id: 7,
            name: "杰尼龟 Squirtle",
            types: [.water],
            imageUrl: "squirtle",
            description: "杰尼龟的硬壳不仅用于保护自己，光滑的圆形外形和表面的沟槽使它在水中减少阻力，让这个宝可梦能够以极高的速度游泳。\nIts shell is not just for protection. Its rounded shape and the grooves on its surface minimize resistance in water, enabling it to swim at high speeds.",
            height: 5.0,
            weight: 90.0,
            abilities: ["激流 Torrent", "雨盘 Rain Dish"],
            stats: Pokemon.Stats(
                hp: 44,
                attack: 48,
                defense: 65,
                specialAttack: 50,
                specialDefense: 64,
                speed: 43
            )
        ),
        Pokemon(
            id: 25,
            name: "皮卡丘 Pikachu",
            types: [.electric],
            imageUrl: "pikachu",
            description: "皮卡丘有储存电力的电囊。当它觉得受到威胁时，就会立即释放出电力。当皮卡丘们聚在一起时，它们会释放出大量的电力。\nPikachu stores electricity in its cheeks. When it feels threatened, it immediately discharges electricity. When Pikachu gather, they can release large amounts of electricity.",
            height: 4.0,
            weight: 60.0,
            abilities: ["静电 Static", "避雷针 Lightning Rod"],
            stats: Pokemon.Stats(
                hp: 35,
                attack: 55,
                defense: 40,
                specialAttack: 50,
                specialDefense: 50,
                speed: 90
            )
        ),
        Pokemon(
            id: 94,
            name: "耿鬼 Gengar",
            types: [.ghost, .poison],
            imageUrl: "gengar",
            description: "耿鬼躲在黑暗的角落里，准备在毫无防备的人经过时吓唬他们。有传言说，在月圆之夜看到耿鬼的人会被带到另一个世界。\nGengar hides in the shadows. It is said that if Gengar is hiding, it cools the area by nearly 10 degrees Fahrenheit. On a full moon night, if a shadow moves on its own, it's said to be Gengar's doing.",
            height: 15.0,
            weight: 405.0,
            abilities: ["诅咒之躯 Cursed Body", "踩影 Shadow Tag"],
            stats: Pokemon.Stats(
                hp: 60,
                attack: 65,
                defense: 60,
                specialAttack: 130,
                specialDefense: 75,
                speed: 110
            )
        ),
        Pokemon(
            id: 143,
            name: "卡比兽 Snorlax",
            types: [.normal],
            imageUrl: "snorlax",
            description: "卡比兽除了睡觉和吃饭之外不做任何事情。它醒着的时候只会四处觅食，每天能吃下近400公斤的食物。\nSnorlax does nothing except eat and sleep. When it's not eating or sleeping, it's looking for food or a place to sleep. It can consume 400 kilograms of food daily.",
            height: 21.0,
            weight: 4600.0,
            abilities: ["免疫 Immunity", "厚脂肪 Thick Fat"],
            stats: Pokemon.Stats(
                hp: 160,
                attack: 110,
                defense: 65,
                specialAttack: 65,
                specialDefense: 110,
                speed: 30
            )
        ),
        Pokemon(
            id: 130,
            name: "暴鲤龙 Gyarados",
            types: [.water, .flying],
            imageUrl: "gyarados",
            description: "暴鲤龙是一种极其凶暴的宝可梦。据说它曾摧毁了一整座城镇，人们需要重建整个城镇。\nGyarados is an extremely fierce Pokémon. It is said to have destroyed an entire town in a fit of rage. It has enough power to completely destroy even a skyscraper.",
            height: 65.0,
            weight: 2350.0,
            abilities: ["威吓 Intimidate", "破格 Moxie"],
            stats: Pokemon.Stats(
                hp: 95,
                attack: 125,
                defense: 79,
                specialAttack: 60,
                specialDefense: 100,
                speed: 81
            )
        ),
        Pokemon(
            id: 149,
            name: "快龙 Dragonite",
            types: [.dragon, .flying],
            imageUrl: "dragonite",
            description: "快龙被称为是海洋中的使者。传说有迷路的人和船只被快龙引导到了陆地。\nDragonite is known as the sea incarnate. There are stories of people lost at sea being guided safely to shore by Dragonite.",
            height: 22.0,
            weight: 2100.0,
            abilities: ["精神力 Inner Focus", "多重鳞片 Multiscale"],
            stats: Pokemon.Stats(
                hp: 91,
                attack: 134,
                defense: 95,
                specialAttack: 100,
                specialDefense: 100,
                speed: 80
            )
        ),
        Pokemon(
            id: 150,
            name: "超梦 Mewtwo",
            types: [.psychic],
            imageUrl: "mewtwo",
            description: "超梦是通过基因工程，从幻之宝可梦梦幻的基因中复制出来的。据说它是最凶恶的宝可梦。\nMewtwo is a Pokémon created by recombining Mew's genes. It's said to have the most savage heart among Pokémon.",
            height: 20.0,
            weight: 1220.0,
            abilities: ["压迫感 Pressure", "无防守 Unnerve"],
            stats: Pokemon.Stats(
                hp: 106,
                attack: 110,
                defense: 90,
                specialAttack: 154,
                specialDefense: 90,
                speed: 130
            )
        ),
        Pokemon(
            id: 6,
            name: "喷火龙 Charizard",
            types: [.fire, .flying],
            imageUrl: "charizard",
            description: "喷火龙在空中飞翔，寻找强大的对手。它可以喷出能融化岩石的高温火焰。但它从不会对比它弱的对手使用这种火焰。\nCharizard flies around the sky in search of powerful opponents. It breathes fire of such great heat that it melts anything. However, it never turns its fiery breath on any opponent weaker than itself.",
            height: 17.0,
            weight: 905.0,
            abilities: ["猛火 Blaze", "太阳之力 Solar Power"],
            stats: Pokemon.Stats(
                hp: 78,
                attack: 84,
                defense: 78,
                specialAttack: 109,
                specialDefense: 85,
                speed: 100
            )
        )
    ]
} 