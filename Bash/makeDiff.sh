#!/bin/sh

# --------------------------------------------------------
# gitのコマンドを利用して、変更前と変更後のzipファイルを作成
# ---------------------------------------------------------
echo "-----------------------------------------------------------------"
echo "概要：　gitのコマンドを利用して、変更前と変更後のzipファイルを作成"
echo "-----------------------------------------------------------------"

COMMIT_FROM="diff_first"
COMMIT_TO="HEAD"

# パラメータ個数チェック
echo "指定された引数は$#個です。"

# パラメータが一つのみの場合
if [ $# -eq 1 ]; then
  COMMIT_FROM=$1
  COMMIT_TO="HEAD"
fi

# パラメータが二つの場合
if [ $# -eq 2 ]; then
  COMMIT_FROM=$1
  COMMIT_TO=$2
fi

DIFF_SOURCE=/C/ProgramData/APLWORK/基盤/RDAステータス管理
DIFF_DEST=/C/Users/T21A824/00_work/77_Temp

echo ""
echo "diffを作成するディレクトリ：" $DIFF_SOURCE
echo "作成したzipファイルの移動先ディレクトリ：" $DIFF_DEST
echo ""
cd $DIFF_SOURCE

echo "変更前.zipファイルを作成します　範囲：${COMMIT_FROM}..${COMMIT_TO}"
git archive --format=zip ${COMMIT_FROM} `git diff --diff-filter=a --name-only ${COMMIT_FROM}..${COMMIT_TO}` -o 変更前.zip

echo "変更後.zipファイルを作成します　範囲：${COMMIT_FROM}..${COMMIT_TO}"
git archive --format=zip ${COMMIT_TO} `git diff --diff-filter=d --name-only ${COMMIT_FROM}..${COMMIT_TO}` -o 変更後.zip
echo ""
echo "diffファイルの作成が完了しました"
echo ""

mv -f 変更前.zip 変更後.zip $DIFF_DEST
echo "ファイルを移動しました。移動先にファイルがある場合は上書きになります。"

echo "---------------------処理が完了しました-----------------------------"
