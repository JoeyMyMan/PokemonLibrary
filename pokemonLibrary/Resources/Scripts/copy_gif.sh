#!/bin/bash

# 定义源文件和目标目录
SOURCE_GIF="/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Resources/001_Bulbasaur_Anim.gif"
TARGET_DIR="${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/Resources"

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 复制GIF文件
if [ -f "$SOURCE_GIF" ]; then
    echo "复制GIF文件: $SOURCE_GIF -> $TARGET_DIR"
    cp "$SOURCE_GIF" "$TARGET_DIR/"
else
    echo "错误: 源GIF文件不存在: $SOURCE_GIF"
    exit 1
fi

echo "GIF文件复制完成!"
exit 0 