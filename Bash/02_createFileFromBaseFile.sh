# !/bin/sh

echo "----------------------------------------------------------------------"
echo "Overview: Copy base day csv file from the previous day to the 10th day"
echo "      Ex: FX_RESULT_20210330 --> FX_RESULT_20210331 ... FX_RESULT_20210409"
echo "----------------------------------------------------------------------"

# 変数の使い方 参照時には２つ方法がある $変数名 OR ${変数名}
# コマンド実行結果を変数に代入する方法 `コマンド` OR $(コマンド)

# コピー元フォルダを配列形式で定義
source_dir=(
"C:\Users\pcni0274\00_Work\77_Temp\分析ツール_評価レート変動要因分析_テストデータ"
)

# コピー先フォルダを定義
dest_dir_root="C:\Users\pcni0274\00_Work\77_Temp\分析ツール_評価レート変動要因分析_テストデータ_copied"

prefix_dir="FDFSMarket_"

# 初期処理 コピー先フォルダを削除->新規作成する
if [ -d ${dest_dir_root} ]; then # []の内部では前後空白を１つずつ入れること！
    rm -rf ${dest_dir_root}
    echo "既存のコピー先フォルダ削除："${dest_dir_root}
fi
mkdir ${dest_dir_root}

echo "コピー元フォルダ："${source_dir}
echo "コピー先フォルダ："${dest_dir_root}

# すべてのファイルに対して処理
# 配列すべての要素を列挙する際には[@]を使う
find ${source_dir[@]} -type f -name *.csv | while read -r file_name_full; do
    # shellコマンドを実行した結果を変数に代入する場合は、``をつける
    file_name_original=`basename ${file_name_full}`
    echo "** file_name_original is :" $file_name_original
    # 例：FX_RESULT_20210331.csvの場合、 \1-> FX_RESULT
    file_name_prefix=`echo ${file_name_original}|sed -e "s/\(.\+\)\([0-9]\{8\}\)\.csv/\1/g"`
    # 書き方注意：文字列切り出し後の実行結果をfile_name_prefixに代入するには必ず``で囲むこと
    # echo " file_name_prefix is : " $file_name_prefix
    base_date=`echo ${file_name_original}|sed -e "s/\(.\+\)\([0-9]\{8\}\)\.csv/\2/g"`
    # echo " base_date is :" ${base_date}
    # 日付計算 new_date = base_date -1を算出
    new_date=`date -d"${base_date} 1 days ago" +%Y%m%d`

    # 元ファイルの日付部分を基準日とし、その基準日の前日から十日までの日付に置き換えて元ファイルをコピーする
    for i in {0..10}
        do
            # echo "new_date is" ${new_date}
            file_name_new=${file_name_prefix}${new_date}".csv"
            # echo " file_name_new is" "${source_dir}\\${file_name_new}"
            dest_dir="${dest_dir_root}\\${prefix_dir}${new_date}"
            # echo "new dest_dir is" ${dest_dir}

            # 日付付きのサブディレクトリを作成
            mkdir ${dest_dir}
            cp "${source_dir}\\${file_name_original}" "${dest_dir}\\${file_name_new}"

            # ファイルの一部の日付データを一括置換
            sed -i s/$base_date/$new_date/g "${dest_dir}\\{file_name_new}"
            # なぜか置換後に改行コードがLFになったのでCRLFに戻す
            sed -i 's/$/\r/g' "${dest_dir}\\${file_name_new}"

            echo " copy from ${file_name_original} --> ${file_name_new}"
            new_date=`date -d"${new_date} 1 days " + %Y%m%d`
        done
done
