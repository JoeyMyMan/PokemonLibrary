# 宝可梦图鉴 (Pokemon Library)

一个使用Swift和SwiftUI开发的iOS/macOS应用，展示宝可梦的信息和特性。

## 功能特点

- 浏览宝可梦列表
- 搜索宝可梦（按名称、类型或特性）
- 查看宝可梦详细信息（基本信息、描述、能力值等）
- 支持本地图片资源
- 适配不同iOS设备

## 技术实现

- **架构**：MVVM (Model-View-ViewModel)
- **UI框架**：SwiftUI
- **语言**：Swift
- **数据源**：本地JSON数据（可扩展为网络API）
- **图片资源**：本地Assets + 系统SF Symbols作为备用

## 项目结构

```
pokemonLibrary/
├── Features/
│   ├── PokemonList/
│   │   ├── PokemonListView.swift
│   │   └── PokemonListViewModel.swift
│   └── PokemonDetail/
│       ├── PokemonDetailView.swift
│       └── PokemonDetailViewModel.swift
├── Core/
│   ├── Models/
│   │   └── Pokemon.swift
│   └── Services/
│       └── ImageDownloader.swift
├── UI/
│   └── Components/
│       └── PokemonCard.swift
└── Resources/
    ├── ColorExtension.swift
    └── Scripts/
        ├── download_pokemon_images.py
        └── run_download.sh
```

## 安装与运行

1. 克隆仓库
2. 在Xcode中打开`pokemonLibrary.xcodeproj`
3. 选择目标设备（iPhone、iPad或Mac）
4. 运行应用

## 图片资源

项目包含下载宝可梦图片的脚本。运行方法：

```bash
cd pokemonLibrary/Resources/Scripts
./run_download.sh
```

## 系统要求

- iOS 15.0+
- macOS 12.0+
- Xcode 13.0+
- Swift 5.5+

## 许可证

本项目仅用于学习和演示目的。宝可梦相关内容的版权归任天堂和The Pokémon Company所有。 