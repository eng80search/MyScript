#!/bin/sh

echo "dislplay all filename in subdirectory"

# 本スクリプトの絶対パスを取得
SCRIPT_DIR=$(cd $(dirname $0); pwd)

echo "current directory is :" $SCRIPT_DIR
# dislplay the list on screen
find . -type f
# 現在のディレクトリ以下のすべてのファイル一覧を取得する
find . -type f > fileList.txt

read -p "Press Enter key to exit・・・"
