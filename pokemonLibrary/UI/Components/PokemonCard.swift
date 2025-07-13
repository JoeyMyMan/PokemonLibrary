import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                // Pokemon图片
                PokemonImageView(pokemon: pokemon, width: 70, height: 70)
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    // ID和名字
                    HStack {
                        Text("#\(String(format: "%03d", pokemon.id))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(pokemon.name)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                    // 类型标签
                    HStack {
                        ForEach(pokemon.types, id: \.self) { type in
                            Text(type.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.forType(type))
                                .cornerRadius(10)
                        }
                    }
                }
                
                Spacer()
            }
            
            // 简短描述
            Text(pokemon.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// 预览
struct PokemonCard_Previews: PreviewProvider {
    static let samplePokemon = Pokemon(
        id: 25,
        name: "皮卡丘",
        types: [.electric],
        imageUrl: "pikachu",
        description: "皮卡丘有储存电力的电囊。当它觉得受到威胁时，就会立即释放出电力。",
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
    
    static var previews: some View {
        PokemonCard(pokemon: samplePokemon)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDevice("iPhone 13")
            .previewDisplayName("iPhone 13")
    }
} 