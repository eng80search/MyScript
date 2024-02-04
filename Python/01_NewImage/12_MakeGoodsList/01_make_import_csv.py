import glob
import json
import logging
import os
import re
import sys
import traceback
import pandas as pd
import csv


# カレントディレクトリのconstant.pyをimport
import constant
from constant import ConstProduct as const

#  概要： 商品登録用Excelのシートから商品登録に必要なcsvファイルを作成する

# INPUT
# 01_make_商品登録(sku対応).xlsx

# OUTPUT
# 10_product.csv
# 11_color.csv
# 12_size.csv


def make_product_csv(df_product):
    """product.csvを作成する

    """
    print(df_product)
    # 10_product.csvファイルを出力する
    df_product.to_csv("../_import_data/"+const.IMPORT_CSV_PRODUCT, 
                            columns=[const.COL_INDEX_商品_商品管理番号, 
                            const.COL_INDEX_商品_商品番号], 
                            encoding='shift-jis', 
                            quoting=csv.QUOTE_NONNUMERIC,
                            index=False)


def make_color_csv(df_color):
    """color.csvを作成する

    """
    print(df_color)
    # 11_color.csvファイルを出力する
    df_color.to_csv("../_import_data/"+const.IMPORT_CSV_COLOR, 
                            columns=[const.COL_INDEX_商品色_商品番号,  
                            const.COL_INDEX_商品色_日本語, 
                            const.COL_INDEX_商品色_英語,  
                            const.COL_INDEX_商品色_表示順], 
                            encoding='shift-jis', 
                            quoting=csv.QUOTE_NONNUMERIC,
                            index=False)


def make_size_csv(df_size):
    """size.csvを作成する

    """
    print(df_size)
    # 12_size.csvファイルを出力する
    df_size.to_csv("../_import_data/"+const.IMPORT_CSV_SIZE, 
                            columns=[const.COL_INDEX_商品サイズ_商品番号, 
                            const.COL_INDEX_商品サイズ_サイズ, 
                            const.COL_INDEX_商品サイズ_表示順], 
                            encoding='shift-jis', 
                            quoting=csv.QUOTE_NONNUMERIC,
                            index=False)


def make_import_csv():
    """商品登録(sku対応)時に使用される三つのcsvファイルを作成

    :arg1: TODO
    :returns: TODO

    """
    try:
        print("********** product,color,sizeのCSVファイル作成処理を開始しました **********")
        df_sheet_all = pd.read_excel('../'+const.INPUT_EXCEL, 
                            sheet_name=[const.INPUT_SHEET_PRODUCT,
                            const.INPUT_SHEET_COLOR,
                            const.INPUT_SHEET_SIZE])

        make_product_csv(df_sheet_all[const.INPUT_SHEET_PRODUCT])
        print("*** [1]. "+const.IMPORT_CSV_PRODUCT+"を作成しました。"+'\n')

        make_color_csv(df_sheet_all[const.INPUT_SHEET_COLOR])
        print("*** [2]. "+const.IMPORT_CSV_COLOR+"を作成しました。"+'\n')

        make_size_csv(df_sheet_all[const.INPUT_SHEET_SIZE])
        print("*** [3]. "+const.IMPORT_CSV_SIZE+"を作成しました。"+'\n')

        print("********** product,color,sizeのCSVファイル作成処理を終了しました **********")
    except Exception as e:
        print("********** Error! product,color,sizeのCSVファイル作成処理が異常終了しました **********")
        print(traceback.format_exc())
        sys.exit(1)

if __name__ == "__main__":
    make_import_csv()
