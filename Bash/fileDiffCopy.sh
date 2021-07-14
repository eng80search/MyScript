#!/bin/sh

echo "Overview: copy only files newer than the inputed date from local IIS"
echo -e "          to the current directory\n"
# 改行の場合は-eをつけ、改行したい場所に\nを挿入する

iis_dir=d:/Websites/JNJWEB/store/pc/webApp

echo "IIS_DIR: " $iis_dir
echo "please input start date(e.g. 2021/07/14) :"
echo "press enter key start date is today"

# キーボードから開始日付を入力する
read input

if [ -z $input ] ; then
    # 入力なしの場合は、今日の日付を開始日付に設定
    start_date=$(date '+%Y/%m/%d') 
else
    start_date=$input
fi

# 注意：変数と文字列を結合する場合は、変数を{}で囲む
start_date=${start_date}" 0:0:0"
# start_date=${start_date}

echo "start date : "  $start_date

# find $iis_dir -type f -mtime -1 ;

# 注意： $start_dateは"で囲むこと
find $iis_dir -type f -newermt "$start_date" | while read -r var;

do
    dir=.;
    # d:/は削除
    sourcefile=${var:3};

    # echo $(dirname $sourcefile);
    echo  $sourcefile;

    # 注意：dirnameがないとファイルがディレクトリとして作成される
    mkdir -p $dir/$(dirname $sourcefile);
    # mkdir -p $dir/$sourcefile;

    # IISからリリースフォルダにコピーする p : 日付やユーザー情報を保持しながらコピー
    cp -p $var $dir/$sourcefile;

done

read -p "Press Enter key to exit・・・"
