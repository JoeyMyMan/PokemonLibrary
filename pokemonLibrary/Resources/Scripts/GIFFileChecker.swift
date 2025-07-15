import Foundation
import UIKit

/// GIF文件检查工具类
class GIFFileChecker {
    
    /// 单例实例
    static let shared = GIFFileChecker()
    
    /// 私有初始化方法
    private init() {}
    
    /// 检查GIF文件是否存在并可用
    /// - Parameter pokemonId: 宝可梦ID
    /// - Returns: 检查结果描述
    func checkGIFFile(for pokemonId: Int) -> String {
        let formattedId = String(format: "%03d", pokemonId)
        var result = "检查ID为\(pokemonId)的宝可梦GIF文件:\n"
        
        // 检查可能的路径
        let possiblePaths = [
            // Bundle资源路径
            Bundle.main.path(forResource: "\(formattedId)_\(getPokemonName(for: pokemonId))_Anim", ofType: "gif"),
            
            // Resources目录
            Bundle.main.resourcePath?.appending("/Resources/\(formattedId)_\(getPokemonName(for: pokemonId))_Anim.gif"),
            
            // 硬编码路径
            "/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Resources/\(formattedId)_\(getPokemonName(for: pokemonId))_Anim.gif"
        ].compactMap { $0 }
        
        result += "\n检查\(possiblePaths.count)个可能的路径:"
        
        var foundPath: String? = nil
        
        // 检查所有可能的路径
        for (index, path) in possiblePaths.enumerated() {
            result += "\n[\(index + 1)] 路径: \(path)"
            
            if FileManager.default.fileExists(atPath: path) {
                result += " ✅ 文件存在"
                
                // 检查文件大小
                if let attributes = try? FileManager.default.attributesOfItem(atPath: path),
                   let fileSize = attributes[.size] as? UInt64 {
                    result += " (大小: \(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)))"
                }
                
                foundPath = path
            } else {
                result += " ❌ 文件不存在"
            }
        }
        
        // 检查是否在Bundle中
        if let _ = Bundle.main.path(forResource: "\(formattedId)_\(getPokemonName(for: pokemonId))_Anim", ofType: "gif") {
            result += "\n\n✅ GIF文件已添加到应用Bundle中"
        } else {
            result += "\n\n❌ GIF文件未添加到应用Bundle中"
            result += "\n请在Xcode中手动添加文件到项目中:"
            result += "\n1. 右键点击Resources文件夹"
            result += "\n2. 选择'Add Files to \"pokemonLibrary\"...'"
            result += "\n3. 选择GIF文件"
            result += "\n4. 确保勾选'Copy items if needed'和'Add to targets: pokemonLibrary'"
        }
        
        // 尝试创建GIF视图
        if let path = foundPath {
            let url = URL(fileURLWithPath: path)
            do {
                let gifData = try Data(contentsOf: url)
                if let source = CGImageSourceCreateWithData(gifData as CFData, nil) {
                    let frameCount = CGImageSourceGetCount(source)
                    result += "\n\n✅ GIF文件有效，包含\(frameCount)帧"
                } else {
                    result += "\n\n❌ GIF文件无效，无法创建图像源"
                }
            } catch {
                result += "\n\n❌ 无法读取GIF数据: \(error.localizedDescription)"
            }
        }
        
        return result
    }
    
    /// 检查所有GIF文件
    /// - Returns: 检查结果描述
    func checkAllGIFFiles() -> String {
        var result = "检查所有宝可梦GIF文件:\n"
        
        // 检查所有宝可梦
        let pokemonIds = [1, 4, 6, 7, 25, 94, 130, 143, 149, 150]
        
        for id in pokemonIds {
            let formattedId = String(format: "%03d", id)
            let pokemonName = getPokemonName(for: id)
            let fileName = "\(formattedId)_\(pokemonName)_Anim.gif"
            
            // Resources目录路径
            let resourcePath = "\(Bundle.main.resourcePath!)/Resources/\(fileName)"
            let exists = FileManager.default.fileExists(atPath: resourcePath)
            
            result += "\n#\(id) \(pokemonName): \(exists ? "✅ 存在" : "❌ 不存在")"
        }
        
        // 检查GIFManager中可用的GIF
        result += "\n\nGIFManager可用的GIF:\n"
        let availableGIFs = GIFManager.shared.getAllAvailableGIFs()
        
        if availableGIFs.isEmpty {
            result += "没有找到可用的GIF\n"
        } else {
            for gif in availableGIFs {
                result += "#\(gif.id) \(gif.name): ✅ \(gif.path)\n"
            }
        }
        
        return result
    }
    
    /// 根据ID获取宝可梦名称
    /// - Parameter id: 宝可梦ID
    /// - Returns: 英文名称
    private func getPokemonName(for id: Int) -> String {
        switch id {
        case 1: return "Bulbasaur"
        case 4: return "Charmander"
        case 6: return "Charizard"
        case 7: return "Squirtle"
        case 25: return "Pikachu"
        case 52: return "Meowth"
        case 94: return "Gengar"
        case 130: return "Gyarados"
        case 143: return "Snorlax"
        case 149: return "Dragonite"
        case 150: return "Mewtwo"
        default: return "Pokemon"
        }
    }
} 