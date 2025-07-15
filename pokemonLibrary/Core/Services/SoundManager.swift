import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var cachedSoundPaths: [Int: String] = [:]
    
    private init() {
        // 初始化时扫描并缓存音频文件
        scanAndCacheSounds()
    }
    
    // 获取Documents目录
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // 扫描并缓存所有音频文件
    private func scanAndCacheSounds() {
        print("======= 扫描所有音频文件 =======")
        
        let fileManager = FileManager.default
        let resourcePath = Bundle.main.resourcePath ?? ""
        let soundsPath = "\(resourcePath)/Resources/Sounds"
        
        print("检查Sounds目录: \(soundsPath)")
        
        // 检查Sounds目录是否存在
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: soundsPath, isDirectory: &isDirectory), isDirectory.boolValue else {
            print("Sounds目录不存在或不是目录")
            return
        }
        
        do {
            // 获取所有文件
            let files = try fileManager.contentsOfDirectory(atPath: soundsPath)
            
            // 过滤音频文件
            let soundFiles = files.filter { $0.hasSuffix(".mp3") || $0.hasSuffix(".wav") }
            print("找到 \(soundFiles.count) 个音频文件")
            
            // 对每个宝可梦ID，优先使用WAV文件，其次是MP3文件
            let pokemonIdsWithWav = Set(soundFiles.filter { $0.hasSuffix(".wav") }
                .compactMap { extractPokemonId(from: $0) })
            
            // 缓存每个音频文件
            for soundFile in soundFiles {
                if let pokemonId = extractPokemonId(from: soundFile) {
                    let fullPath = "\(soundsPath)/\(soundFile)"
                    
                    // 如果是WAV文件或者该ID没有WAV文件，则缓存
                    if soundFile.hasSuffix(".wav") || !pokemonIdsWithWav.contains(pokemonId) {
                        print("缓存 ID \(pokemonId) 的音频路径: \(fullPath)")
                        cachedSoundPaths[pokemonId] = fullPath
                    }
                }
            }
            
            print("已缓存 \(cachedSoundPaths.count) 个音频文件路径")
        } catch {
            print("扫描Sounds目录失败: \(error.localizedDescription)")
        }
        
        print("======= 扫描完成 =======")
    }
    
    // 从文件名提取宝可梦ID
    private func extractPokemonId(from filename: String) -> Int? {
        // 文件名格式: 001_Bulbasaur.mp3 或 025_Pikachu.wav
        let components = filename.components(separatedBy: "_")
        if components.count >= 1, let idString = components.first, let id = Int(idString) {
            return id
        }
        return nil
    }
    
    // 获取音频文件路径
    func getSoundPath(for pokemonId: Int, name: String? = nil) -> String? {
        print("获取ID为 \(pokemonId) 的音频路径")
        
        // 检查缓存
        if let cachedPath = cachedSoundPaths[pokemonId] {
            print("从缓存中获取音频路径: \(cachedPath)")
            if FileManager.default.fileExists(atPath: cachedPath) {
                return cachedPath
            } else {
                print("缓存的路径不存在，尝试其他方法")
            }
        }
        
        // 如果缓存中没有，尝试查找文件
        let formattedId = String(format: "%03d", pokemonId)
        let pokemonName = getPokemonName(for: pokemonId) ?? name ?? "Pokemon"
        
        // 检查可能的路径 - 优先检查WAV文件
        let possiblePaths = [
            // Resources/Sounds目录 (.wav) - 优先WAV
            "\(Bundle.main.resourcePath!)/Resources/Sounds/\(formattedId)_\(pokemonName).wav",
            
            // Resources/Sounds目录 (.mp3)
            "\(Bundle.main.resourcePath!)/Resources/Sounds/\(formattedId)_\(pokemonName).mp3",
            
            // Bundle资源 (.wav) - 优先WAV
            Bundle.main.path(forResource: "\(formattedId)_\(pokemonName)", ofType: "wav"),
            
            // Bundle资源 (.mp3)
            Bundle.main.path(forResource: "\(formattedId)_\(pokemonName)", ofType: "mp3")
        ].compactMap { $0 }
        
        // 检查所有可能的路径
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path) {
                print("找到音频文件: \(path)")
                cachedSoundPaths[pokemonId] = path // 更新缓存
                return path
            }
        }
        
        print("无法找到ID为 \(pokemonId) 的音频文件")
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
        case 52: return "Meowth"
        case 94: return "Gengar"
        case 130: return "Gyarados"
        case 143: return "Snorlax"
        case 149: return "Dragonite"
        case 150: return "Mewtwo"
        default: return nil
        }
    }
    
    // 播放宝可梦音频
    func playPokemonSound(for pokemonId: Int, name: String? = nil) {
        // 停止当前正在播放的音频
        stopSound()
        
        // 获取音频路径
        guard let soundPath = getSoundPath(for: pokemonId, name: name) else {
            print("未找到ID为 \(pokemonId) 的音频文件")
            return
        }
        
        do {
            // 创建音频播放器
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundPath))
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("开始播放宝可梦音频: ID=\(pokemonId)")
        } catch {
            print("播放音频失败: \(error.localizedDescription)")
        }
    }
    
    // 直接通过宝可梦名称播放音频
    func playPokemonCry(name: String) {
        let pokemonMap: [String: Int] = [
            "Bulbasaur": 1,
            "Charmander": 4,
            "Charizard": 6,
            "Squirtle": 7,
            "Pikachu": 25,
            "Meowth": 52,
            "Gengar": 94,
            "Gyarados": 130,
            "Snorlax": 143,
            "Dragonite": 149,
            "Mewtwo": 150
        ]
        
        if let id = pokemonMap[name] {
            playPokemonSound(for: id, name: name)
        } else {
            print("未找到名称为 \(name) 的宝可梦")
        }
    }
    
    // 播放宝可梦叫声
    func playPokemonCry(pokemonId: Int) {
        playPokemonSound(for: pokemonId)
    }
    
    // 停止播放音频
    func stopSound() {
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            print("停止播放音频")
        }
    }
} 