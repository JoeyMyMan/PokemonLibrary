# 宝可梦图片下载脚本

本脚本用于下载宝可梦图片并将其添加到Xcode项目的Assets.xcassets中。

## 使用方法

### 1. 前提条件

- 安装Python 3
- 安装requests库（脚本会自动尝试安装）

### 2. 运行脚本

```bash
# 方法1：使用shell脚本（推荐）
./run_download.sh

# 方法2：直接运行Python脚本
python3 download_pokemon_images.py
```

### 3. 脚本功能

- 下载第一代10个代表性宝可梦的官方图片
- 将图片添加到Assets.xcassets的Pokemon目录中
- 每个宝可梦创建一个独立的imageset

### 4. 脚本完成后

1. 在Xcode中刷新项目（Command+Shift+K清理项目，然后重新构建）
2. 宝可梦图片将被正确加载到应用中

## 图片命名规则

图片按照以下格式命名：`001_妙蛙种子.png`、`004_小火龙.png`等。

## 添加更多宝可梦

如需添加更多宝可梦，请在`download_pokemon_images.py`文件中的`pokemon_list`列表中添加新的宝可梦信息。 