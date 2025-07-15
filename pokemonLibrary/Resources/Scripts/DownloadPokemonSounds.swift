import Foundation

class PokemonSoundDownloader {
    private let baseURL = "https://play.pokemonshowdown.com/audio/cries/src/"
    private let destinationFolder: URL
    
    // 要下载的宝可梦列表及其ID
    private let pokemonList: [(id: Int, name: String)] = [
        (1, "Bulbasaur"),
        (4, "Charmander"),
        (6, "Charizard"),
        (7, "Squirtle"),
        (25, "Pikachu"),
        (52, "Meowth"),
        (94, "Gengar"),
        (130, "Gyarados"),
        (143, "Snorlax"),
        (149, "Dragonite"),
        (150, "Mewtwo")
    ]
    
    init() {
        // 获取项目Resources/Sounds目录
        let fileManager = FileManager.default
        let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
        
        // 创建Resources/Sounds目录路径
        let soundsDirectoryPath = "pokemonLibrary/Resources/Sounds"
        destinationFolder = currentDirectoryURL.appendingPathComponent(soundsDirectoryPath)
        
        // 确保目录存在
        do {
            try fileManager.createDirectory(at: destinationFolder, 
                                           withIntermediateDirectories: true, 
                                           attributes: nil)
            print("目标目录已创建或已存在：\(destinationFolder.path)")
        } catch {
            print("创建目录失败：\(error.localizedDescription)")
        }
    }
    
    func downloadAllSounds() {
        print("开始下载宝可梦音效...")
        
        for pokemon in pokemonList {
            downloadSound(for: pokemon)
        }
        
        print("所有下载任务已初始化，请等待完成...")
    }
    
    private func downloadSound(for pokemon: (id: Int, name: String)) {
        // Pokemon Showdown使用小写名称
        let pokemonNameLowercase = pokemon.name.lowercased()
        let pokemonURLString = baseURL + pokemonNameLowercase + ".wav"
        
        guard let url = URL(string: pokemonURLString) else {
            print("无效的URL：\(pokemonURLString)")
            return
        }
        
        // 使用与现有文件相同的格式：ID_NAME.mp3
        let formattedId = String(format: "%03d", pokemon.id)
        let fileName = "\(formattedId)_\(pokemon.name).wav"
        let destinationURL = destinationFolder.appendingPathComponent(fileName)
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { tempFileURL, response, error in
            if let error = error {
                print("下载\(pokemon.name)失败：\(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let tempFileURL = tempFileURL else {
                print("下载\(pokemon.name)失败：服务器响应无效")
                return
            }
            
            do {
                // 如果目标文件已存在，先删除
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                
                try FileManager.default.moveItem(at: tempFileURL, to: destinationURL)
                print("✅ 成功下载\(pokemon.name)音效：\(fileName)")
            } catch {
                print("保存\(pokemon.name)音效失败：\(error.localizedDescription)")
            }
        }
        
        downloadTask.resume()
        print("开始下载 \(pokemon.name)...")
    }
    
    func run() {
        downloadAllSounds()
        
        // 保持程序运行以等待异步下载完成
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 60))
        print("下载脚本执行完毕")
    }
}

// 使用示例
let downloader = PokemonSoundDownloader()
downloader.run() 