import openpyxl
import os
import re
from transitions import Machine


class StateMachine(object):

    """状態の定義"""
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



wb = openpyxl.load_workbook(r"E:\00_OurFamily\_work\100_MyAcvueテスト支援\SIT_GrantAutoPointForEcSite.xlsx")

#  状態遷移用クラスを定義
lump = StateMachine('lump')
#  print(lump.state)

# Debug用
print("処理を開始します")

#  変数定義

#  ヘッダ定義
sheet = wb["Sheet1"]
sheet["A1"] = "step"
sheet["B1"] = "data"
sheet["C1"] = "expected result"

#  メイン処理
#  既存の内容をクリア
#  sheet.Range("A2:D999").Clear

#  テキストファイルを読み込む
path = r"E:\00_OurFamily\_work\11_myScript\Python\SIT_GrantAutoPointForEcSite.txt"
with open(path) as f:
    for s_line in f:

        #  No.にマッチするかチェック
        matched = re.match(r"(No.)(\d+)", s_line)
        if matched:
            #  print(s_line)
            #  行番号を取得
            id = matched.group(2)
            #  id番号を保存
            lump.id(no=id)
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

        #  resultにマッチするかチェック
        matched = re.match(r"^\s+", s_line)
        if matched:
            cell_no = int(lump.no) + 1
            cell_step_address = "A" + str(cell_no)
            cell_data_address = "B" + str(cell_no)
            cell_result_address = "C" + str(cell_no)
            cell_step_value = lump.var_step
            cell_data_value = lump.var_data
            cell_result_value = lump.var_result

            sheet[cell_step_address] = cell_step_value
            sheet[cell_data_address] = cell_data_value
            sheet[cell_result_address] = cell_result_value
            #  print(cell_no)
            #  print(cell_step)
            #  print(cell_data)
            #  print(cell_result)
            lump.empty()
            #  print(matched.group())

        #  データを追加する
        lump.add_data(s_line)

wb.save(r"E:\00_OurFamily\_work\100_MyAcvueテスト支援\SIT_GrantAutoPointForEcSite.xlsx")
print("処理が終了しました。")
