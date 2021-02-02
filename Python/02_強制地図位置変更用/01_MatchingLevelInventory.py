import cx_Oracle
import csv
import json
import subprocess, sys

import sys, os
#  自分より上のフォルダにあるモジュールを参照するために必要な設定
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import my_lib 
 
'''
機能：強制地図位置変更のマッチングレベルの棚卸し
CSVファイルをDBに登録した後、バッチ処理を起動して、経度緯度情報をWebAPIから取得する
モジュール：OracleDB接続用にcx_Oracle  exeバッチを起動用にsubprocess
'''
def run_batch(cmd):
    '''
    :param cmd: str 実行するコマンド
    :rtype: str
    :return: 標準出力
    '''

    #  非同期でバッチ処理を起動する
    proc = subprocess.Popen(cmd,shell=True,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
    # サブプロセスの完了を待つ
    result = proc.communicate()

    # result[0] stdout result[1] stderr
    return result[0]


def write_result_to_excel(excel_file_name):
    """TODO: DBのMNT_TOREINFO,MNT_STORE_INSTITUTION,MNT_STORE_MCHLV_ADD
    をExcelに書き込む
    :returns: 実行結果

    """
    return "正常終了"

if __name__ == '__main__':
    try:

        #  json設定ファイルから必要情報を取得
        with open("settings_DbOracle.json", "r", encoding="utf-8") as json_file:
            json_data = json.loads(json_file.read())

            csv_file_full_path = json_data["import_csv_path"]
            excel_output_path = json_data["EXCEL_PATH"]
            batch_exe = json_data["batch_run_path"]
            HOST = json_data["HOST"]
            PORT = json_data["PORT"]
            SVS = json_data["SVS"]
            ID = json_data["ID"]
            PASSWORD = json_data["PASSWORD"]

        #  必要なクラスの初期化
        _oracle = my_lib.OracleOperation(HOST, PORT, SVS, ID, PASSWORD)
        _excel = my_lib.ExcelOperation()

        # MNT_STOREINFO.csvファイルをDBへ登録
        print("------CSVファイルをDBへ登録処理開始---------")
        insert_result = _oracle.insert_to_tables(csv_file_full_path)
        #  挿入された件数が戻り値
        print(insert_result)
        print("------CSVファイルをDBへ登録処理終了---------")

        #  バッチを実行して、経度緯度情報をDBに書き込む
        print("------経度緯度情報取得バッチ処理開始---------")
        run_result = run_batch(batch_exe)
        #  バッチから出力された内容が戻り値
        print(run_result)
        print("------経度緯度情報取得バッチ処理終了---------")

        #  バッチ取得後の、DB値をExcelに書き込む
        print("------DB取得値をExcelへ書き込み処理開始---------")
        dataframe_result = _oracle.get_tables_to_dataframe()
        _excel.write_excel_sheet(excel_output_path, "MNT_STORE_INSTITUTION", 
                                    dataframe_result["MNT_STORE_INSTITUTION"])
        _excel.write_excel_sheet(excel_output_path, "MNT_STORE_MCHLV_ADD", 
                                    dataframe_result["MNT_STORE_MCHLV_ADD"])
        print("------DB取得値をExcelへ書き込み処理終了---------")

    except Exception as e:
        print(e)
