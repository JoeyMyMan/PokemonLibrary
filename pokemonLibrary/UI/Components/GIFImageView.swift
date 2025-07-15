import SwiftUI
import UIKit
import ImageIO

struct GIFImageView: UIViewRepresentable {
    private let gifURL: URL
    private let loopCount: Int
    private var contentMode: UIView.ContentMode = .scaleAspectFit
    
    init(gifURL: URL, loopCount: Int = 0) {
        self.gifURL = gifURL
        self.loopCount = loopCount
        print("初始化GIF视图，URL: \(gifURL.path)")
    }
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        
        print("正在加载GIF: \(gifURL.path)")
        
        // 检查文件是否存在
        guard FileManager.default.fileExists(atPath: gifURL.path) else {
            print("错误：GIF文件不存在: \(gifURL.path)")
            return imageView
        }
        
        // 加载GIF
        do {
            let gifData = try Data(contentsOf: gifURL)
            print("成功读取GIF数据，大小: \(ByteCountFormatter.string(fromByteCount: Int64(gifData.count), countStyle: .file))")
            
            if let source = CGImageSourceCreateWithData(gifData as CFData, nil) {
                let frameCount = CGImageSourceGetCount(source)
                print("GIF帧数: \(frameCount)")
                
                if frameCount <= 0 {
                    print("错误：GIF没有有效的帧")
                    return imageView
                }
                
                var images: [UIImage] = []
                var totalDuration: TimeInterval = 0
                
                // 提取每一帧
                for i in 0..<frameCount {
                    if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                        let image = UIImage(cgImage: cgImage)
                        images.append(image)
                        
                        // 计算每一帧的持续时间
                        if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                           let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                           let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                            totalDuration += delayTime
                        }
                    } else {
                        print("无法创建第\(i)帧的图像")
                    }
                }
                
                if images.isEmpty {
                    print("错误：无法提取GIF帧")
                    return imageView
                }
                
                print("成功提取\(images.count)帧图像，总时长: \(totalDuration)秒")
                
                // 设置动画
                imageView.animationImages = images
                imageView.animationDuration = totalDuration > 0 ? totalDuration : 1.0
                imageView.animationRepeatCount = loopCount // 0表示无限循环
                imageView.startAnimating()
                
                print("GIF动画已启动，重复次数: \(loopCount == 0 ? "无限" : "\(loopCount)")")
            } else {
                print("错误：无法创建CGImageSource")
            }
        } catch {
            print("加载GIF数据失败: \(error.localizedDescription)")
        }
        
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // 更新视图
        uiView.contentMode = contentMode
    }
    
    func aspectRatio(_ contentMode: UIView.ContentMode) -> GIFImageView {
        var view = self
        view.contentMode = contentMode
        return view
    }
}

// 便利扩展，用于从本地文件加载GIF
extension GIFImageView {
    // 从Bundle中加载GIF
    static func localGIF(named name: String, bundle: Bundle = .main, loopCount: Int = 0) -> GIFImageView? {
        print("尝试从Bundle加载GIF: \(name)")
        if let url = bundle.url(forResource: name, withExtension: "gif") {
            print("在Bundle中找到GIF: \(url.path)")
            return GIFImageView(gifURL: url, loopCount: loopCount)
        }
        print("在Bundle中未找到GIF: \(name)")
        return nil
    }
    
    // 从文件路径加载GIF
    static func fileGIF(path: String, loopCount: Int = 0) -> GIFImageView? {
        print("尝试从路径加载GIF: \(path)")
        let url = URL(fileURLWithPath: path)
        if FileManager.default.fileExists(atPath: path) {
            print("文件存在，创建GIFImageView")
            return GIFImageView(gifURL: url, loopCount: loopCount)
        }
        print("GIF文件不存在: \(path)")
        return nil
    }
    
    // 从应用Documents目录加载GIF
    static func documentsGIF(named filename: String, loopCount: Int = 0) -> GIFImageView? {
        print("尝试从Documents目录加载GIF: \(filename)")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("在Documents目录找到GIF: \(fileURL.path)")
            return GIFImageView(gifURL: fileURL, loopCount: loopCount)
        }
        print("在Documents目录未找到GIF: \(filename)")
        return nil
    }
} 