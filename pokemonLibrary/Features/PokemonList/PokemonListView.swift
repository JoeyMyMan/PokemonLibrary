import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var showingDetail = false
    @State private var selectedPokemon: Pokemon? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景颜色
                Color.secondary.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack {
                    // 搜索栏
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                    
                    if viewModel.isLoading {
                        // 加载指示器
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        // 错误信息
                        VStack {
                            Text("😢 出错了 Error")
                                .font(.title)
                                .padding(.bottom)
                            
                            Text(errorMessage)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                            Button("重试 Retry") {
                                viewModel.loadPokemon()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if viewModel.filteredPokemonList.isEmpty {
                        // 没有结果
                        VStack {
                            Text("没有找到匹配的宝可梦\nNo matching Pokémon found")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button("清除搜索 Clear Search") {
                                viewModel.searchText = ""
                            }
                            .padding(.top)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // Pokemon列表
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredPokemonList) { pokemon in
                                    NavigationLink(
                                        destination: PokemonDetailView(pokemonId: pokemon.id)
                                    ) {
                                        PokemonCard(pokemon: pokemon)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                        }
                    }
                }
            }
            .navigationTitle("宝可梦图鉴 Pokémon Library")
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}

// 搜索栏视图
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("搜索宝可梦名称、属性或能力\nSearch by name, type or ability", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(10)
        .padding(.vertical, 8)
    }
}

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
            .previewDevice("iPhone 13")
            .previewDisplayName("iPhone 13")
    }
} 