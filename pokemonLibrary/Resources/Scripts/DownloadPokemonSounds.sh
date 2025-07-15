#!/bin/bash

# 这个脚本用于下载宝可梦的音频文件
# 使用方法：
# 1. 在终端中运行: chmod +x DownloadPokemonSounds.sh
# 2. 运行: ./DownloadPokemonSounds.sh
# 3. 脚本会下载指定宝可梦的音频文件到Resources/Sounds目录

# 宝可梦ID和名称的映射（不使用关联数组，因为macOS的bash版本可能不支持）
POKEMON_IDS=("001" "004" "006" "007" "025" "052" "094" "130" "143" "149" "150")
POKEMON_NAMES=("bulbasaur" "charmander" "charizard" "squirtle" "pikachu" "meowth" "gengar" "gyarados" "snorlax" "dragonite" "mewtwo")

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 项目根目录
PROJECT_ROOT="$SCRIPT_DIR/../.."

# 创建Sounds目录
SOUNDS_DIR="$PROJECT_ROOT/Resources/Sounds"
mkdir -p "$SOUNDS_DIR"
echo "创建Sounds目录: $SOUNDS_DIR"

# 下载音频文件
for i in "${!POKEMON_IDS[@]}"; do
    ID="${POKEMON_IDS[$i]}"
    NAME="${POKEMON_NAMES[$i]}"
    DISPLAY_NAME="$(tr '[:lower:]' '[:upper:]' <<< ${NAME:0:1})${NAME:1}"
    FILE_NAME="${ID}_${DISPLAY_NAME}.mp3"
    DESTINATION="$SOUNDS_DIR/$FILE_NAME"
    
    # 检查文件是否已存在
    if [ -f "$DESTINATION" ]; then
        echo "音频文件已存在: $FILE_NAME"
        continue
    fi
    
    # 构建下载URL (使用Pokemon Showdown的音频资源)
    URL="https://play.pokemonshowdown.com/audio/cries/$NAME.mp3"
    
    echo "开始下载: $URL -> $DESTINATION"
    curl -s -o "$DESTINATION" "$URL"
    
    if [ $? -eq 0 ]; then
        echo "下载成功: $FILE_NAME"
    else
        echo "下载失败: $FILE_NAME"
    fi
done

echo "下载完成！" 