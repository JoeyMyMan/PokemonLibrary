import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let pokemonService = PokemonService.shared
    
    init(pokemonId: Int? = nil) {
        if let id = pokemonId {
            fetchPokemon(id: id)
        }
    }
    
    func fetchPokemon(id: Int) {
        isLoading = true
        errorMessage = nil
        
        // 使用同步方法模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            
            if let fetchedPokemon = self.pokemonService.getPokemon(byId: id) {
                self.pokemon = fetchedPokemon
                
                // 播放宝可梦音频
                self.playPokemonSound()
            } else {
                self.errorMessage = "未找到ID为\(id)的宝可梦 Pokemon not found with ID \(id)"
            }
            
            self.isLoading = false
        }
    }
    
    // 计算属性值的百分比，用于显示状态条
    func getStatPercentage(for value: Int) -> Double {
        // 宝可梦属性的最大值通常为255
        let maxStatValue: Double = 255.0
        return min(Double(value) / maxStatValue, 1.0)
    }
    
    // 获取宝可梦动画GIF的路径
    func getAnimationPath(for pokemonId: Int) -> String? {
        // 直接使用GIFManager获取GIF路径
        return GIFManager.shared.getGIFPath(for: pokemonId, name: pokemon?.name)
    }
    
    // 播放宝可梦音频
    func playPokemonSound() {
        guard let pokemon = pokemon else { return }
        
        // 使用SoundManager播放宝可梦音频
        SoundManager.shared.playPokemonSound(for: pokemon.id, name: getPokemonEnglishName(for: pokemon))
    }
    
    // 获取宝可梦英文名称
    private func getPokemonEnglishName(for pokemon: Pokemon) -> String {
        // 从名称中提取英文部分（假设格式为"中文 英文"）
        let components = pokemon.name.components(separatedBy: " ")
        if components.count > 1 {
            return components[1]
        }
        
        // 如果没有英文名，使用SoundManager中的映射
        return ""
    }
} 