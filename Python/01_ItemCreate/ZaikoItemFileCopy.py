import glob
import json
import logging
import os
import re
import sys
import traceback

import pandas as pd


#  自分より上のフォルダにあるモジュールを参照するために必要な設定
sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
import my_lib

#  仕様： 在庫ロボット用ファイルは指定のフォルダから目的フォルダへコピー
#         対象のコピー元フォルダ： (例) A210822-213
#         対象のファイル： item.csv select.csv

#         コピー先フォルダ： コピー元フォルダ名と同じ
#         対象のファイル： item-213.csv select-213.csv
#         select-213.csvファイルは以下の2列が追加される
#           1.[在庫あり時納期管理番号]
#            値の決め方：
#                  IF [項目選択肢別在庫用在庫数]=0:   Value = 1000
#                  IF [項目選択肢別在庫用在庫数]=100: Value = 1
#           2.[在庫切れ時納期管理番号]
#            値の決め方：
#                  [値なし]

#  他に考慮すべき点
#  1. エラーはログに吐く

#  必要なライブラリをインポート
_fileio = my_lib.FileIo()


def make_product_csv_files(df, root_path):
    """DBインポート用のproductNo.csv product-zaiko.csv 
                       productColor.csvファイルを作成

    :df: ファイル作成に必要なdataframe
    :root_path: ファイルが作成されるディレクトリ
    :returns: TODO

    """

    #  productNo.csvを作成
    csv_product_no = "productNo.csv"
    csv_product_no = _fileio.combine_file_path(root_path, csv_product_no)
    #  loc: 特定の行と列を取得 [:, : すべての行  ['商品番号'・・・] : 特定の列
    df_product_no = df.loc[:, ['商品番号', '商品管理番号（商品URL）']].drop_duplicates()
    #  列名変更
    df_product_no = df_product_no.rename(columns={'商品管理番号（商品URL）': '商品管理番号'})
    df_product_no.to_csv(
            csv_product_no, mode='w', encoding='cp932', index=False)

    log_info = "     ==make file [{0}] ".format(csv_product_no)
    print(log_info)
    logging.info(log_info)

    #  product-zaiko.csvを作成
    csv_product_zaiko = "product-zaiko.csv"
    csv_product_zaiko = _fileio.combine_file_path(root_path, csv_product_zaiko)
    df_product_zaiko = df.loc[:, 
                        ['商品番号', 
                         '項目選択肢別在庫用縦軸選択肢', 
                         '項目選択肢別在庫用縦軸選択肢子番号', 
                         '項目選択肢別在庫用在庫数']
                        ].drop_duplicates()
    #  列名変更
    df_product_zaiko = df_product_zaiko.rename(
            columns={
                '項目選択肢別在庫用縦軸選択肢': '商品在庫_日本語', 
                '項目選択肢別在庫用縦軸選択肢子番号': '商品在庫_英語', 
                '項目選択肢別在庫用在庫数': '商品在庫_数量'
                     })
    df_product_zaiko.to_csv(
            csv_product_zaiko, mode='w', encoding='cp932', index=False)

    log_info = "     ==make file [{0}] ".format(csv_product_zaiko)
    print(log_info)
    logging.info(log_info)

#  productColor.csvを作成

    #  product-zaiko.csvを作成
    csv_product_color = "productColor.csv"
    csv_product_color = _fileio.combine_file_path(root_path, csv_product_color)
    df_product_color = df.loc[:, 
                        ['商品番号', 
                         '項目選択肢別在庫用横軸選択肢', 
                         '項目選択肢別在庫用横軸選択肢子番号']
                        ].drop_duplicates()
    #  列名変更
    df_product_color = df_product_color.rename(
            columns={
                '項目選択肢別在庫用横軸選択肢': '商品色_日本語', 
                '項目選択肢別在庫用横軸選択肢子番号': '商品色_英語' 
                     })
    df_product_color.to_csv(
            csv_product_color, mode='w', encoding='cp932', index=False)

    log_info = "     ==make file [{0}] ".format(csv_product_color)
    print(log_info)
    logging.info(log_info)

def add_column_to_select_file(csv_file):
    """select.csvファイルに列を追加

    :csv_file: TODO
    :returns: TODO

    """

    #  windows系のcsvファイルを読み込む際にはencodingを指定すべき
    df = pd.read_csv(csv_file, encoding='cp932')
    #  新規列を追加、既存の列の値から新規列の値を設定する
    #  強力な機能！一行ですべて行に対して処理を行う
    df['在庫あり時納期管理番号'] = df['項目選択肢別在庫用在庫数'].apply(
                                    lambda x: 1000 if x == 0 else 1)
    df['在庫切れ時納期管理番号'] = ''

    #  既存のselect.csvを上書きする mode='w' 意味はなければ新規作成、あれば上書き
    df.to_csv(csv_file, mode='w', encoding='cp932', index=False)

def zaiko_item_file_copy():
    """在庫ロボット登録用ファイル2つをテンプレートフォルダからコピーし、
       select.csvファイルは2列追加する
       item.csvファイルはそのままコピー

    :arg1: 
    :returns: 

    """
    try:

        #  設定ファイルから各パラメータを取得する
        with open(
            "settings_zaikoItemFileCopy.json", "r", encoding="utf-8"
        ) as json_file:
            json_data = json.loads(json_file.read())

            zaiko_csv_temp_root_path = json_data["zaiko_csv_temp_root_path"]
            zaiko_csv_dest_root_path = json_data["zaiko_csv_dest_root_path"]
            log_file_path = json_data["log_file_path"]
            log_file_name = json_data["log_file_name"]

        log_file_full_path = os.path.join(log_file_path, log_file_name)

        #  ログ設定
        formatter = "%(levelname)s : %(asctime)s : %(message)s"
        logging.basicConfig(
            filename=log_file_full_path, level=logging.INFO, format=formatter
        )

        #  コピー元フォルダからテンプレートファイルをコピーする
        #  カレントディレクトリをコピー元フォルダに変更
        PATH = zaiko_csv_temp_root_path
        os.chdir(PATH)

        log_info = "## zaiko_source_dir_root : {0}".format(PATH)
        print(log_info)
        logging.info(log_info)

        #  内包表記でパターンにマッチングするフォルダだけ処理(サブフォルダは対象外)
        dir_list = [
            p
            for p in glob.iglob("**")
            if re.search("(^[A-Z]\d{6})-(\d{3})(-([A-Z]{2}))?$", p)
        ]

        for zaiko_source_dir in dir_list:
            #  glob関数は特定のパターンにマッチするファイルを取得
            #  zaiko_source_dir + "/*"の意味はzaiko_source_dirの直下のファイルリスト
            zaiko_soure_files = [
                p
                for p in glob.iglob(zaiko_source_dir + "/*")
                if re.search(
                    r"(^item\.csv)|(^select\.csv)", os.path.basename(p), re.IGNORECASE) ]

            log_info = "** zaiko_source dir: {0} ".format(zaiko_source_dir)
            print(log_info)
            logging.info(log_info)

            #  コピー先のフォルダを作成する(既にあればそのまま)
            zaiko_csv_dest_path = _fileio.combine_file_path(
                zaiko_csv_dest_root_path, zaiko_source_dir)
            _fileio.make_dirs(zaiko_csv_dest_path)

            #  split("-",1)は一回のみ分割するとの意味 A12-01-Aは["A12", "01-A"]
            dir_suffix = zaiko_source_dir.split("-", 1)[1]

            #  data frameを初期化 初期化すると行数は0
            df_item = pd.DataFrame()
            df_select = pd.DataFrame()
            df_all = pd.DataFrame()

            #  item.csv select.csvファイルをコピーする
            for i, zaiko_source_file in enumerate(zaiko_soure_files):

                zaiko_dest_file = _fileio.get_filename_without_extention(zaiko_source_file)
                #  ファイル名を変更する
                zaiko_dest_file += "-" + dir_suffix + "-z.csv"
                zaiko_dest_file = _fileio.combine_file_path(zaiko_csv_dest_path, zaiko_dest_file)

                log_info = "     --copy from [{0}] -> to [{1}]".format(
                        zaiko_source_file, zaiko_dest_file)
                print(log_info)
                logging.info(log_info)

                #  例：在庫ロボットフォルダ名 : A210822-212の場合
                #  select.csv -> select-212.csv(ファイルに新たに２列追加)
                #  item.csv -> item-212.csv(ファイルコピーのみ)
                _fileio.copy_file(zaiko_source_file, zaiko_dest_file)

                if os.path.basename(zaiko_source_file) == "select.csv":
                    #  selectファイルの列を追加する
                    add_column_to_select_file(zaiko_dest_file)
                    #  csvファイルからdataframeを作成する
                    df_select = pd.read_csv(zaiko_source_file, encoding='cp932')

                elif os.path.basename(zaiko_source_file) == "item.csv":
                    df_item = pd.read_csv(zaiko_source_file, encoding='cp932')

                else:
                    pass

            #  dataframeにデータが入った場合のみ、DBインポート用csvファイルを作成する
            #  dataframeの行数チェックはlen(df) ヘッダのみの場合は0 ファイルがnull時はエラー
            if len(df_item) > 0 and len(df_select) > 0:
                #  ２つのdataframeをleft join
                df_all = pd.merge(df_item, df_select, on='商品管理番号（商品URL）', how='left')
                make_product_csv_files(df_all, zaiko_csv_dest_path)

            #  データがない場合は、警告メッセージを出力
            else:
                log_info = "     --Warning! Not Created CSV file For DB import in {0}".format( 
                        zaiko_csv_dest_path)
                print(log_info)
                logging.info(log_info)


    except Exception as e:
        print(traceback.format_exc())
        logging.error(traceback.format_exc())


if __name__ == "__main__":
    zaiko_item_file_copy()
