import cx_Oracle
import csv
import json
import subprocess, sys
 
'''
機能：CSVファイルをDBに登録した後、バッチ処理を起動して、経度緯度情報をWebAPIから取得する
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

try:

    #  json設定ファイルから必要情報を取得
    with open("settings_DbOracle.json", "r", encoding="utf-8") as json_file:
        json_data = json.loads(json_file.read())

        csv_file_full_path = json_data["import_csv_path"]
        batch_exe = json_data["batch_run_path"]
        HOST = json_data["HOST"]
        PORT = json_data["PORT"]
        SVS = json_data["SVS"]
        ID = json_data["ID"]
        PASSWORD = json_data["PASSWORD"]

    tns = cx_Oracle.makedsn(HOST, PORT, service_name=SVS)
    conn = cx_Oracle.connect(ID,PASSWORD, tns)
     
    cur = conn.cursor()
    #  既存のデータを削除
    cur.execute("""
        DELETE FROM MNT_STOREINFO
        """)
    cur.execute("""
        DELETE FROM MNT_STORE_MCHLV_ADD
        """)
    cur.execute("""
        DELETE FROM MNT_STORE_INSTITUTION
        """)

    conn.commit()
    print("MNT_STOREINFO, MNT_STORE_MCHLV_ADD, MNT_STORE_INSTITUTIONテーブルを削除しました。")

    # Predefine the memory areas to match the table definition
    # 入力項目中、最大入力可能な文字数を設定すればよい
    cur.setinputsizes(None, 150)

    # Adjust the batch size to meet your memory and performance requirements
    batch_size = 10000

    #  MNT_STOREINFO csvファイルのをDBへ登録する
    with open(csv_file_full_path, 'r') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        sql = "insert into MNT_STOREINFO (CLINICID, ADDRESS) values (:1, :2)"
        data = []

        for line in csv_reader:
            data.append((line[0], line[1]))
            if len(data) % batch_size == 0:
                #  arraydmlrowcountsは影響された行数をカウントするために使用される
                cur.executemany(sql, data, arraydmlrowcounts=True, batcherrors=True)

                data = []
        if data:
            cur.executemany(sql, data, arraydmlrowcounts=True, batcherrors=True)

        #  エラーがあれば出力する
        if len(cur.getbatcherrors()) > 0:

            for error in cur.getbatcherrors():
                print("Error", error.message, "at row offset", error.offset)

            conn.rollback()
            print("エラーがあるため、ロールバックしました。")

        #  挿入成功の場合
        else:

            rowCounts = len(cur.getarraydmlrowcounts())
            print("テーブル[{0}]に{1}行が挿入されました。".format("MNT_STOREINFO", rowCounts))
            conn.commit()
            print("コミット完了")
#
    conn.close()

    #  バッチを実行して、経度緯度情報をDBに書き込む
    print("------経度緯度情報取得バッチ処理開始---------")
    run_result = run_batch(batch_exe)
    print(run_result)
    print("------経度緯度情報取得バッチ処理終了---------")


except Exception as e:
    print(e)
