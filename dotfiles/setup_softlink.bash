#!/bin/bash
# 遍历当前目录下所有文件, 根据系统从文件中读取PATH, 将文件链接到PATH路径

function create_softlink() {

    local file="$(realpath "$1")"
    local pattern="$2"

    local target_path=$(grep -oE "$pattern" "$file" | awk -F ': ' '{print $2}')
    if [[ ! -z "$target_path" ]]; then
        target_path=$(echo "$target_path" | sed "s|\${HOME}|$HOME|g")
        mkdir -p "$(dirname "$target_path")"
        echo "$file -> $target_path"
        ln -sf "$file" "$target_path"
    fi
}

pattern=""
case "$(uname -s)" in
    Linux*)
        echo "Setup softlink for Linux"
        pattern="LinuxPath: (.*)"
        ;;
    Darwin*)
        echo "Setup softlink for MacOS"
        pattern="MacPath: (.*)"
        ;;
    *)
        echo "Not support: $(uname -s)"
        exit 1
        ;;
esac


export -f create_softlink
script_path="./$(basename "$0")"
find . -type f ! -path "$script_path" -exec bash -c 'create_softlink "$0" "$1"' {} "$pattern" \;
