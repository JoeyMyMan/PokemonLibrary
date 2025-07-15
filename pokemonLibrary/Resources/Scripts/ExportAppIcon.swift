import SwiftUI
import UIKit

/// 用于导出应用图标的工具类
class AppIconExporter {
    /// 导出应用图标为PNG文件
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - path: 保存路径
    static func exportAppIcon(size: CGFloat, to path: String) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        
        let image = renderer.image { context in
            // 渲染AppIconView
            let hostingController = UIHostingController(rootView: AppIconView())
            hostingController.view.frame = CGRect(x: 0, y: 0, width: size, height: size)
            hostingController.view.backgroundColor = .clear
            hostingController.view.drawHierarchy(in: hostingController.view.bounds, afterScreenUpdates: true)
        }
        
        // 保存为PNG
        if let data = image.pngData() {
            do {
                try data.write(to: URL(fileURLWithPath: path))
                print("应用图标已导出到: \(path)")
            } catch {
                print("导出应用图标失败: \(error.localizedDescription)")
            }
        }
    }
    
    /// 生成所有尺寸的应用图标
    static func generateAllIcons(to directory: String) {
        // 创建目录
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: directory) {
            do {
                try fileManager.createDirectory(atPath: directory, withIntermediateDirectories: true)
            } catch {
                print("创建目录失败: \(error.localizedDescription)")
                return
            }
        }
        
        // iOS图标尺寸
        let iconSizes = [
            (name: "Icon-20.png", size: 20),
            (name: "Icon-20@2x.png", size: 40),
            (name: "Icon-20@3x.png", size: 60),
            (name: "Icon-29.png", size: 29),
            (name: "Icon-29@2x.png", size: 58),
            (name: "Icon-29@3x.png", size: 87),
            (name: "Icon-40.png", size: 40),
            (name: "Icon-40@2x.png", size: 80),
            (name: "Icon-40@3x.png", size: 120),
            (name: "Icon-60@2x.png", size: 120),
            (name: "Icon-60@3x.png", size: 180),
            (name: "Icon-76.png", size: 76),
            (name: "Icon-76@2x.png", size: 152),
            (name: "Icon-83.5@2x.png", size: 167),
            (name: "Icon-1024.png", size: 1024)
        ]
        
        // 生成每个尺寸的图标
        for icon in iconSizes {
            let path = "\(directory)/\(icon.name)"
            exportAppIcon(size: CGFloat(icon.size), to: path)
        }
        
        print("所有图标已生成到: \(directory)")
    }
}

// 使用示例
// AppIconExporter.generateAllIcons(to: "/Users/username/Desktop/AppIcons") 