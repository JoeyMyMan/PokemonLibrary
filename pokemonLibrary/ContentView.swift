//
//  ContentView.swift
//  pokemonLibrary
//
//  Created by 小麦克 on 2025/7/13.
//

import SwiftUI

struct ContentView: View {
    @State private var showDebugView = false
    @State private var showSplash = true
    @State private var isGIFManagerInitialized = false
    
    var body: some View {
        ZStack {
            // 主内容
            if !showSplash {
                NavigationView {
                    PokemonListView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    showDebugView = true
                                }) {
                                    Image(systemName: "ladybug.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .sheet(isPresented: $showDebugView) {
                            NavigationView {
                                GIFDebugView()
                                    .navigationTitle("GIF调试")
                                    .navigationBarItems(trailing: Button("关闭") {
                                        showDebugView = false
                                    })
                            }
                        }
                }
                .transition(.opacity)
                .onAppear {
                    // 确保GIFManager在主内容显示时初始化
                    if !isGIFManagerInitialized {
                        initializeGIFManager()
                    }
                }
            }
            
            // 开屏动画
            if showSplash {
                SplashScreenView {
                    // 开屏动画结束后，初始化GIFManager并显示主内容
                    initializeGIFManager()
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showSplash)
    }
    
    // 初始化GIFManager
    private func initializeGIFManager() {
        if !isGIFManagerInitialized {
            print("初始化GIFManager...")
            let _ = GIFManager.shared
            print("GIFManager初始化完成")
            
            // 下载Pokemon图片
            print("开始下载Pokemon图片...")
            ImageDownloader.shared.downloadImages()
            
            isGIFManagerInitialized = true
        }
    }
}

#Preview {
    ContentView()
}
