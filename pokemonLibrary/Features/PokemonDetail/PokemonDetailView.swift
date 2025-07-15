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
                    Text("😢 出错了 Error")
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
                            // Pokemon GIF动画
                            pokemonAnimationView(for: pokemon)
                                .frame(width: 300, height: 300)
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
                            
                            // 播放声音按钮
                            Button(action: {
                                viewModel.playPokemonSound()
                            }) {
                                Label("播放叫声 Play Cry", systemImage: "speaker.wave.2.fill")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                            .padding(.top, 8)
                        }
                        .padding(.bottom)
                        
                        // 基本信息
                        VStack(alignment: .leading, spacing: 12) {
                            Text("基本信息 Basic Info")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            InfoRow(title: "身高 Height", value: pokemon.formattedHeight)
                            InfoRow(title: "体重 Weight", value: pokemon.formattedWeight)
                            InfoRow(title: "特性 Abilities", value: pokemon.abilities.joined(separator: ", "))
                        }
                        .padding()
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        
                        // 描述
                        VStack(alignment: .leading, spacing: 8) {
                            Text("描述 Description")
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
                            Text("能力值 Stats")
                                .font(.headline)
                                .padding(.bottom, 4)
                            
                            StatRow(title: "HP", value: pokemon.stats.hp, color: .green)
                            StatRow(title: "攻击 ATK", value: pokemon.stats.attack, color: .red)
                            StatRow(title: "防御 DEF", value: pokemon.stats.defense, color: .blue)
                            StatRow(title: "特攻 SP.ATK", value: pokemon.stats.specialAttack, color: .purple)
                            StatRow(title: "特防 SP.DEF", value: pokemon.stats.specialDefense, color: .cyan)
                            StatRow(title: "速度 SPD", value: pokemon.stats.speed, color: .yellow)
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
        .navigationTitle("详情 Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            // 检查GIF文件是否存在
            if let pokemon = viewModel.pokemon {
                print("检查宝可梦ID: \(pokemon.id) (\(pokemon.name)) 的GIF动画")
                if let gifPath = viewModel.getAnimationPath(for: pokemon.id) {
                    print("找到GIF路径: \(gifPath)")
                    
                    // 验证文件是否真的存在
                    if FileManager.default.fileExists(atPath: gifPath) {
                        print("GIF文件确实存在")
                    } else {
                        print("警告：找到的GIF路径实际上不存在！")
                    }
                } else {
                    print("未找到GIF路径")
                }
                
                // 特别检查小火龙
                if pokemon.id == 4 {
                    print("特别检查小火龙GIF")
                    let charmanderPath = "/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Resources/004_Charmander_Anim.gif"
                    if FileManager.default.fileExists(atPath: charmanderPath) {
                        print("小火龙GIF文件存在于原始路径")
                    } else {
                        print("小火龙GIF文件不存在于原始路径")
                    }
                }
            }
        }
        .onDisappear {
            // 离开页面时停止音频播放
            SoundManager.shared.stopSound()
        }
    }
    
    // 根据宝可梦ID返回对应的动画视图
    private func pokemonAnimationView(for pokemon: Pokemon) -> some View {
        print("创建宝可梦动画视图: ID=\(pokemon.id), 名称=\(pokemon.name)")
        
        // 小火龙特殊处理
        if pokemon.id == 4 {
            print("尝试特殊处理小火龙GIF")
            let charmanderPath = "/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Resources/004_Charmander_Anim.gif"
            
            if FileManager.default.fileExists(atPath: charmanderPath) {
                print("小火龙GIF文件存在，尝试创建GIF视图")
                if let gifView = GIFImageView.fileGIF(path: charmanderPath, loopCount: 0) {
                    print("成功创建小火龙GIF视图")
                    return AnyView(
                        gifView
                            .aspectRatio(.scaleAspectFit)
                            .frame(width: 250, height: 250)
                    )
                } else {
                    print("创建小火龙GIF视图失败")
                }
            } else {
                print("小火龙GIF文件不存在于路径: \(charmanderPath)")
            }
        }
        
        // 获取动画GIF路径
        if let gifPath = viewModel.getAnimationPath(for: pokemon.id) {
            print("尝试加载GIF动画: \(gifPath)")
            
            // 确保文件确实存在
            guard FileManager.default.fileExists(atPath: gifPath) else {
                print("文件不存在，使用静态图片替代")
                return AnyView(
                    PokemonImageView(pokemon: pokemon, height: 200)
                        .padding()
                )
            }
            
            // 尝试创建GIF视图
            if let gifView = GIFImageView.fileGIF(path: gifPath, loopCount: 0) {
                print("GIF视图创建成功")
                return AnyView(
                    gifView
                        .aspectRatio(.scaleAspectFit)
                        .frame(width: 250, height: 250)
                )
            } else {
                print("GIF视图创建失败，使用静态图片替代")
                return AnyView(
                    PokemonImageView(pokemon: pokemon, height: 200)
                )
            }
        } else {
            print("未找到GIF路径，使用静态图片")
            
            // GIF不存在时显示静态图片
            return AnyView(
                PokemonImageView(pokemon: pokemon, height: 200)
            )
        }
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
                .frame(width: 100, alignment: .leading)
            
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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(value)")
                    .font(.subheadline)
                    .bold()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 6)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * CGFloat(min(Double(value) / 255.0, 1.0)), height: 6)
                        .foregroundColor(color)
                }
            }
            .frame(height: 6)
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