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

#  概要： 商品登録時に使われるcsvファイルを作成する

# INPUT
# 01_make_商品登録(sku対応).xlsx
# 10_product.csv
# 11_color.csv
# 12_size.csv (MariaDBから作成される)
# 21_sku_kanri.csv (MariaDBから作成される)

# OUTPUT
# normal-item.csv"


def make_header(df_out_header, df_input_product, df_value_variation):
    """商品登録時に使用されるCSVファイルのヘッダーを作成する

    """

    col_index_商品管理番号 = df_input_product.columns.get_loc('商品管理番号')
    col_index_商品番号 = df_input_product.columns.get_loc('商品番号')
    col_index_商品名 = df_input_product.columns.get_loc('商品名')
    col_index_キャッチコピー = df_input_product.columns.get_loc('キャッチコピー')
    col_index_PC用商品説明文 = df_input_product.columns.get_loc('PC用商品説明文')
    col_index_スマートフォン用商品説明文 =\
                    df_input_product.columns.get_loc('スマートフォン用商品説明文')
    col_index_PC用販売説明文 = df_input_product.columns.get_loc('PC用販売説明文')

    col_index_色 = df_value_variation.columns.get_loc('色')
    col_index_サイズ = df_value_variation.columns.get_loc('サイズ')

    var_商品管理番号 = df_input_product.iat[0, col_index_商品管理番号]
    var_商品番号 = df_input_product.iat[0, col_index_商品番号]
    var_商品名 = df_input_product.iat[0, col_index_商品名]
    var_キャッチコピー = df_input_product.iat[0, col_index_キャッチコピー]
    var_PC用商品説明文 = df_input_product.iat[0, col_index_PC用商品説明文]
    var_スマートフォン用商品説明文 = df_input_product.iat[0, col_index_スマートフォン用商品説明文]
    var_PC用販売説明文 = df_input_product.iat[0, col_index_PC用販売説明文]
    # print(var_商品管理番号)

    var_色 = df_value_variation.iat[0, col_index_色]
    var_サイズ = df_value_variation.iat[0, col_index_サイズ]

    # 1行、２列のdataframeに値を設定するときの、書き方（まだよく分からん）
    # よく分からないけど、[[]]で囲む valuesでseriesに変換しなければならない
    series_values_variation = df_value_variation[[r'バリエーション1選択肢定義',
                                                  r'バリエーション2選択肢定義']].values
    df_out_header.loc['0':'0', [r'バリエーション1選択肢定義',
                                r'バリエーション2選択肢定義']] = series_values_variation

    # locで行インデックスおよび列名でdataframeを指定する
    df_out_header.loc[:, '商品管理番号（商品URL）'] = var_商品管理番号
    df_out_header.loc['0':'0', '商品番号'] = var_商品番号
    df_out_header.loc['0':'0', '商品名'] = var_商品名
    df_out_header.loc['0':'0', 'キャッチコピー'] = var_キャッチコピー
    df_out_header.loc['0':'0', 'PC用商品説明文'] = var_PC用商品説明文
    df_out_header.loc['0':'0', 'スマートフォン用商品説明文'] = var_スマートフォン用商品説明文
    df_out_header.loc['0':'0', 'PC用販売説明文'] = var_PC用販売説明文

    # dataframeの文字列の一部のみ置換するときはregex=Trueに設定
    df_out_header.replace(const.EXPORT_商品番号, var_商品番号, 
                             regex=True, inplace=True)

    df_out_header.replace(const.EXPORT_色, var_色, 
                             regex=True, inplace=True)

    df_out_header.replace(const.EXPORT_サイズ, var_サイズ, 
                             regex=True, inplace=True)


def make_goods_list(df_out_goods, df_input_product,
                    df_value_goods,
                    df_value_variation):
    """商品登録時に使用されるCSVファイルの商品リストを作成する
        df_out_goods: 最終出力csv
        df_input_product: 商品番号DataFrame
        df_value_goods: 一つの商品番号の商品リスト
    """

    # dataframeの行数を取得
    count_goods = df_out_goods.shape[0]
    half_count_goods = int(count_goods/2)

    col_index_商品管理番号 = df_input_product.columns.get_loc('商品管理番号')
    col_index_販売価格 = df_input_product.columns.get_loc('販売価格')
    col_index_表示価格 = df_input_product.columns.get_loc('表示価格')
    col_index_在庫数_即納 = df_input_product.columns.get_loc('在庫数_即納')
    col_index_在庫数_12営業日 = df_input_product.columns.get_loc('在庫数_12営業日')
    col_index_バリエーション1選択肢定義 = \
            df_value_variation.columns.get_loc('バリエーション1選択肢定義')
                                        

    var_商品管理番号 = df_input_product.iat[0, col_index_商品管理番号]
    var_販売価格 = df_input_product.iat[0, col_index_販売価格]
    var_表示価格 = df_input_product.iat[0, col_index_表示価格]
    var_在庫数_即納 = df_input_product.iat[0, col_index_在庫数_即納]
    var_在庫数_12営業日 = df_input_product.iat[0, col_index_在庫数_12営業日]
    var_バリエーション1選択肢定義 = df_value_variation.iat[0,
                                        col_index_バリエーション1選択肢定義]

    df_out_goods.loc[:, r'商品管理番号（商品URL）'] = var_商品管理番号
    df_out_goods.loc[:, r'販売価格'] = var_販売価格
    df_out_goods.loc[:, r'表示価格'] = var_表示価格

    series_values_goods = df_value_goods[[
                                    "SKU管理番号",
                                    "システム連携用SKU番号",
                                    "バリエーション項目キー1",
                                    "バリエーション項目選択肢1",
                                    "バリエーション項目キー2",
                                    "バリエーション項目選択肢2"
                                ]].values

    df_out_goods.loc[:, [
                        r'SKU管理番号',
                        r'システム連携用SKU番号',
                        r'バリエーション項目キー1',
                        r'バリエーション項目選択肢1',
                        r'バリエーション項目キー2',
                        r'バリエーション項目選択肢2'
                        ]] = series_values_goods

    # 在庫数を設定
    col_index_在庫数 = df_out_goods.columns.get_loc('在庫数')
    # iloc: 0行から3行までの場合 iloc[0,4]
    df_out_goods.iloc[0:half_count_goods, [col_index_在庫数]] = var_在庫数_即納
    df_out_goods.iloc[half_count_goods:count_goods+1, 
                            [col_index_在庫数]] = var_在庫数_12営業日

    df_out_goods.loc[:, r'商品属性（値）1'] = var_バリエーション1選択肢定義

    # print("----")
    # print(df_out_goods)


def make_out_csv():
    """商品登録時に使用されるCSVファイルを作成する

    :arg1: TODO
    :returns: TODO

    """
    try:
        print("********** normal-item.csv作成処理を開始しました **********")
        # 商品登録用Excelファイルを取り込む
        df_input_all = pd.read_excel('../'+const.INPUT_EXCEL, 
                            sheet_name=[const.INPUT_SHEET_PRODUCT,
                            const.INPUT_SHEET_COLOR,
                            const.INPUT_SHEET_SIZE])

        # 出力csvテンプレートファイルを読み込む
        df_out_template = pd.read_csv("../_template/"+const.IMPORT_CSV_ITEM,
                encoding='shift-jis')

        # headerがないcsvを取り込む
        df_value_variation_no_header = pd.read_csv("../_import_data/"+const.IMPORT_CSV_VARIATION, 
                encoding='shift-jis',
                header=None)

        # headerをつける 注意！valuesを付けなければならない！
        # print(df_value_variation_no_header.values)
        df_value_variation_all = pd.DataFrame(df_value_variation_no_header.values,
                                columns=[
                                    "商品番号", 
                                    "SKU管理番号",
                                    "バリエーション1選択肢定義",
                                    "バリエーション2選択肢定義",
                                    "色",
                                    "サイズ"
                                    ]).copy()

        # headerがないcsvを取り込む
        df_value_goods_no_header = pd.read_csv("../_import_data/"+const.IMPORT_CSV_KANRI,
                encoding='shift-jis',
                header=None)
        # headerをつける
        df_value_goods_all = pd.DataFrame(df_value_goods_no_header.values,
                                columns=[
                                    "商品番号",
                                    "SKU管理番号",
                                    "システム連携用SKU番号",
                                    "バリエーション項目キー1",
                                    "バリエーション項目選択肢1",
                                    "バリエーション項目キー2",
                                    "バリエーション項目選択肢2"
                                    ])

        df_out_all = pd.DataFrame()

        # normal-item.csv作成処理開始
        df_input_product_all = df_input_all[const.INPUT_SHEET_PRODUCT]
        # print(df_input_product_all)
        for i in range(len(df_input_product_all)):

            var_商品番号 = df_input_product_all.at[i, '商品番号']
            # dataframeを取得
            df_input_product = df_input_product_all.query('商品番号 in @var_商品番号')
            df_value_goods = df_value_goods_all.query('商品番号 in @var_商品番号')
            df_value_variation = df_value_variation_all.query('商品番号 in @var_商品番号')
            # print("-- df_value_goods --")
            # print(df_value_goods)

            # 先頭2行(0行,1行)をヘッダー行として切り出す
            df_out_header = df_out_template.iloc[0:2, :].copy()
            # 一番最初の行(0行)を選択の場合は iloc[0:1, :]
            make_header(df_out_header, df_input_product, df_value_variation)

            # 商品リストdataframeを初期化 第3行目を切り出す
            df_out_goods_unit = df_out_template.iloc[2:3, :].copy()
            # print(df_out_goods_unit)

            df_out_goods = pd.DataFrame()
            for j in range(len(df_value_goods)):
                df_out_goods = df_out_goods.append(df_out_goods_unit)

            make_goods_list(df_out_goods, df_input_product,
                            df_value_goods, df_value_variation)

            # ヘッダーおよび商品リストを結合させる
            df_out_all = df_out_all.append([df_out_header, df_out_goods])

        # normal-item.csvを出力する
        df_out_all.to_csv("../"+const.EXPORT_CSV, 
                                encoding='shift-jis',
                                quoting=csv.QUOTE_NONNUMERIC,
                                float_format='%d',
                                index=False)

        # print(const.EXPORT_CSV+"を作成しました。"+'\n')
        print(df_out_all)

        print("********** normal-item.csv作成処理を終了しました **********")
    except Exception as e:
        print("********** Error! normal-item.csv作成処理が異常終了しました **********")
        print(traceback.format_exc())
        sys.exit(1)

if __name__ == "__main__":
    make_out_csv()
