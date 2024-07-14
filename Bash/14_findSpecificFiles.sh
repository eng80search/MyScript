#!/bin/bash

echo "---------------------------------------------------------------"
echo "Overview: extract script file with fileName matched cits fileID"
echo "---------------------------------------------------------------"
echo ""

echo "-- 処理を開始します。"
# コピー元ディレクトリを配列に定義
source_dirs=(
        "C:/Users/tCIT116/00_work/01_非交換対応/job_all"
)

# コピー先ディレクトリを配列に定義
dest_dirs="C:/Users/tCIT116/00_work/01_非交換対応/cits_all"

# コピー先のフォルダが存在すれば、まずは削除する
if [ -d ${dest_dirs} ]; then
    rm -rf ${dest_dirs}
    echo "コピー先のディレクトリ："${dest_dirs}"を削除しました"
fi
echo "コピー先のディレクトリ："${dest_dirs}"を作成しました"
mkdir ${dest_dirs}

# cits担当分のjobIdを定義
cits_jobId_list=(
    "aa" "ab" "ag" "b1" "b2" "b3" "b4"
    "b5" "b6" "c1" "c2" "d1" "d2" "d3" "d4"
)


# コピー元ディレクトリから属性がファイルで拡張子がkshのファイル名を取得し、処理する
find $source_dirs -type f -name \*.job | while read -r var; do

    # 変数varにドライブ名例えばc:/が入るのでこれを削除
    source_file_name_full=${var:3}

    # $()はコマンドの実行を意味する
    # source_file_nameはコマンドを実行した結果を設定
    source_file_name=$(basename ${var})
    source_file_name_no_extention=${source_file_name:0:-4}
    # echo $(basename ${var})
    # 文字列の最後尾を削除する場合は${var:0:-4}
    echo "source_file_name is : "${source_file_name}

    for cits_jobId in "${cits_jobId_list[@]}"; do

        # ファイルの頭２文字を確認し、CITS担当分であるかを確認
        if [[ ${source_file_name_no_extention} =~ ^${cits_jobId} ]]; then

            # cp $var ${dest_dirs}
            # grepで文字化け防止のため、UTF-8に変換する
            iconv -f SJIS -t utf-8 $var > ${dest_dirs}"/"$source_file_name
            echo " copied matching file : "${source_file_name}" to "$dest_dirs

        fi
    done

done
echo "-- 処理を終了します。"
