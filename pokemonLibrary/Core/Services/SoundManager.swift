import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    // 音频引擎组件
    private var audioEngine: AVAudioEngine?
    private var audioPlayerNode: AVAudioPlayerNode?
    private var pitchControl: AVAudioUnitTimePitch?
    private var formatConverter: AVAudioConverter?
    
    // 备用播放器
    private var audioPlayer: AVAudioPlayer?
    
    private var cachedSoundPaths: [Int: String] = [:]
    
    // 音频播放参数
    private let playbackRate: Float = 0.8  // 播放速度 (0.5 = 半速, 1.0 = 正常速度)
    private let playbackPitch: Float = -300  // 音调调整 (负值降低音调，正值提高音调)
    
    private init() {
        setupAudioSession()
        setupAudioEngine()
        scanAndCacheSounds()
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
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        pitchControl = AVAudioUnitTimePitch()
        
        guard let engine = audioEngine, let playerNode = audioPlayerNode, let pitch = pitchControl else {
            print("无法初始化音频引擎组件")
            return
        }
        
        // 设置音调和速度参数
        pitch.pitch = playbackPitch
        pitch.rate = playbackRate * 100
        
        // 添加节点到引擎
        engine.attach(playerNode)
        engine.attach(pitch)
        
        // 注意：连接将在播放时动态建立
        
        // 启动引擎
        do {
            try engine.start()
            print("音频引擎初始化成功")
        } catch {
            print("启动音频引擎失败: \(error)")
        }
    }
    
    // 扫描并缓存所有音频文件路径
    private func scanAndCacheSounds() {
        print("======= 扫描所有音频文件 =======")
        
        let fileManager = FileManager.default
        let soundPaths = [
            // 主Bundle的Resources/Sounds目录
            "\(Bundle.main.resourcePath!)/Resources/Sounds",
            
            // 直接在Bundle根目录
            "\(Bundle.main.resourcePath!)"
        ]
        
        for soundsPath in soundPaths {
            print("检查Sounds目录: \(soundsPath)")
            
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: soundsPath, isDirectory: &isDirectory) && isDirectory.boolValue {
                do {
                    let files = try fileManager.contentsOfDirectory(atPath: soundsPath)
                    let soundFiles = files.filter { $0.hasSuffix(".mp3") || $0.hasSuffix(".wav") }
                    print("在 \(soundsPath) 找到 \(soundFiles.count) 个音频文件")
                    
                    for soundFile in soundFiles {
                        let fullPath = "\(soundsPath)/\(soundFile)"
                        if let pokemonId = extractPokemonId(from: soundFile) {
                            cachedSoundPaths[pokemonId] = fullPath
                            print("缓存 ID \(pokemonId) 的音频: \(soundFile)")
                        }
                    }
                } catch {
                    print("扫描目录失败 \(soundsPath): \(error)")
                }
            } else {
                print("\(soundsPath) 不存在或不是目录")
            }
        }
        
        print("总共缓存了 \(cachedSoundPaths.count) 个音频文件路径")
        print("======= 扫描完成 =======")
    }
    
    // 从文件名提取宝可梦ID
    private func extractPokemonId(from filename: String) -> Int? {
        // 支持不同格式: 001_Bulbasaur.mp3, 1_Bulbasaur.mp3, Bulbasaur_001.mp3 等
        
        // 尝试从前缀获取ID (最常见格式: 001_Name.mp3)
        let components = filename.components(separatedBy: "_")
        if components.count >= 1, let idString = components.first, let id = Int(idString) {
            return id
        }
        
        // 尝试提取任何数字序列
        if let idMatch = filename.range(of: #"\d{1,3}"#, options: .regularExpression) {
            let idString = String(filename[idMatch])
            if let id = Int(idString) {
                return id
            }
        }
        
        return nil
    }
    
    // 获取音频文件路径
    func getSoundPath(for pokemonId: Int, name: String? = nil) -> String? {
        print("获取ID为 \(pokemonId) 的音频路径")
        
        // 首先检查缓存
        if let cachedPath = cachedSoundPaths[pokemonId], FileManager.default.fileExists(atPath: cachedPath) {
            return cachedPath
        }
        
        // 准备可能的文件名
        let formattedId = String(format: "%03d", pokemonId)
        let simpleId = String(pokemonId)
        let pokemonName = getPokemonName(for: pokemonId) ?? name ?? "Pokemon"
        
        // 搜索可能的位置和文件名
        let possibleNames = [
            "\(formattedId)_\(pokemonName)",
            "\(simpleId)_\(pokemonName)",
            "\(formattedId)",
            "\(pokemonName)_\(formattedId)",
            "\(pokemonName)_\(simpleId)"
        ]
        
        let possibleLocations = [
            "/Resources/Sounds",
            ""  // 根目录
        ]
        
        let possibleExtensions = ["mp3", "wav"]
        
        // 尝试所有可能的组合
        for location in possibleLocations {
            for name in possibleNames {
                for ext in possibleExtensions {
                    // 使用Bundle查找
                    if let path = Bundle.main.path(forResource: name, ofType: ext) {
                        print("找到音频文件: \(path)")
                        cachedSoundPaths[pokemonId] = path
                        return path
                    }
                    
                    // 直接在路径中查找
                    let directPath = "\(Bundle.main.bundlePath)\(location)/\(name).\(ext)"
                    if FileManager.default.fileExists(atPath: directPath) {
                        print("找到音频文件: \(directPath)")
                        cachedSoundPaths[pokemonId] = directPath
                        return directPath
                    }
                }
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
        // 停止当前播放
        stopSound()
        
        // 获取音频路径
        guard let soundPath = getSoundPath(for: pokemonId, name: name) else {
            print("未找到ID为 \(pokemonId) 的音频文件")
            return
        }
        
        // 尝试播放
        do {
            try playSafely(path: soundPath)
        } catch {
            print("播放失败: \(error.localizedDescription)")
        }
    }
    
    // 安全播放 - 处理各种格式问题
    private func playSafely(path: String) throws {
        // 1. 先尝试直接播放
        do {
            try playWithStandardEngine(path: path)
            return
        } catch {
            print("标准播放方式失败，尝试备用方法: \(error.localizedDescription)")
        }
        
        // 2. 尝试使用格式转换
        do {
            try playWithFormatConversion(path: path)
            return
        } catch {
            print("格式转换播放失败，尝试最后备用方法: \(error.localizedDescription)")
        }
        
        // 3. 最后备用 - 简单播放器
        playWithAVAudioPlayer(path: path)
    }
    
    // 标准引擎播放
    private func playWithStandardEngine(path: String) throws {
        guard let engine = audioEngine,
              let playerNode = audioPlayerNode,
              let pitch = pitchControl else {
            throw NSError(domain: "SoundManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "音频引擎未初始化"])
        }
        
        // 准备音频文件
        let audioFileURL = URL(fileURLWithPath: path)
        let audioFile = try AVAudioFile(forReading: audioFileURL)
        let audioFormat = audioFile.processingFormat
        
        print("原始音频格式: 通道=\(audioFormat.channelCount), 采样率=\(audioFormat.sampleRate)Hz")
        
        // 重置节点和连接
        playerNode.reset()
        engine.disconnectNodeOutput(playerNode)
        engine.disconnectNodeOutput(pitch)
        
        // 重新建立连接
        engine.connect(playerNode, to: pitch, format: audioFormat)
        engine.connect(pitch, to: engine.mainMixerNode, format: audioFormat)
        
        // 设置效果参数
        pitch.pitch = playbackPitch
        pitch.rate = playbackRate * 100
        
        // 加载音频数据
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(audioFile.length))!
        try audioFile.read(into: buffer)
        
        // 确保引擎运行
        if !engine.isRunning {
            try engine.start()
        }
        
        // 播放音频
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
        
        print("播放音频: \(path.components(separatedBy: "/").last ?? "未知")")
    }
    
    // 带格式转换的播放
    private func playWithFormatConversion(path: String) throws {
        guard let engine = audioEngine,
              let playerNode = audioPlayerNode,
              let pitch = pitchControl else {
            throw NSError(domain: "SoundManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "音频引擎未初始化"])
        }
        
        // 读取原始音频
        let audioFileURL = URL(fileURLWithPath: path)
        let audioFile = try AVAudioFile(forReading: audioFileURL)
        let sourceFormat = audioFile.processingFormat
        
        // 创建标准立体声格式
        let standardFormat = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 44100,
            channels: 2,
            interleaved: false)!
        
        // 重置连接
        playerNode.reset()
        engine.disconnectNodeOutput(playerNode)
        engine.disconnectNodeOutput(pitch)
        
        // 建立新的连接，使用标准格式
        engine.connect(playerNode, to: pitch, format: standardFormat)
        engine.connect(pitch, to: engine.mainMixerNode, format: standardFormat)
        
        // 设置音频效果参数
        pitch.pitch = playbackPitch
        pitch.rate = playbackRate * 100
        
        // 创建转换器
        guard let converter = AVAudioConverter(from: sourceFormat, to: standardFormat) else {
            throw NSError(domain: "SoundManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "无法创建音频格式转换器"])
        }
        
        // 读取源音频数据
        let sourceBuffer = AVAudioPCMBuffer(pcmFormat: sourceFormat, frameCapacity: AVAudioFrameCount(audioFile.length))!
        try audioFile.read(into: sourceBuffer)
        
        // 创建目标缓冲区
        let frameCount = AVAudioFrameCount(Double(sourceBuffer.frameLength) * standardFormat.sampleRate / sourceFormat.sampleRate)
        guard let convertedBuffer = AVAudioPCMBuffer(pcmFormat: standardFormat, frameCapacity: frameCount) else {
            throw NSError(domain: "SoundManager", code: 3, userInfo: [NSLocalizedDescriptionKey: "无法创建转换后的音频缓冲区"])
        }
        
        // 转换格式
        var error: NSError?
        let status = converter.convert(to: convertedBuffer, error: &error) { _, statusVar in
            statusVar.pointee = .haveData
            return sourceBuffer
        }
        
        if let error = error {
            throw error
        }
        
        if status == .error {
            throw NSError(domain: "SoundManager", code: 4, userInfo: [NSLocalizedDescriptionKey: "音频转换失败"])
        }
        
        // 确保引擎运行
        if !engine.isRunning {
            try engine.start()
        }
        
        // 播放转换后的音频
        playerNode.scheduleBuffer(convertedBuffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
        
        print("播放转换后的音频: \(path.components(separatedBy: "/").last ?? "未知")")
    }
    
    // 备用播放方法
    private func playWithAVAudioPlayer(path: String) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.enableRate = true
            audioPlayer?.rate = playbackRate
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            print("使用备用播放器播放: \(path.components(separatedBy: "/").last ?? "未知")")
        } catch {
            print("备用播放方法也失败: \(error.localizedDescription)")
        }
    }
    
    // 停止所有音频播放
    func stopSound() {
        // 停止音频引擎
        audioPlayerNode?.stop()
        
        // 停止备用播放器
        audioPlayer?.stop()
    }
    
    // 调整音调
    func adjustPitch(to pitch: Float) {
        pitchControl?.pitch = pitch
    }
    
    // 调整播放速度
    func adjustRate(to rate: Float) {
        pitchControl?.rate = rate * 100 // 百分比
    }
} 