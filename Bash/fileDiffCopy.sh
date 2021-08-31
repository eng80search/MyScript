#!/bin/sh

echo "Overview: copy only files newer than the inputed date from source_dirs"
echo -e "          to the current directory\n"
# 改行の場合は-eをつけ、改行したい場所に\nを挿入する

# コピー元ディレクトリを配列に定義
source_dirs=(
        "d:/Websites/JNJWEB/store/pc/webApp"
        "d:/store"
)

# スキップするファイルもしくはディレクトリを定義(正規表現で定義)
ignore_list=(
        "\.pdb$"
        "\.vshost\.exe$"
        "\.log$"
        "/log/"
        "/seohtm_pc/"
        "precompiledapp\.config$"
        "createrunningstorelist\.xml$"
)

for dir in "${source_dirs[@]}"; do
    echo "SOURCE_DIR: " $dir
done

# bashでは変数の値を取得する場ありは$[変数名]にする
echo "please input start date(e.g. 2021/07/14) :"
echo "press enter key start date is today"

# キーボードから開始日付を入力する
read input

# -z 文字列の長さが0ならtrue
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

# 関数定義：一つのディレクトリに対して、指定した日付より新しいファイルをコピー
copy_newer_file_to_dest() {
    # 関数に引数をローカル変数に保存する
    local source_dir=$1
    local beginning_date=$2

    # findした結果をwhileでloopするやり方
    # 注意： $beginning_dateは"で囲むこと
    # セミコロン(;)はコマンドAが終了したら、エラーありなしに関係なく、
    # セミコロン後ろのコマンドを実行するとの意味
    find $source_dir -type f -newermt "$beginning_date" | while read -r var; do

        # コピー先はスクリプトが置かれているディレクトリと同じ
        local dest_dir=.;
        # 変数varにドライブ名d:/が入るのでこれを排除
        local sourcefile=${var:3};

        # if文で正規表現の場合は[[]]で囲む =~は正規表現マッチング演算子
        # スキップ対象のファイルやフォルダはコピーしない
        for ignore in "${ignore_list[@]}" ; do
            # echo "--debug:" $ignore
            #  ${sourcefile,,} は全文字を小文字化
            if [[ ${sourcefile,,} =~ $ignore  ]]; then
                echo "skipping ->" $sourcefile
                # continue 2は２階層上のloopにjumpする意味
                continue 2
            fi
        done

        # echo $(dirname $sourcefile);
        echo  $sourcefile;

        # dirname $sourcefileで$sourcefileのディレクトリ部分のみ抽出する
        # option -p: A/B/Cみたいな階層構造を作成する
        mkdir -p $dest_dir/$(dirname $sourcefile);
        # mkdir -p $dest_dir/$sourcefile;

        # IISからリリースフォルダにコピーする p : 日付やユーザー情報を保持しながらコピー
        cp -p $var $dest_dir/$sourcefile;

    done

}

# 指定したディレクトリごとにコピーする
for dir in "${source_dirs[@]}"; do
    copy_newer_file_to_dest $dir $start_date
done

read -p "Press Enter key to exit・・・"
