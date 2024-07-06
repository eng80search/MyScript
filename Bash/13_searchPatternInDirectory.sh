

echo "----------------------------------------------------------"
echo "Overview: Extract job files that match a specific pattern "
echo "----------------------------------------------------------"
echo ""

echo "-- 処理を開始します。"

# ジョブファイルの場所
source_dirs="C:/Users/tCIT116/00_work/01_非交換対応/cits_all_test"
# source_dirs="C:/Users/tCIT116/00_work/01_非交換対応/cits_all"

# パターンリストファイル
pattern_list="./pattern_list_test.txt"
# pattern_list="./pattern_list.txt"

# 初期設定
echo "------------grep 結果 -------------" > ../grep_result.txt

echo "" >> ../grep_result.txt

# 空のファイルを新規作成
echo -n > ../grep_result.csv

# コピー元ディレクトリから属性がファイルで拡張子がkshのファイル名を取得し、処理する
find $source_dirs -type f -name \*.job | while read -r var; do

    # $()はコマンドの実行を意味する
    # source_file_nameはコマンドを実行した結果を設定
    source_file_name=$(basename ${var})


    echo ""
    echo "" >> ../grep_result.txt
    echo "-----------FileName : "$source_file_name"-----------"
    echo "-----------FileName : "$source_file_name"-----------" >> ../grep_result.txt

    csv_row=$source_file_name
    match_result=""
    for pattern_str in $(cat $pattern_list); do
        # echo "pattern is"$pattern_str
        # echo "pattern is "$pattern_str "target file is:"${var}
        # grep -E "${pattern_str} ${source_file_name_full}"

        # echo $pattern_str_2
        # if [ "$test_grep" = "$pattern_str_2" ]; then
        #    echo "Same"
        # else
        #    echo "Different"
        # fi


        grep -n -E $pattern_str $var >> ../grep_result.txt
        if [ $? = 0 ]; then
            echo "matched pattern_str: "$pattern_str
            csv_row=$csv_row",○"
            match_result=$match_result"\nmatched pattern_str: "$pattern_str
        else

            csv_row=$csv_row",X"
            # echo "not matched pattern_str: "$pattern_str
            # echo "not matched pattern_str: "$pattern_str >> grep_result.txt
        fi

    done

    echo -e $match_result >> ../grep_result.txt

    echo $csv_row >> ../grep_result.csv

done
echo "-- 処理を終了します。"
