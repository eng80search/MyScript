import pandas as pd
import csv
import json

"""
機能：強制地図位置解除施設一覧シートで本番環境に解除する施設と
      QA取り戻し施設の一覧を抽出する
"""
#  json設定ファイルから必要情報を取得
with open("settings_DbOracle.json", "r", encoding="utf-8") as json_file:
    json_data = json.loads(json_file.read())

    EXCEL_PATH = json_data["EXCEL_PATH"]
    EXCEL_OUTPUT = json_data["EXCEL_OUTPUT"]
    KAIJYO_CLINIC_ID_SHEET = json_data["KAIJYO_CLINIC_ID_SHEET"]
    QA_SQL_KAIJYO = json_data["QA_SQL_KAIJYO"]

#  強制地図位置解除施設一覧シートの全データをpandasに読み込む
df_sheet_kaijyo_source = pd.read_excel(
    EXCEL_PATH,
    sheet_name=KAIJYO_CLINIC_ID_SHEET,
    usecols=[1, 12, 13, 14],
    names=["FLG_KAIJYO", "CLINIC_ID", "STORE_SEQ", "STORE_NAME"],
)

#  本番環境にて強制変更対象になるデータのみを絞り込む
df_sheet_kaijyo_index_hon = df_sheet_kaijyo_source.query('FLG_KAIJYO=="○"')

#  QA環境へ解除済sqlをファイルをpandasに読み込み indexは0始まり
df_sheet_kaijyo_index_qa = pd.read_excel(
    EXCEL_PATH,
    sheet_name=QA_SQL_KAIJYO,
    usecols=[1, 2, 3, 4, 5, 6, 7, 8],
    names=[
        "CLINIC_ID",
        "LATITUDE_B",
        "LONGITUDE_B",
        "MATCHINGLEVEL",
        "MATCHFLAG",
        "ADDRESSFLAG",
        "ADDRESSCODE",
        "ADDRESS",
    ],
)

#  QA取り戻し用一覧と本番環境へ反映する店舗リストを特定するために、テーブルを結合する
df_sheet_join = pd.merge(
    df_sheet_kaijyo_index_qa, df_sheet_kaijyo_index_hon,
    on="CLINIC_ID", how="left"
)

#  print(df_sheet_join)

#  QA環境戻し用clinicID一覧を抽出
df_sheet_qa_revert = df_sheet_join.query('FLG_KAIJYO!="○"')
#  print(df_sheet_qa_revert)
#  本番環境適用clinicID一覧を抽出
df_sheet_hon_commit = df_sheet_join.query('FLG_KAIJYO=="○"')
#  print(df_sheet_hon_commit)

#  結果確認
print("-------sql_qa_revert--------------")
print(df_sheet_qa_revert)
print("-------sql_hon_commit--------------")
print(df_sheet_hon_commit)

#  出力用Excelに本番環境コミット用とQA取り戻し用クエリを書き出す
with pd.ExcelWriter(EXCEL_OUTPUT) as writer:
    df_sheet_hon_commit.to_excel(writer, sheet_name="Hon_commit")
    df_sheet_qa_revert.to_excel(writer, sheet_name="QA_revert")

#  #  出力用Excelに本番環境コミット用とQA取り戻し用クエリを書き出す
#  df_sheet_hon_commit.to_excel(EXCEL_OUTPUT, sheet_name='Hon_commit')
#  df_sheet_qa_revert.to_excel(EXCEL_OUTPUT, sheet_name="QA_revert")

# 特定行の全部を確認
#  print(df_sheet_join.loc[[0]])

# 特定行の特定列を確認
#  print(df_sheet_kaijyo_sql_all.loc[0,'SQL'])
