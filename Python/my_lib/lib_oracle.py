import cx_Oracle
import pandas as pd
import csv
import json

 
'''
Oracle データベース操作クラス
'''

class OracleOperation():

    """Docstring for OracleOperation. """

    def __init__(self, HOST, PORT, SVS, ID, PASSWORD):
        """TODO: to be defined. """
        self._tns = cx_Oracle.makedsn(HOST, PORT, service_name=SVS)
        self._conn = cx_Oracle.connect(ID, PASSWORD, self._tns)
        self.database_datas = {}

    def _clear_tables(self):
        try:

            """既存のデータを削除 """
            cur = self._conn.cursor()
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

            self._conn.commit()
            print("MNT_STOREINFO, MNT_STORE_MCHLV_ADD, MNT_STORE_INSTITUTIONテーブルを削除しました。")

        except Exception as e:
            print(e)

    def insert_to_tables(self, csv_file_full_path):
        '''CSVファイルデータをDBへ登録する '''

        try:
    
            # まずは既存のテーブルをクリアする
            self._clear_tables()

            cur = self._conn.cursor()
            # Predefine the memory areas to match the table definition
            # 入力項目中、最大入力可能な文字数を設定すればよい
            cur.setinputsizes(None, 150)

            # Adjust the batch size to meet your memory and performance requirements
            batch_size = 10000
            rowCounts = 0

            #  MNT_STOREINFO csvファイルのをDBへ登録する
            with open(csv_file_full_path, 'r') as csv_file:
                csv_reader = csv.reader(csv_file, delimiter=',')
                #  ラベルヘッダをスキップする
                header = next(csv_reader)

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

                    self._conn.rollback()
                    print("エラーがあるため、ロールバックしました。")

                #  挿入成功の場合
                else:

                    rowCounts = len(cur.getarraydmlrowcounts())
                    print("テーブル[{0}]に{1}行が挿入されました。".format("MNT_STOREINFO", rowCounts))
                    self._conn.commit()
                    print("コミット完了")

                return rowCounts 
    #

        except Exception as e:
            print(e)

    def get_tables_to_dataframe(self):
        """MNT_STOREINFO, MNT_STORE_MCHLV_ADD, MNT_STORE_INSTITUTIONを取得
        """

        data_dic = {}

        df1 = pd.read_sql_query("""
                SELECT * FROM MNT_STORE_INSTITUTION ORDER BY CLINICID ASC
        """, self._conn)

        df2 = pd.read_sql_query("""
                SELECT CLINICID,
                 CASE MATCHINGLEVEL 
                    WHEN 'KEN' THEN 1 
                    WHEN 'TOD' THEN 1 
                    WHEN 'SHK' THEN 2 
                    WHEN 'OAZ' THEN 3 
                    WHEN 'AZC' THEN 4 
                    WHEN 'GIK' THEN 5 
                    WHEN 'TBN' THEN 6 
                    WHEN 'EBN' THEN 7 
                    ELSE -1
                 END MATCHINGLEVEL_NUM ,
                 MATCHINGLEVEL,
                 MATCHFLAG,
                 ADDRESSFLAG,
                 ADDRESSCODE,
                 ADDRESS
                 FROM MNT_STORE_MCHLV_ADD
                 ORDER BY CLINICID ASC
        """, self._conn)

        data_dic["MNT_STORE_INSTITUTION"] = df1
        data_dic["MNT_STORE_MCHLV_ADD"] = df2

        return data_dic

    def close_connect(self):
        """接続を閉じる
        """
        try:
            self._conn.close()
        except Exception as e:
            print(e)
