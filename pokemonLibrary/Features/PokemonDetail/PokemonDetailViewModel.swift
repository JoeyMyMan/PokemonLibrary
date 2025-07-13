import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let pokemonService = PokemonService.shared
    
    init(pokemonId: Int? = nil) {
        if let id = pokemonId {
            loadPokemonDetails(id: id)
        }
    }
    
    func loadPokemonDetails(id: Int) {
        isLoading = true
        
        // 模拟网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            if let pokemon = self.pokemonService.getPokemon(byId: id) {
                self.pokemon = pokemon
                self.errorMessage = nil
            } else {
                self.errorMessage = "未找到ID为\(id)的Pokemon"
            }
            
            self.isLoading = false
        }
    }
    
    // 计算属性条比例
    func getStatPercentage(for value: Int) -> Float {
        let maxStatValue: Float = 255.0 // Pokemon最大属性值
        return min(Float(value) / maxStatValue, 1.0)
    }
} 