import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    // 旧的音频播放器（备用）
    private var audioPlayer: AVAudioPlayer?
    
    // 音频引擎组件
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var pitchControl: AVAudioUnitTimePitch?
    private var currentBuffer: AVAudioPCMBuffer?
    
    private var cachedSoundPaths: [Int: String] = [:]
    
    // 音频播放参数
    private let playbackRate: Float = 0.8  // 播放速度 (0.5 = 半速, 1.0 = 正常速度)
    private let playbackPitch: Float = -300  // 音调调整 (负值降低音调，正值提高音调)
    
    private init() {
        // 初始化时扫描并缓存音频文件
        scanAndCacheSounds()
        // 设置音频会话
        setupAudioSession()
        // 初始化音频引擎
        setupAudioEngine()
    }
    
    // 设置音频会话
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("设置音频会话失败: \(error.localizedDescription)")
        }
    }
    
    // 设置音频引擎
    private func setupAudioEngine() {
        // 创建音频引擎和组件
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        pitchControl = AVAudioUnitTimePitch()
        
        // 设置初始音调和速度参数
        pitchControl?.pitch = playbackPitch
        pitchControl?.rate = playbackRate * 100 // AVAudioUnitTimePitch中的rate单位是百分比
        
        // 连接音频组件
        if let engine = audioEngine, let playerNode = audioPlayerNode, let pitch = pitchControl {
            engine.attach(playerNode)
            engine.attach(pitch)
            
            // 构建处理链: 播放节点 -> 音调控制 -> 输出
            engine.connect(playerNode, to: pitch, format: nil)
            engine.connect(pitch, to: engine.mainMixerNode, format: nil)
            
            // 准备引擎
            do {
                try engine.start()
                print("音频引擎初始化成功")
            } catch {
                print("启动音频引擎失败: \(error.localizedDescription)")
            }
        }
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
            
            // 缓存每个音频文件
            for soundFile in soundFiles {
                let fullPath = "\(soundsPath)/\(soundFile)"
                if let pokemonId = extractPokemonId(from: soundFile) {
                    print("缓存 ID \(pokemonId) 的音频路径: \(fullPath)")
                    cachedSoundPaths[pokemonId] = fullPath
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
        
        // 检查可能的路径
        let possiblePaths = [
            // Resources/Sounds目录 (.mp3)
            "\(Bundle.main.resourcePath!)/Resources/Sounds/\(formattedId)_\(pokemonName).mp3",
            
            // Resources/Sounds目录 (.wav)
            "\(Bundle.main.resourcePath!)/Resources/Sounds/\(formattedId)_\(pokemonName).wav",
            
            // Bundle资源 (.mp3)
            Bundle.main.path(forResource: "\(formattedId)_\(pokemonName)", ofType: "mp3"),
            
            // Bundle资源 (.wav)
            Bundle.main.path(forResource: "\(formattedId)_\(pokemonName)", ofType: "wav")
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
        
        // 使用音频引擎播放带有音调调整的音频
        playWithAudioEngine(path: soundPath)
    }
    
    // 使用音频引擎播放并处理音频
    private func playWithAudioEngine(path: String) {
        guard let engine = audioEngine, let playerNode = audioPlayerNode, let pitch = pitchControl else {
            print("音频引擎未初始化")
            return
        }
        
        do {
            // 准备音频文件
            let audioFile = try AVAudioFile(forReading: URL(fileURLWithPath: path))
            let format = audioFile.processingFormat
            
            // 创建音频缓冲区
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(audioFile.length)) else {
                print("无法创建音频缓冲区")
                return
            }
            
            // 加载音频数据
            try audioFile.read(into: buffer)
            currentBuffer = buffer
            
            // 确保引擎正在运行
            if !engine.isRunning {
                try engine.start()
            }
            
            // 设置音调和速度
            pitch.pitch = playbackPitch
            pitch.rate = playbackRate * 100
            
            // 停止之前的播放
            if playerNode.isPlaying {
                playerNode.stop()
            }
            
            // 播放音频
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            playerNode.play()
            
            print("开始播放宝可梦音频（音调调整）: 速度=\(playbackRate), 音调调整=\(playbackPitch)")
        } catch {
            print("播放音频失败: \(error.localizedDescription)")
            
            // 如果音频引擎播放失败，尝试使用备用方法
            playWithAVAudioPlayer(path: path)
        }
    }
    
    // 使用AVAudioPlayer作为备用播放方法
    private func playWithAVAudioPlayer(path: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.enableRate = true
            audioPlayer?.rate = playbackRate
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            print("使用备用方法播放音频（只能调整速度）: 速度=\(playbackRate)")
        } catch {
            print("备用播放方法失败: \(error.localizedDescription)")
        }
    }
    
    // 停止播放音频
    func stopSound() {
        // 停止音频引擎播放
        if let playerNode = audioPlayerNode, playerNode.isPlaying {
            playerNode.stop()
            print("停止音频引擎播放")
        }
        
        // 停止备用播放器
        if let player = audioPlayer, player.isPlaying {
            player.stop()
            print("停止备用播放器")
        }
    }
    
    // 调整音调
    func adjustPitch(to pitch: Float) {
        pitchControl?.pitch = pitch
        print("调整音调为: \(pitch)")
    }
    
    // 调整播放速度
    func adjustRate(to rate: Float) {
        pitchControl?.rate = rate * 100
        print("调整播放速度为: \(rate)")
    }
} 