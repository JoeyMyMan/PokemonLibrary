import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var soundExtension: String = "wav" // 默认音频扩展名
    
    private init() {
        // 检查音频文件是否存在，如果不存在wav文件但存在mp3文件，则使用mp3
        if !fileExists(name: "001_Bulbasaur", fileExtension: "wav") && 
           fileExists(name: "001_Bulbasaur", fileExtension: "mp3") {
            soundExtension = "mp3"
        }
    }
    
    /// 播放宝可梦叫声
    /// - Parameter pokemonId: 宝可梦的ID，例如1代表妙蛙种子
    /// - Returns: 是否成功播放
    func playPokemonCry(pokemonId: Int) -> Bool {
        // 格式化ID为3位数
        let formattedId = String(format: "%03d", pokemonId)
        
        // 查找对应的音频文件
        guard let pokemon = getPokemonName(for: formattedId) else {
            print("未找到ID为\(formattedId)的宝可梦")
            return false
        }
        
        let fileName = "\(formattedId)_\(pokemon)"
        return playSound(name: fileName)
    }
    
    /// 根据宝可梦名称播放叫声
    /// - Parameter name: 宝可梦的名称，例如"Bulbasaur"
    /// - Returns: 是否成功播放
    func playPokemonCry(name: String) -> Bool {
        guard let id = getPokemonId(for: name) else {
            print("未找到名称为\(name)的宝可梦")
            return false
        }
        
        let formattedId = String(format: "%03d", id)
        let fileName = "\(formattedId)_\(name)"
        return playSound(name: fileName)
    }
    
    /// 停止所有正在播放的音效
    func stopAllSounds() {
        for (_, player) in audioPlayers {
            player.stop()
        }
        audioPlayers.removeAll()
    }
    
    // MARK: - 私有辅助方法
    
    private func playSound(name: String) -> Bool {
        // 如果已经有这个音频正在播放，先停止
        if let existingPlayer = audioPlayers[name] {
            existingPlayer.stop()
            audioPlayers.removeValue(forKey: name)
        }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: soundExtension, subdirectory: "Resources/Sounds") else {
            print("找不到音频文件：\(name).\(soundExtension)")
            return false
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
            
            // 存储播放器引用，防止被ARC回收
            audioPlayers[name] = player
            return true
        } catch {
            print("播放音频失败：\(error.localizedDescription)")
            return false
        }
    }
    
    private func fileExists(name: String, fileExtension: String) -> Bool {
        Bundle.main.url(forResource: name, withExtension: fileExtension, subdirectory: "Resources/Sounds") != nil
    }
    
    // 宝可梦ID和名称映射
    private func getPokemonName(for id: String) -> String? {
        let pokemonMap: [String: String] = [
            "001": "Bulbasaur",
            "004": "Charmander",
            "006": "Charizard",
            "007": "Squirtle",
            "025": "Pikachu",
            "052": "Meowth",
            "094": "Gengar",
            "130": "Gyarados",
            "143": "Snorlax",
            "149": "Dragonite",
            "150": "Mewtwo"
        ]
        
        return pokemonMap[id]
    }
    
    // 宝可梦名称和ID映射
    private func getPokemonId(for name: String) -> Int? {
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
        
        return pokemonMap[name]
    }
} 