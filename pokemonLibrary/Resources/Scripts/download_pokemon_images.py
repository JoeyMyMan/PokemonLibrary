#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import requests
import time
from pathlib import Path

# 创建保存图片的目录
def create_directories():
    # 尝试多种可能的路径
    possible_paths = [
        Path("../Assets.xcassets"),  # 相对于脚本的路径
        Path("../../Assets.xcassets"),  # 上一级目录
        Path("../../../Assets.xcassets"),  # 上两级目录
        Path("../../../../Assets.xcassets"),  # 上三级目录
        Path("../../../../../Assets.xcassets"),  # 上四级目录
        Path("/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Assets.xcassets")  # 绝对路径
    ]
    
    base_dir = None
    for path in possible_paths:
        if path.exists():
            base_dir = path
            print(f"找到Assets.xcassets目录: {path}")
            break
    
    if base_dir is None:
        print("错误: 无法找到Assets.xcassets目录")
        print("当前工作目录:", os.getcwd())
        print("尝试创建目录...")
        base_dir = Path("/Users/joeygu/Desktop/pokemon/pokemonLibrary/pokemonLibrary/Assets.xcassets")
        os.makedirs(base_dir, exist_ok=True)
    
    pokemon_dir = base_dir / "Pokemon"
    os.makedirs(pokemon_dir, exist_ok=True)
    
    # 创建Contents.json文件
    with open(pokemon_dir / "Contents.json", "w") as f:
        f.write('''{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}''')
    
    return pokemon_dir

# 下载宝可梦图片
def download_pokemon_images(pokemon_list):
    pokemon_dir = create_directories()
    
    for pokemon in pokemon_list:
        pokemon_id = pokemon["id"]
        name = pokemon["name"]
        
        # 创建每个宝可梦的imageset目录
        image_set_dir = pokemon_dir / f"{pokemon_id:03d}_{name}.imageset"
        os.makedirs(image_set_dir, exist_ok=True)
        
        print(f"下载宝可梦 #{pokemon_id:03d} {name} 的图片...")
        
        # 从PokeAPI获取官方图片
        image_url = f"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{pokemon_id}.png"
        response = requests.get(image_url)
        
        if response.status_code == 200:
            # 保存1x, 2x, 3x图片
            image_path = image_set_dir / f"{pokemon_id:03d}_{name}.png"
            with open(image_path, "wb") as f:
                f.write(response.content)
            
            # 创建Contents.json文件
            with open(image_set_dir / "Contents.json", "w") as f:
                f.write(f'''{{
  "images" : [
    {{
      "filename" : "{pokemon_id:03d}_{name}.png",
      "idiom" : "universal",
      "scale" : "1x"
    }},
    {{
      "idiom" : "universal",
      "scale" : "2x"
    }},
    {{
      "idiom" : "universal",
      "scale" : "3x"
    }}
  ],
  "info" : {{
    "author" : "xcode",
    "version" : 1
  }}
}}''')
            
            print(f"成功下载 #{pokemon_id:03d} {name} 的图片")
        else:
            print(f"无法下载 #{pokemon_id:03d} {name} 的图片，状态码: {response.status_code}")
        
        # 添加延迟以防止API限制
        time.sleep(0.5)

# 主要的宝可梦列表
pokemon_list = [
    {"id": 1, "name": "妙蛙种子"},
    {"id": 4, "name": "小火龙"},
    {"id": 6, "name": "喷火龙"},
    {"id": 7, "name": "杰尼龟"},
    {"id": 25, "name": "皮卡丘"},
    {"id": 94, "name": "耿鬼"},
    {"id": 130, "name": "暴鲤龙"},
    {"id": 143, "name": "卡比兽"},
    {"id": 149, "name": "快龙"},
    {"id": 150, "name": "超梦"}
]

if __name__ == "__main__":
    print("开始下载宝可梦图片...")
    download_pokemon_images(pokemon_list)
    print("下载完成！") 