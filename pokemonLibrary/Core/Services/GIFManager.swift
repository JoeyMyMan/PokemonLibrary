import Foundation
import UIKit

class GIFManager {
    static let shared = GIFManager()
    private var didInitialSetup = false
    private var cachedGIFPaths: [Int: String] = [:]
    
    private init() {
        // 在应用启动时复制GIF文件到Documents目录
        setupGIFs()
    }
    
    // 获取Documents目录
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // 设置GIF文件
    func setupGIFs() {
        if didInitialSetup {
            return
        }
        
        print("开始设置GIF文件...")
        copyAllGIFsToDocuments()
        didInitialSetup = true
        
        // 扫描并缓存所有GIF文件
        scanAndCacheAllGIFs()
    }
    
    // 扫描并缓存所有GIF文件
    private func scanAndCacheAllGIFs() {
        print("======= 扫描所有GIF文件 =======")
        
        let fileManager = FileManager.default
        let resourcePath = Bundle.main.resourcePath ?? ""
        let resourcesPath = "\(resourcePath)/Resources"
        
        print("检查Resources目录: \(resourcesPath)")
        
        // 检查Resources目录是否存在
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: resourcesPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            print("Resources目录不存在或不是目录")
            return
        }
        
        do {
            // 获取所有文件
            let files = try fileManager.contentsOfDirectory(atPath: resourcesPath)
            
            // 过滤GIF文件
            let gifFiles = files.filter { $0.hasSuffix("_Anim.gif") }
            print("找到 \(gifFiles.count) 个GIF文件")
            
            // 缓存每个GIF文件
            for gifFile in gifFiles {
                let fullPath = "\(resourcesPath)/\(gifFile)"
                if let pokemonId = extractPokemonId(from: gifFile) {
                    print("缓存 ID \(pokemonId) 的GIF路径: \(fullPath)")
                    cachedGIFPaths[pokemonId] = fullPath
                }
            }
            
            print("已缓存 \(cachedGIFPaths.count) 个GIF文件路径")
        } catch {
            print("扫描Resources目录失败: \(error.localizedDescription)")
        }
        
        print("======= 扫描完成 =======")
    }
    
    // 复制所有GIF文件到Documents目录
    func copyAllGIFsToDocuments() {
        let fileManager = FileManager.default
        
        print("开始复制所有GIF文件...")
        print("Documents目录: \(documentsDirectory.path)")
        
        // 获取Bundle中的资源路径
        guard let resourcesPath = Bundle.main.resourcePath else {
            print("无法获取资源路径")
            return
        }
        
        print("资源路径: \(resourcesPath)")
        
        // 获取Resources目录中的所有文件
        let resourcesDirectory = "\(resourcesPath)/Resources"
        print("尝试读取目录: \(resourcesDirectory)")
        
        do {
            let resourceFiles = try fileManager.contentsOfDirectory(atPath: resourcesDirectory)
            
            // 过滤出GIF文件
            let gifFiles = resourceFiles.filter { $0.hasSuffix("_Anim.gif") }
            
            print("找到\(gifFiles.count)个GIF文件: \(gifFiles)")
            
            // 复制每个GIF文件到Documents目录
            for gifFile in gifFiles {
                let sourcePath = "\(resourcesDirectory)/\(gifFile)"
                let targetPath = documentsDirectory.appendingPathComponent(gifFile).path
                
                print("准备复制: \(gifFile)")
                
                // 如果目标文件已存在，先删除
                if fileManager.fileExists(atPath: targetPath) {
                    do {
                        try fileManager.removeItem(atPath: targetPath)
                    } catch {
                        print("删除旧GIF文件失败: \(error.localizedDescription)")
                    }
                }
                
                // 复制文件
                do {
                    try fileManager.copyItem(atPath: sourcePath, toPath: targetPath)
                    print("成功复制GIF文件: \(gifFile)")
                    
                    // 尝试从文件名解析宝可梦ID
                    if let pokemonId = extractPokemonId(from: gifFile) {
                        print("为ID \(pokemonId) 缓存路径: \(targetPath)")
                        cachedGIFPaths[pokemonId] = targetPath
                    }
                } catch {
                    print("复制GIF文件失败: \(error.localizedDescription)")
                }
            }
        } catch {
            print("读取Resources目录失败: \(error.localizedDescription)")
            print("错误详情: \(error)")
            
            // 如果无法读取目录，尝试复制已知的GIF文件
            copySpecificGIFs()
        }
    }
    
    // 复制特定的GIF文件（作为备选方案）
    private func copySpecificGIFs() {
        print("尝试复制特定的GIF文件...")
        
        // 所有宝可梦ID和名称
        let pokemonData = [
            (id: 1, name: "Bulbasaur"),
            (id: 4, name: "Charmander"),
            (id: 6, name: "Charizard"),
            (id: 7, name: "Squirtle"),
            (id: 25, name: "Pikachu"),
            (id: 94, name: "Gengar"),
            (id: 130, name: "Gyarados"),
            (id: 143, name: "Snorlax"),
            (id: 149, name: "Dragonite"),
            (id: 150, name: "Mewtwo")
        ]
        
        // 复制每个宝可梦的GIF
        for pokemon in pokemonData {
            copyGIFFile(id: pokemon.id, name: pokemon.name)
        }
    }
    
    // 复制单个GIF文件
    private func copyGIFFile(id: Int, name: String) {
        let fileManager = FileManager.default
        let formattedId = String(format: "%03d", id)
        let fileName = "\(formattedId)_\(name)_Anim.gif"
        
        print("尝试复制特定GIF: \(fileName)")
        
        // 尝试不同的路径查找GIF文件
        let possiblePaths = [
            // 通过Bundle查找
            Bundle.main.path(forResource: "\(formattedId)_\(name)_Anim", ofType: "gif"),
            
            // 通过具体路径查找
            "\(Bundle.main.resourcePath!)/\(fileName)",
            "\(Bundle.main.resourcePath!)/Resources/\(fileName)",
            
            // 硬编码路径
            "/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Resources/\(fileName)"
        ].compactMap { $0 }
        
        var foundPath: String? = nil
        
        // 检查所有可能的路径
        for path in possiblePaths {
            print("检查路径: \(path)")
            if fileManager.fileExists(atPath: path) {
                print("找到GIF文件: \(path)")
                foundPath = path
                break
            }
        }
        
        // 如果找到文件，复制到Documents目录
        if let sourcePath = foundPath {
            let targetPath = documentsDirectory.appendingPathComponent(fileName).path
            
            // 如果目标文件已存在，先删除
            if fileManager.fileExists(atPath: targetPath) {
                do {
                    try fileManager.removeItem(atPath: targetPath)
                } catch {
                    print("删除旧GIF文件失败: \(error.localizedDescription)")
                }
            }
            
            // 复制文件
            do {
                try fileManager.copyItem(atPath: sourcePath, toPath: targetPath)
                print("成功复制GIF文件: \(fileName)")
                cachedGIFPaths[id] = targetPath
            } catch {
                print("复制GIF文件失败: \(error.localizedDescription)")
            }
        } else {
            print("无法找到GIF文件: \(fileName)")
        }
    }
    
    // 从文件名提取宝可梦ID
    private func extractPokemonId(from filename: String) -> Int? {
        // 文件名格式: 001_Bulbasaur_Anim.gif 或 025_Pikachu_Anim.gif
        let components = filename.components(separatedBy: "_")
        if components.count >= 1, let idString = components.first, let id = Int(idString) {
            return id
        }
        return nil
    }
    
    // 获取GIF文件路径
    func getGIFPath(for pokemonId: Int, name: String? = nil) -> String? {
        // 确保初始化已完成
        if !didInitialSetup {
            setupGIFs()
        }
        
        print("获取ID为 \(pokemonId) 的GIF路径")
        
        // 检查缓存
        if let cachedPath = cachedGIFPaths[pokemonId] {
            print("从缓存中获取GIF路径: \(cachedPath)")
            if FileManager.default.fileExists(atPath: cachedPath) {
                return cachedPath
            } else {
                print("缓存的路径不存在，尝试其他方法")
            }
        }
        
        // 如果缓存中没有，尝试查找文件
        let formattedId = String(format: "%03d", pokemonId)
        let pokemonName = getPokemonName(for: pokemonId) ?? name ?? "Pokemon"
        
        // 检查可能的路径
        let possiblePaths = [
            // Resources目录
            "\(Bundle.main.resourcePath!)/Resources/\(formattedId)_\(pokemonName)_Anim.gif",
            
            // Bundle资源
            Bundle.main.path(forResource: "\(formattedId)_\(pokemonName)_Anim", ofType: "gif"),
            
            // Documents目录
            documentsDirectory.appendingPathComponent("\(formattedId)_\(pokemonName)_Anim.gif").path
        ].compactMap { $0 }
        
        // 检查所有可能的路径
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path) {
                print("找到GIF文件: \(path)")
                cachedGIFPaths[pokemonId] = path // 更新缓存
                return path
            }
        }
        
        print("无法找到ID为 \(pokemonId) 的GIF文件")
        return nil
    }
    
    // 根据ID获取宝可梦英文名
    private func getPokemonName(for id: Int) -> String? {
        switch id {
        case 1: return "Bulbasaur"
        case 4: return "Charmander"
        case 6: return "Charizard"
        case 7: return "Squirtle"
        case 25: return "Pikachu"
        case 94: return "Gengar"
        case 130: return "Gyarados"
        case 143: return "Snorlax"
        case 149: return "Dragonite"
        case 150: return "Mewtwo"
        default: return nil
        }
    }
    
    // 获取所有可用的宝可梦GIF
    func getAllAvailableGIFs() -> [(id: Int, name: String, path: String)] {
        // 确保初始化已完成
        if !didInitialSetup {
            setupGIFs()
        }
        
        var result: [(id: Int, name: String, path: String)] = []
        
        // 扫描Resources目录
        if let resourcePath = Bundle.main.resourcePath {
            let resourcesPath = "\(resourcePath)/Resources"
            
            do {
                let files = try FileManager.default.contentsOfDirectory(atPath: resourcesPath)
                let gifFiles = files.filter { $0.hasSuffix("_Anim.gif") }
                
                for gifFile in gifFiles {
                    if let id = extractPokemonId(from: gifFile) {
                        let components = gifFile.components(separatedBy: "_")
                        let name = components.count > 1 ? components[1] : "Unknown"
                        let path = "\(resourcesPath)/\(gifFile)"
                        
                        result.append((id: id, name: name, path: path))
                    }
                }
            } catch {
                print("读取Resources目录失败: \(error.localizedDescription)")
            }
        }
        
        return result
    }
} 