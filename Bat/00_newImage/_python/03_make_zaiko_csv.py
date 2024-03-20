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

#  概要： normal-item.csvから在庫ロボット用のcsvファイルを作成する

# INPUT
# normal-item.csv"

# OUTPUT
# zr_select-600.csv
# zr-normal-item_600.csv


def make_one_zaiko(df_out_zaiko, df_normal_head, df_normal_goods):
    """一つの商品の在庫ロボットデータを作成する
        df_normal_head: 一つの商品に一つ
        df_normal_goods: 色、サイズ毎にデータがあるので、複数
    """

    col_index_商品番号 = df_normal_head.columns.get_loc('商品番号')
    var_商品番号 = df_normal_head.iat[0, col_index_商品番号]

    # 一つの列から一部のみ抽出して他の列に設定する際の書き方
    # expand=Falseでseries型になる (.+)のように括弧で囲んだものが抽出結果になる
    df_out_zaiko.loc[:, [
        r'ＮｅｗＩｍａｇｅ　Ｑoo10オプションコード'
        ]] = df_normal_goods['システム連携用SKU番号'].str.extract(var_商品番号 + '(.+)',
                                                                  expand=False).values

    df_out_zaiko.loc[:, [
        r'newimage2項目値1',
        r'newimage2項目値2'
        ]] = df_out_zaiko['ＮｅｗＩｍａｇｅ　Ｑoo10オプションコード'].str.extract(
                            '(.+)(f/a|f/b)', expand=False).values

    # 複数の列に同じ値を設定するときに、以下のように書く
    df_out_zaiko.loc[:, [
                r'親商品コード(新規登録時使用)',
                r'newimage2商品番号(閲覧用)',
                r'ＮｅｗＩｍａｇｅ　Ｑoo10コード'
        ]] = var_商品番号

    # 一つのDataFrameから他のDataFrameへのコピー書き方
    # ただし、前提として二つのDataFrameの行数が一致する必要がある
    df_out_zaiko.loc[:, [
                r'コード(更新時使用)',
                r'在庫数',
                r'newimage2zaiko RobotSKUコード(自動生成/更新可)',
                r'newimage2商品管理番号(URL)(閲覧用)',
                r'newimage2SKU管理番号',
                r'newimage2システム連携用SKU番号',
                r'newimage2項目1',
                r'newimage2項目2',
                r'ＮｅｗＩｍａｇｅ　Ｑoo10項目1',
                r'ＮｅｗＩｍａｇｅ　Ｑoo10項目2',
                r'ＮｅｗＩｍａｇｅ Shoplistコード',
                r'ＮｅｗＩｍａｇｅ Shoplist項目1',
                r'ＮｅｗＩｍａｇｅ Shoplist項目2'
        ]] = df_normal_goods[[
                r'システム連携用SKU番号',
                r'在庫数',
                r'システム連携用SKU番号',
                r'商品管理番号（商品URL）',
                r'SKU管理番号',
                r'システム連携用SKU番号',
                r'バリエーション項目選択肢1',
                r'バリエーション項目選択肢2',
                r'バリエーション項目選択肢1',
                r'バリエーション項目選択肢2',
                r'システム連携用SKU番号',
                r'バリエーション項目選択肢1',
                r'バリエーション項目選択肢2'
        ]].values


def make_zaiko_csv():
    """在庫ロボットCSVファイルを作成する

    :arg1: TODO
    :returns: TODO

    """
    try:
        print("********** zr_select.csv作成処理を開始しました **********")

        # 出力csvテンプレートファイルを読み込む
        df_template_zaiko = pd.read_csv("../_template/"+const.ZAIKO_SELECT_TEMPLATE_CSV,
                                        encoding='shift-jis')
        # 在庫ロボットを作成する際に元になるファイル
        df_normal_item = pd.read_csv("../"+const.EXPORT_CSV, encoding='shift-jis')
        # 在庫ロボットの出力データ
        df_out_zaiko = pd.DataFrame()

        # 商品番号がある列がheader
        df_normal_head_all = df_normal_item.query('商品番号.notnull()')
        # print(df_normal_head_all['商品番号'])
        var_開始商品番号 = df_normal_head_all['商品番号'].max().split('-')[1]
        var_終了商品番号 = df_normal_head_all['商品番号'].min().split('-')[1]

        if var_開始商品番号 != var_終了商品番号:
            const.ZAIKO_SELECT_OUT_CSV = const.ZAIKO_SELECT_OUT_CSV.replace('{開始商品番号}',
                            str(var_開始商品番号)).replace('{終了商品番号}', str(var_終了商品番号))
        else:
            const.ZAIKO_SELECT_OUT_CSV = const.ZAIKO_SELECT_OUT_CSV.replace('{開始商品番号}',
                            str(var_開始商品番号)).replace('-{終了商品番号}', '')


        col_index_商品管理番号 = \
                        df_normal_item.columns.get_loc('商品管理番号（商品URL）')
        col_index_商品番号 = df_normal_item.columns.get_loc('商品番号')

        # normal_itemのheader単位で在庫ロボット用のデータを作成する
        for i in range(len(df_normal_head_all)):

            # 商品管理番号（商品URL）はすべてのデータに存在するもの
            var_商品管理番号 = df_normal_head_all.iat[i, col_index_商品管理番号]
            print("var_商品管理番号=" + str(var_商品管理番号))
            # 商品番号は一つの商品(複数のサイズ、色)に一つしかない
            var_商品番号 = df_normal_head_all.iat[i, col_index_商品番号]

            df_normal_head = df_normal_item.query('商品番号 == @var_商品番号')
            # df_normal_goods = df_normal_item.query('商品管理番号（商品URL） == @var_商品管理番号 & 商品番号 == ""')
            df_normal_goods = df_normal_item[(df_normal_item['商品管理番号（商品URL）'] == var_商品管理番号) &
                                             (df_normal_item['商品番号'].isnull()) &
                                             (df_normal_item['SKU管理番号'].notnull())]

            # print("df_normal_goods")
            # print(df_normal_goods)
            # 在庫ロボットのテンプレートから最初の1行(index=0)をコピーする
            # ilocの見方：index=0の行から1の前まで。注意：1は含まれていない
            df_out_zaiko_unit = df_template_zaiko.iloc[0:1, :].copy()

            # zr_selectの行数をnormal_item分の行数分作成する
            for j in range(len(df_normal_goods)):
                df_out_zaiko = pd.concat([df_out_zaiko, df_out_zaiko_unit])

            make_one_zaiko(df_out_zaiko, df_normal_head, df_normal_goods)

        # zr_select-600-cr.csvを出力する
        df_out_zaiko.to_csv("../"+const.ZAIKO_SELECT_OUT_CSV,
                            encoding='shift-jis',
                            quoting=csv.QUOTE_NONE,
                            float_format='%d',
                            index=False)

        # print(const.EXPORT_CSV+"を作成しました。"+'\n')
        print(df_out_zaiko)
        print("********** zr_select.csv作成処理を終了しました **********")

    except Exception as e:
        print("********** Error! zr_select.csv作成処理が異常終了しました **********")
        print(traceback.format_exc())
        sys.exit(1)


if __name__ == "__main__":
    make_zaiko_csv()
