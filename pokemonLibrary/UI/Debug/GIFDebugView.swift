import SwiftUI

struct GIFDebugView: View {
    @State private var debugInfo: String = "加载中..."
    @State private var selectedPokemonId: Int = 4 // 默认选择小火龙
    
    let availablePokemon = [
        (id: 1, name: "妙蛙种子 Bulbasaur"),
        (id: 4, name: "小火龙 Charmander"),
        (id: 6, name: "喷火龙 Charizard"),
        (id: 7, name: "杰尼龟 Squirtle"),
        (id: 25, name: "皮卡丘 Pikachu"),
        (id: 52, name: "喵喵 Meowth"),
        (id: 94, name: "耿鬼 Gengar"),
        (id: 130, name: "暴鲤龙 Gyarados"),
        (id: 143, name: "卡比兽 Snorlax"),
        (id: 149, name: "快龙 Dragonite"),
        (id: 150, name: "超梦 Mewtwo")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("GIF文件调试工具")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                // 选择宝可梦
                Picker("选择宝可梦", selection: $selectedPokemonId) {
                    ForEach(availablePokemon, id: \.id) { pokemon in
                        Text("\(pokemon.name) (#\(pokemon.id))").tag(pokemon.id)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedPokemonId) { _, _ in
                    checkSelectedPokemon()
                }
                
                // 检查按钮
                Button(action: {
                    checkSelectedPokemon()
                }) {
                    Text("检查GIF文件")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // 检查所有按钮
                Button(action: {
                    checkAllPokemon()
                }) {
                    Text("检查所有宝可梦GIF")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                // 调试信息
                Text("调试信息")
                    .font(.headline)
                    .padding(.top)
                
                Text(debugInfo)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(8)
                
                // 解决方案
                VStack(alignment: .leading, spacing: 10) {
                    Text("解决方案")
                        .font(.headline)
                    
                    Text("1. 确保GIF文件放在正确位置: pokemonLibrary/Resources/")
                    Text("2. 在Xcode中右键点击Resources文件夹")
                    Text("3. 选择'Add Files to \"pokemonLibrary\"...'")
                    Text("4. 选择GIF文件")
                    Text("5. 确保勾选'Copy items if needed'和'Add to targets: pokemonLibrary'")
                    Text("6. 重新构建应用")
                }
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
                
                // 显示选中宝可梦的GIF（如果存在）
                if let gifPath = getGIFPath(for: selectedPokemonId),
                   let gifView = GIFImageView.fileGIF(path: gifPath, loopCount: 0) {
                    VStack {
                        Text("预览")
                            .font(.headline)
                        
                        gifView
                            .aspectRatio(.scaleAspectFit)
                            .frame(width: 200, height: 200)
                    }
                    .padding()
                }
            }
            .padding()
        }
        .onAppear {
            checkSelectedPokemon()
        }
    }
    
    // 检查选中的宝可梦
    private func checkSelectedPokemon() {
        debugInfo = "正在检查宝可梦 #\(selectedPokemonId)..."
        
        // 在后台线程执行检查
        DispatchQueue.global().async {
            let result = GIFFileChecker.shared.checkGIFFile(for: selectedPokemonId)
            
            DispatchQueue.main.async {
                debugInfo = result
            }
        }
    }
    
    // 检查所有宝可梦
    private func checkAllPokemon() {
        debugInfo = "正在检查所有宝可梦..."
        
        // 在后台线程执行检查
        DispatchQueue.global().async {
            let result = GIFFileChecker.shared.checkAllGIFFiles()
            
            DispatchQueue.main.async {
                debugInfo = result
            }
        }
    }
    
    // 获取GIF路径
    private func getGIFPath(for pokemonId: Int) -> String? {
        return GIFManager.shared.getGIFPath(for: pokemonId)
    }
} 