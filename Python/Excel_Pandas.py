import pandas as pd

#  定数定義
EXCEL_PATH = 'E:\\00_OurFamily\\_work\\77_Github_Temp_Private\\2020508_最新マッチングレベル一覧(解除対象.xlsx'
EXCEL_OUTPUT = 'E:\\00_OurFamily\\_work\\77_Github_Temp_Private\\2020508_本番SQL出力結果.xlsx'
EXCEL_OUTPUT_REVERT = 'E:\\00_OurFamily\\_work\\77_Github_Temp_Private\\2020508_QA取り戻し出力結果.xlsx'
KAIJYO_CLINIC_ID_SHEET = '強制地図位置解除施設一覧'
QA_SQL_KAIJYO = 'work(QA)_強制地図位置解除クエリ'

#  Excelファイルをpandasに読み込み
df_sheet_kaijyo_index_all = pd.read_excel(EXCEL_PATH,
                                         sheet_name=KAIJYO_CLINIC_ID_SHEET,usecols=[1,12,15,16],
                                         names=['FLG_KAIJYO','CLINIC_ID','STORE_SEQ','STORE_NAME'])

#  強制変更対象になるデータを絞り込む
df_sheet_kaijyo_index = df_sheet_kaijyo_index_all.query('FLG_KAIJYO=="〇"')


#  Excelファイルをpandasに読み込み
df_sheet_kaijyo_sql_all = pd.read_excel(EXCEL_PATH,
                                         sheet_name=QA_SQL_KAIJYO,usecols=[1,2,3,4,5,6,7,8],
                                         names=['CLINIC_ID','LATITUDE_B','LONGITUDE_B','MATCHINGLEVEL','MATCHFLAG','ADDRESSFLAG','ADDRESSCODE','ADDRESS'])

df_sheet_kaijyo_sql_hon = pd.merge(df_sheet_kaijyo_index,df_sheet_kaijyo_sql_all,
                                    on='CLINIC_ID', how='left')

#  QA環境で強制変更から元に戻すデータを絞り込む
df_sheet_sql_all = pd.merge(df_sheet_kaijyo_index,df_sheet_kaijyo_sql_all,
                                    on='CLINIC_ID', how='outer')
df_sheet_sql_revert = df_sheet_sql_all.query('FLG_KAIJYO!="〇"')

#  結果確認
print('-------df_sheet_kaijyo_index--------------')
#  print(df_sheet_kaijyo_index)
print(df_sheet_sql_revert)
#  print(df_sheet_kaijyo_sql_all)
#  print(df_sheet_kaijyo_sql_hon)

#  Excelに書き出す
#  df_sheet_kaijyo_sql_hon.to_excel(EXCEL_OUTPUT,sheet_name='honban')
df_sheet_sql_revert.to_excel(EXCEL_OUTPUT_REVERT,sheet_name='QA_revert')

# 特定行の全部を確認
#  print(df_sheet_kaijyo_sql_all.loc[[0]])
#  print(df_sheet_kaijyo_sql_hon.loc[[0]])

# 特定行の特定列を確認
#  print(df_sheet_kaijyo_sql_all.loc[0,'SQL'])
