#!/bin/bash

# 获取当前脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "=== 开始运行宝可梦图片下载脚本 ==="

# 检查Python是否已安装
if ! command -v python3 &>/dev/null; then
    echo "错误: 未找到Python3。请安装Python3后重试。"
    exit 1
fi

# 安装必要的依赖
echo "安装所需Python库..."
pip3 install requests

# 运行下载脚本
echo "运行下载脚本..."
python3 download_pokemon_images.py

echo "=== 下载完成 ==="
echo "请重新构建Xcode项目，确保新增的图片资源被正确加载。" 