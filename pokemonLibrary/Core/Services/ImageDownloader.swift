import SwiftUI
import Combine

class ImageDownloader: ObservableObject {
    static let shared = ImageDownloader()
    
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    func downloadImages() {
        // 示例Pokemon数据，实际项目中应从后端获取
        isLoading = true
        
        // 模拟网络加载延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
}

// 创建一个自定义图片加载视图
struct PokemonImageView: View {
    let pokemon: Pokemon
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    @State private var imageLoadError: Bool = false
    
    // 检查图片是否存在于Assets中
    private func imageExists(named imageName: String) -> Bool {
        #if DEBUG
        print("尝试加载图片: \(imageName)")
        #endif
        
        #if os(iOS) || os(tvOS)
        let exists = UIImage(named: imageName) != nil
        #if DEBUG
        print("图片\(exists ? "存在" : "不存在")")
        #endif
        return exists
        #elseif os(macOS)
        let exists = NSImage(named: imageName) != nil
        #if DEBUG
        print("图片\(exists ? "存在" : "不存在")")
        #endif
        return exists
        #else
        return false
        #endif
    }
    
    var body: some View {
        Group {
            if !imageLoadError && imageExists(named: pokemon.localImageName) {
                // 从Assets加载图片
                Image(pokemon.localImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.forType(pokemon.types.first ?? .normal).opacity(0.2))
                    )
                    .onAppear {
                        #if DEBUG
                        print("成功加载图片: \(pokemon.localImageName)")
                        #endif
                    }
            } else {
                // 使用系统图标作为备用
                Image(systemName: pokemon.systemIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .foregroundColor(Color.forType(pokemon.types.first ?? .normal))
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.forType(pokemon.types.first ?? .normal).opacity(0.2))
                    )
                    .onAppear {
                        #if DEBUG
                        print("使用备用图标: \(pokemon.systemIconName) 代替 \(pokemon.localImageName)")
                        #endif
                    }
            }
        }
        .onAppear {
            // 在视图出现时检查图片是否存在
            imageLoadError = !imageExists(named: pokemon.localImageName)
        }
    }
} 