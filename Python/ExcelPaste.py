import openpyxl
import os

wb = openpyxl.load_workbook(r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\20200205_強制地図位置解除対象リスト_61-80.xlsx')
#  wb = openpyxl.load_workbook(r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\20200205_強制地図位置解除対象リスト_81-100.xlsx')
#  wb = openpyxl.load_workbook(r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\20200205_強制地図位置解除対象リスト_100-108.xlsx')

#Debug用
print('処理を開始します')

#  定数
FILE_ROOTPATH_QA = r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\Image_QA'
FILE_ROOTPATH_HON = r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\Image_Hon'

#  変数定義

#  シート名と画像名ペア
dic_work_sheet = {
                    "sheet1": (wb['1']  ,'47605.PNG'),
                    "sheet2": (wb['2']  ,'47734.PNG'),
                    "sheet3": (wb['3']  ,'47758.PNG'),
                    "sheet4": (wb['4']  ,'48076.PNG'),
                    "sheet5": (wb['5']  ,'48178.PNG'),
                    "sheet6": (wb['6']  ,'48307.PNG'),
                    "sheet7": (wb['7']  ,'48478.PNG'),
                    "sheet8": (wb['8']  ,'48538.PNG'),
                    "sheet9": (wb['9']  ,'48568.PNG'),
                    "sheet10": (wb['10'] ,'48790.PNG'),
                    "sheet11": (wb['11'] ,'48823.PNG'),
                    "sheet12": (wb['12'] ,'48937.PNG'),
                    "sheet13": (wb['13'] ,'49024.PNG'),
                    "sheet14": (wb['14'] ,'49039.PNG'),
                    "sheet15": (wb['15'] ,'49036.PNG'),
                    "sheet16": (wb['16'] ,'49069.PNG'),
                    "sheet17": (wb['17'] ,'49279.PNG'),
                    "sheet18": (wb['18'] ,'68995.PNG'),
                    "sheet19": (wb['19'] ,'69178.PNG'),
                    "sheet20": (wb['20'] ,'69418.PNG')
                }

#  メイン処理
for value in dic_work_sheet.values():

    #  Excelシートオブジェクトを取得
    ws = value[0]
    #  print(value[1])

    #  評価環境の画像エビデンスを貼り付ける
    img_full_path_qa = os.path.join(FILE_ROOTPATH_QA,value[1])
    image_qa  = openpyxl.drawing.image.Image(img_full_path_qa)
    ws.add_image( image_qa, 'A2' )

    #  本番環境の画像エビデンスを貼り付ける
    img_full_path_hon = os.path.join(FILE_ROOTPATH_HON,value[1])
    image_hon  = openpyxl.drawing.image.Image(img_full_path_hon)
    ws.add_image( image_hon, 'A48' )


wb.save(r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\20200205_強制地図位置解除対象リスト_61-80.xlsx')
print('処理が終了しました。')
#  wb.save(r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\20200205_強制地図位置解除対象リスト_81-100.xlsx')
#  wb.save(r'C:\Users\setupuser\Documents\00_Ri\00_作業\70_定例作業\02_解除用\20200205_強制地図位置解除対象リスト_100-108.xlsx')
