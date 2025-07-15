//
//  pokemonLibraryApp.swift
//  pokemonLibrary
//
//  Created by 小麦克 on 2025/7/13.
//

import SwiftUI

@main
struct pokemonLibraryApp: App {
    // 应用启动时执行的初始化
    init() {
        // 配置应用
        configureApp()
    }
    
    // 配置应用
    private func configureApp() {
        // 基本配置
        print("应用启动...")
        
        // 注意：GIFManager现在会在ContentView中的开屏动画结束后初始化
        // 这样可以提高启动速度，让开屏动画更流畅
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

