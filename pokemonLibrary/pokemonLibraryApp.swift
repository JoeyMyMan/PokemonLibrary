//
//  pokemonLibraryApp.swift
//  pokemonLibrary
//
//  Created by 小麦克 on 2025/7/13.
//

import SwiftUI

@main
struct pokemonLibraryApp: App {
    init() {
        // 应用启动时初始化
        configureApp()
    }
    
    // 配置应用
    private func configureApp() {
        print("应用启动...")
        
        // 初始化GIFManager
        print("初始化GIFManager...")
        let _ = GIFManager.shared
        
        // 下载Pokemon图片
        ImageDownloader.shared.downloadImages()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#if DEBUG
struct pokemonLibraryApp_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13")
    }
}
#endif

