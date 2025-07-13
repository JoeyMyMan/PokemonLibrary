import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    @Published var pokemonList: [Pokemon] = []
    @Published var searchText: String = ""
    @Published var filteredPokemonList: [Pokemon] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let pokemonService = PokemonService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadPokemon()
        setupSearchSubscription()
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.searchPokemon(query: query)
            }
            .store(in: &cancellables)
    }
    
    func loadPokemon() {
        isLoading = true
        
        // 模拟网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            // 简化为直接加载，移除不必要的try-catch
            self.pokemonList = self.pokemonService.getPokemonList()
            self.filteredPokemonList = self.pokemonList
            self.errorMessage = nil
            self.isLoading = false
        }
    }
    
    func searchPokemon(query: String) {
        if query.isEmpty {
            filteredPokemonList = pokemonList
        } else {
            filteredPokemonList = pokemonService.searchPokemon(query: query)
        }
    }
} 