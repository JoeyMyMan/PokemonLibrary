import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    
    init(pokemonId: Int) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemonId: pokemonId))
    }
    
    var body: some View {
        ZStack {
            // 背景颜色
            if let pokemon = viewModel.pokemon, let firstType = pokemon.types.first {
                Color.forType(firstType).opacity(0.1)
                    .ignoresSafeArea()
            } else {
                Color.secondary.opacity(0.1)
                    .ignoresSafeArea()
            }
            
            if viewModel.isLoading {
                // 加载指示器
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage {
                // 错误信息
                VStack {
                    Text("😢 出错了")
                        .font(.title)
                        .padding(.bottom)
                    
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else if let pokemon = viewModel.pokemon {
                ScrollView {
                    VStack(spacing: 16) {
                        // 头部信息
                        VStack(alignment: .center) {
                            // Pokemon图片
                            PokemonImageView(pokemon: pokemon, height: 200)
                                .padding()
                            
                            // ID和名字
                            HStack {
                                Text("#\(String(format: "%03d", pokemon.id))")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Text(pokemon.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                            }
                            
                            // 类型标签
                            HStack(spacing: 10) {
                                ForEach(pokemon.types, id: \.self) { type in
                                    Text(type.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.forType(type))
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.top, 4)
                        }
                        .padding(.bottom)
                        
                        // 基本信息
                        VStack(alignment: .leading, spacing: 12) {
                            Text("基本信息")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            InfoRow(title: "身高", value: pokemon.formattedHeight)
                            InfoRow(title: "体重", value: pokemon.formattedWeight)
                            InfoRow(title: "特性", value: pokemon.abilities.joined(separator: ", "))
                        }
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // 描述
                        VStack(alignment: .leading, spacing: 8) {
                            Text("描述")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            Text(pokemon.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // 能力值
                        VStack(alignment: .leading, spacing: 12) {
                            Text("能力值")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            StatRow(title: "HP", value: pokemon.stats.hp, color: .green)
                            StatRow(title: "攻击", value: pokemon.stats.attack, color: .red)
                            StatRow(title: "防御", value: pokemon.stats.defense, color: .blue)
                            StatRow(title: "特攻", value: pokemon.stats.specialAttack, color: .purple)
                            StatRow(title: "特防", value: pokemon.stats.specialDefense, color: .cyan)
                            StatRow(title: "速度", value: pokemon.stats.speed, color: .yellow)
                        }
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("详情")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// 信息行视图
struct InfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

// 属性行视图
struct StatRow: View {
    var title: String
    var value: Int
    var color: Color
    
    @StateObject private var viewModel = PokemonDetailViewModel()
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .leading)
            
            Text("\(value)")
                .font(.subheadline)
                .frame(width: 40, alignment: .trailing)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.1)
                        .foregroundColor(color)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(viewModel.getStatPercentage(for: value)) * geometry.size.width, geometry.size.width), height: 8)
                        .foregroundColor(color)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PokemonDetailView(pokemonId: 25)
        }
        .previewDevice("iPhone 13")
        .previewDisplayName("iPhone 13")
    }
} 