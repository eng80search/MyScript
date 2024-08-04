#!/bin/bash

# 変数定義
GENKOU_PREFIX="現行IT05_"
JIKI_PREFIX="次期IT08_"

source_dirs="./"

# left joinのSelect文を作成 $0 : 第一番目の引数
createSelect(){
    # テーブル名の空白文字削除
    select_tbl=`echo $1 | sed -e "s/ //g"`
    sql_Select="SELECT "${GENKOU_PREFIX}${select_tbl}
}

# left joinのfrom文を作成
createFrom(){
    sql_From=" FROM "${GENKOU_PREFIX}$1" LEFT JOIN "${JIKI_PREFIX}$1" ON "
    # FROM 現行IT05_RM013F00 LEFT JOIN 次期IT08_RM013F00 ON
}

# left joinの結合条件文を作成
createLeftjoin(){
    # echo "param is:"$@ 配列を引数から受ける場合は、パラメータは$@になる
    list_Leftjoin=$@
    # 配列の全てのループは$var[@]
    sql_Leftjoin=""
    sql_Leftjoin_30_Genkou=""
    sql_Leftjoin_30_Jiki=""
    col_count=0
    col_max=30
    for i in ${list_Leftjoin[@]}
    do

        # テーブルの項目数が100以上は＆でくっつける
        if [[ `cat "./100item-tables.txt" | grep ${select_tbl}` ]]; then
            # echo "** finished: "${select_tbl}
            col_count=$((col_count+1))

            # 列数が30個になると=で連結 -gt は > の意味
            if [[ col_count -gt col_max ]]; then

                # echo "max count is: "$col_count
                sql_Leftjoin=${sql_Leftjoin}"("${sql_Leftjoin_30_Genkou}" = "${sql_Leftjoin_30_Jiki}") AND "

                # 終わったらいろいろ初期化
                col_count=1
                sql_Leftjoin_30_Genkou=""
                sql_Leftjoin_30_Jiki=""
            fi

            # echo ${select_tbl}" col_count: "$col_count

            if [[ col_count -eq 1 ]]; then
                sql_Leftjoin_30_Genkou=${GENKOU_PREFIX}${select_tbl}"."$i
                sql_Leftjoin_30_Jiki=${JIKI_PREFIX}${select_tbl}"."$i
            else
                sql_Leftjoin_30_Genkou=${sql_Leftjoin_30_Genkou}" & "${GENKOU_PREFIX}${select_tbl}"."$i
                sql_Leftjoin_30_Jiki=${sql_Leftjoin_30_Jiki}" & "${JIKI_PREFIX}${select_tbl}"."$i
            fi

            # 分割リストに乗っていないテーブルの場合の結合文
        else
            # echo "left join : $i"
            # ヒント：変数の定義が長い場合、"の内部で改行すればよい
            sql_Leftjoin=${sql_Leftjoin}"("${GENKOU_PREFIX}${select_tbl}"."$i"
                                 = "${JIKI_PREFIX}${select_tbl}"."$i") AND "
        fi

    done


    # 苦肉の策：分割リストに載っているテーブルの場合、最後の残りのクエリを作成する。例えば35ある場合、31~35が対象
    if [[ "${sql_Leftjoin_30_Genkou}" != "" ]]; then
        sql_Leftjoin=${sql_Leftjoin}"("${sql_Leftjoin_30_Genkou}" = "${sql_Leftjoin_30_Jiki}") AND "

        # echo "Debug1: "${sql_Leftjoin_30_Genkou}
        # 終わったらいろいろ初期化
        col_count=0
        sql_Leftjoin_30_Genkou=""
        sql_Leftjoin_30_Jiki=""
    fi

    # 文字列の長さを取得する場合は、#str
    sql_Leftjoin=${sql_Leftjoin:0:${#sql_Leftjoin}-4}
    # echo ${sql_Leftjoin}
}

# left joinのwhere文を作成
createWhere(){
    # echo "param is:"$@ 配列を引数から受ける場合は、パラメータは$@になる
    # 配列に変換 $@ -> ($@)
    list_Where=($@)
    # echo "Debug: "${list_Where[1]}

    sql_Where=" WHERE ((("${JIKI_PREFIX}${select_tbl}"."${list_Where[0]}") Is Null));"
    # echo ${sql_Where}
}

# 既存のクエリ文が入っているディレクトリを削除
if [ -d "./sql/" ]; then rm -Rf "./sql/"; fi

# 主処理
find $source_dirs -type f -name "export-*.sql" | while read -r var; do

    # echo ${var}
    grep -E "^SELECT" ${var} | while read -r select_line ; do

        # echo "Select is $line"

        # left joinする列名
        select_col=`echo ${select_line} |\
            sed -e "s/\(^SELECT\)\(.\+\)\(FROM \)\(.\+\)\(where .\+\)\(order by \)\(.\+\)\(;\)/\2/g"`
        # テーブル名
        select_tbl=`echo ${select_line} |\
            sed -e "s/\(^SELECT\)\(.\+\)\(FROM \)\(.\+\)\(where .\+\)\(order by \)\(.\+\)\(;\)/\4/g"`
        # where文
        select_where=`echo ${select_line} |\
            sed -e "s/\(^SELECT\)\(.\+\)\(FROM \)\(.\+\)\(where .\+\)\(order by \)\(.\+\)\(;\)/\7/g"`
        # カンマ区切りの項目をスペースで区切り配列に格納する
        list_col=(${select_col//,/ })
        list_where=(${select_where//,/ })
        # echo ${list_col[@]}
        # echo ${list_Where[@]}
        # echo "table_name:"${select_tbl}
        # echo "select_where:"${select_where}

        # クエリ文を構成する各パーツ作成用関数呼び出し
        createSelect ${select_tbl}
        createFrom ${select_tbl}
        createLeftjoin ${list_col[@]}
        createWhere ${list_where[@]}

        sql_Full=$sql_Select".* "$sql_From$sql_Leftjoin$sql_Where
        echo ${sql_Full}

        # 営業と会計にフォルダを分ける
        if [[ ${var} =~ "eigyo" ]]; then
            # フォルダがなければ作成する
            dir_eigyo="./sql/eigyo/"
            mkdir -p ${dir_eigyo}"utf8/"
            mkdir -p ${dir_eigyo}"sjis/"

            # 出力用ファイルを作成
            exportSqlFile_Utf8=${dir_eigyo}"utf8/diff_"${select_tbl}_utf8".sql"
            exportSqlFile=${dir_eigyo}"sjis/diff_"${select_tbl}".sql"

        else
            # echo "kaikei"
            dir_eigyo="./sql/kaikei/"
            mkdir -p ${dir_eigyo}"utf8"
            mkdir -p ${dir_eigyo}"sjis"

            # 出力用ファイルを作成
            exportSqlFile_Utf8=${dir_eigyo}"utf8/diff_"${select_tbl}_utf8".sql"
            exportSqlFile=${dir_eigyo}"sjis/diff_"${select_tbl}".sql"

        fi

        echo ${sql_Full} > ${exportSqlFile_Utf8}
        # utf8をsjisに変換
        iconv -f UTF-8 -t SJIS ${exportSqlFile_Utf8} > ${exportSqlFile}
        echo "----- "${exportSqlFile}"  completed -----"

    done

done
