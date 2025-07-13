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
        // 在应用启动时下载Pokemon图片
        ImageDownloader.shared.downloadImages()
    }
    
    var body: some Scene {
        WindowGroup {
            PokemonListView()
        }
    }
}

#if DEBUG
struct pokemonLibraryApp_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
            .previewDevice("iPhone 13")
    }
}
#endif

