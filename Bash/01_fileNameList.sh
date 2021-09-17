#!/bin/sh

# 本スクリプトの絶対パスを取得 $0:自分自身のファイル名
SCRIPT_ROOT=$(dirname $0)
WEBSITES_ROOT="/Websites"
# echo "TARGET_DIR is " ${SCRIPT_ROOT}${WEBSITES_ROOT}

# 文字列連結は${var1}${var2}
SCRIPT_DIR=$(cd ${SCRIPT_ROOT}${WEBSITES_ROOT}; pwd)
# SCRIPT_DIR=$(cd ${SCRIPT_ROOT}; pwd)

# メモ：bashで変数の値を取得する際には${var}である
echo "-----dislplay all filename in target folder----- " 
echo "target directory is :" ${SCRIPT_DIR}
echo "------------------------------------------------ " 

# 一覧リストファイルのヘッダを作成
echo "-----Relese file List-----" > fileList.txt
echo "CreateTime: "$(date '+%Y/%m/%d %H:%M:%S') >> fileList.txt

# ターゲットディレクトリ以下のすべてのファイル一覧を取得する
find $SCRIPT_DIR -type f -printf '%P\n' | while read -r var; do
    # 表示用
    echo ${WEBSITES_ROOT}"/"${var}
    # ファイル出力用
    echo ${WEBSITES_ROOT}"/"${var} >> fileList.txt
done
# find $SCRIPT_DIR -type f > fileList.txt

read -p "Press Enter key to exit・・・"
