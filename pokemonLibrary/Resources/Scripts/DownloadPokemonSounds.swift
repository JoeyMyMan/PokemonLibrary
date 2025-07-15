import Foundation

/*
 这个脚本用于下载宝可梦的音频文件
 使用方法：
 1. 在Xcode中运行此脚本
 2. 脚本会下载指定宝可梦的音频文件到Resources/Sounds目录
 */

class PokemonSoundDownloader {
    // 宝可梦ID和名称的映射
    static let pokemonData: [(id: Int, name: String)] = [
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

    // 创建Sounds目录
    static func createSoundsDirectory() -> URL? {
        guard let resourcePath = Bundle.main.resourcePath else {
            print("无法获取资源路径")
            return nil
        }
        
        let soundsDirectoryPath = resourcePath + "/Resources/Sounds"
        let fileManager = FileManager.default
        
        if !fileManager.fileExists(atPath: soundsDirectoryPath) {
            do {
                try fileManager.createDirectory(atPath: soundsDirectoryPath, withIntermediateDirectories: true)
                print("创建Sounds目录成功: \(soundsDirectoryPath)")
            } catch {
                print("创建Sounds目录失败: \(error.localizedDescription)")
                return nil
            }
        }
        
        return URL(fileURLWithPath: soundsDirectoryPath)
    }

    // 下载音频文件
    static func downloadPokemonSound(id: Int, name: String, to directory: URL) {
        let formattedId = String(format: "%03d", id)
        let fileName = "\(formattedId)_\(name).mp3"
        let destinationURL = directory.appendingPathComponent(fileName)
        
        // 检查文件是否已存在
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            print("音频文件已存在: \(fileName)")
            return
        }
        
        // 构建下载URL
        // 这里使用Pokemon Showdown的音频资源
        let urlString = "https://play.pokemonshowdown.com/audio/cries/\(name.lowercased()).mp3"
        guard let url = URL(string: urlString) else {
            print("无效的URL: \(urlString)")
            return
        }
        
        print("开始下载: \(urlString)")
        
        // 创建下载任务
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("下载失败: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("服务器响应错误")
                return
            }
            
            guard let data = data else {
                print("没有接收到数据")
                return
            }
            
            // 保存文件
            do {
                try data.write(to: destinationURL)
                print("下载成功: \(fileName)")
            } catch {
                print("保存文件失败: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    // 主函数
    static func run() {
        print("开始下载宝可梦音频文件...")
        
        guard let soundsDirectory = createSoundsDirectory() else {
            print("无法创建Sounds目录，下载取消")
            return
        }
        
        // 下载所有宝可梦的音频
        for pokemon in pokemonData {
            downloadPokemonSound(id: pokemon.id, name: pokemon.name, to: soundsDirectory)
        }
        
        print("下载任务已启动，请等待下载完成...")
        
        // 等待所有下载完成
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 30))
        
        print("下载过程结束")
    }
}

// 如果你要在命令行环境下运行此脚本，取消下面这行的注释
// PokemonSoundDownloader.run() 