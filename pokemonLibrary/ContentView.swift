//
//  ContentView.swift
//  pokemonLibrary
//
//  Created by 小麦克 on 2025/7/13.
//

import SwiftUI

struct ContentView: View {
    @State private var showDebugView = false
    
    var body: some View {
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
