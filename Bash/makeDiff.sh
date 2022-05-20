#!/bin/sh

# --------------------------------------------------------
# gitのコマンドを利用して、変更前と変更後のzipファイルを作成
# ---------------------------------------------------------
echo "-----------------------------------------------------------------"
echo "概要：　gitのコマンドを利用して、変更前と変更後のzipファイルを作成"
echo "-----------------------------------------------------------------"
echo "*範囲： diff_first..HEAD"
echo "*注意： gitにて事前にdiff_firstのタグを付けてください。"
echo "        git tag -a diff_first -m コメント f26ea96(hash)"
echo "-----------------------------------------------------------------"

DIFF_SOURCE=/C/ProgramData/APLWORK/基盤/RDAステータス管理
DIFF_DEST=/C/Users/T21A824/00_work/77_Temp

echo ""
echo "diffを作成するディレクトリ：" $DIFF_SOURCE
echo "作成したzipファイルの移動先ディレクトリ：" $DIFF_DEST
echo ""
cd $DIFF_SOURCE

echo "変更前.zipファイルを作成します　範囲：diff_first..HEAD"
git archive --format=zip diff_first `git diff --diff-filter=a --name-only diff_first..HEAD` -o 変更前.zip

echo "変更後.zipファイルを作成します　範囲：diff_first..HEAD"
git archive --format=zip HEAD `git diff --diff-filter=d --name-only diff_first..HEAD` -o 変更後.zip
echo ""
echo "diffファイルの作成が完了しました"
echo ""

mv -f 変更前.zip 変更後.zip $DIFF_DEST
echo "ファイルを移動しました。移動先にファイルがある場合は上書きになります。"

echo "---------------------処理が完了しました-----------------------------"
