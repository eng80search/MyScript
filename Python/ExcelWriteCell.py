import openpyxl
import os
import re
import json
from transitions import Machine


class StateMachine(object):

    """状態の定義

    要点：
        ①状態遷移による処理の割当
        ②openpyxl使用によるexcel読み書き
        ③json形式設定ファイル読み込み
        ④正規表現を使用

    """
    states = ["start", "index", "step", "data", "result", "finish"]

    def __init__(self, name):
        #  プロパティ変数定義
        self.name = name
        self.no = 0
        self.var_step = ""
        self.var_data = ""
        self.var_result = ""

        #  状態設定
        self.machine = Machine(model=self, states=StateMachine.states, initial="start", send_event=True, auto_transitions=False)
        self.machine.add_transition(trigger="id", source="start", dest="index", before="set_id")
        self.machine.add_transition(trigger="step", source="index", dest="step")
        self.machine.add_transition(trigger="data", source="step", dest="data")
        self.machine.add_transition(trigger="result", source="data", dest="result")
        self.machine.add_transition(trigger="empty", source="result", dest="finish")
        
    #  idをセット 他の項目はリセット
    def set_id(self, event):
        self.no = event.kwargs.get("no",0)

    def add_data(self, row_data):
        """
        処理の流れ：
            一段落のデータの構成要素：step,data,result
            一段落の区切り：空欄

            step,data,resultは複数の行から成り立つ
            状態が遷移しない場合は、現在の構成要素にデータを追記する
            状態が遷移した場合は、新しい構成要素にデータを追記する
            段落の区切りが来たら、構成要素が保持したデータをクリアする
        """

        #  stepもしくはdataもしくはresultを追加する
        if self.state == "start":
            self.no = 0
            pass
        elif self.state == "index":
            self.var_step = ""
            self.var_data = ""
            self.var_result = ""
        elif self.state == "step" and not row_data.startswith("[step]:"):
            self.var_step += row_data
        elif self.state == "data" and not row_data.startswith("[data]:"):
            self.var_data += row_data
        elif self.state == "result" and not row_data.startswith("[result]:"):
            self.var_result += row_data
        elif self.state == "finish":
            #  状態を初期値に戻す
            self.state = "start"
        else:
            pass


#  jsonファイルに日本語がある時encodingを指定する
with open("settings.json", "r", encoding="utf-8") as json_file:
    json_data = json.loads(json_file.read())
    #  JsonファイルDebug用
    #  print(json_data["outputExcelrootPath"])
    #  print(json_data["outputExcelFileName"])

    excel_root_path = json_data["outputExcelrootPath"]
    file_name = json_data["outputExcelFileName"]
    output_full_name = excel_root_path + file_name + ".xlsx"
    input_full_name = excel_root_path + file_name + ".txt"
    print(output_full_name)

#  wb = openpyxl.load_workbook(r"E:\00_OurFamily\_work\100_MyAcvueテスト支援\SIT_Banner.xlsx")
wb = openpyxl.load_workbook(output_full_name)

#  状態遷移用クラスを定義
lump = StateMachine('lump')
#  print(lump.state)

# Debug用
print("処理を開始します")

#  変数定義

#  ヘッダ定義
sheet = wb["Sheet1"]
sheet["A1"] = "no"
sheet["B1"] = "step"
sheet["C1"] = "data"
sheet["D1"] = "expected result"

#  メイン処理
#  既存の内容をクリア
rows = sheet["A2":"D999"]
for row in rows:
    for cell in row:
        cell.value = ""

#  テキストファイルを読み込む
#  path = r"E:\00_OurFamily\_work\100_MyAcvueテスト支援\SIT_GrantAutoPointForEcSite.txt"
with open(input_full_name) as f:
    cnt = 0
    for s_line in f:

        #  No.にマッチするかチェック
        matched = re.match(r"(No.)(\d+)", s_line)
        if matched:
            #  print(s_line)
            #  行番号を取得
            cnt += 1
            id = matched.group(2)
            #  id番号を保存
            lump.id(no=cnt)

            #  print(lump.no)

        #  stepにマッチするかチェック
        matched = re.match(r"\[step\]:", s_line)
        if matched:
            lump.step()
            #  print(matched.group())

        #  dataにマッチするかチェック
        matched = re.match(r"\[data\]:", s_line)
        if matched:
            lump.data()
            #  print(matched.group())

        #  resultにマッチするかチェック
        matched = re.match(r"\[result\]:", s_line)
        if matched:
            lump.result()
            #  print(matched.group())

        #  空欄にマッチしたら、一段落の読み込みが完了と認識し、
        #  lumpクラス内部に保持している各値をExcelに書き出す
        matched = re.match(r"^\s+$", s_line)
        if matched:
            cell_no_value = int(lump.no) + 1
            cell_step_value = lump.var_step
            cell_data_value = lump.var_data
            cell_result_value = lump.var_result

            cell_no_address = "A" + str(cell_no_value)
            cell_step_address = "B" + str(cell_no_value)
            cell_data_address = "C" + str(cell_no_value)
            cell_result_address = "D" + str(cell_no_value)

            #  Excelに書き込む
            sheet[cell_no_address] = cell_no_value - 1
            sheet[cell_step_address] = cell_step_value
            sheet[cell_data_address] = cell_data_value
            sheet[cell_result_address] = cell_result_value

            #  状態を遷移する
            lump.empty()
            #  print(matched.group())
            #  print(cell_no_value)

        #  状態遷移がない場合はデータを前回のデータに追記する
        lump.add_data(s_line)

#  wb.save(r"E:\00_OurFamily\_work\100_MyAcvueテスト支援\SIT_GrantAutoPointForEcSite.xlsx")
wb.save(output_full_name)
print("処理が終了しました。")
