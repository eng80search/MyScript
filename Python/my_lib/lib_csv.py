import csv
import pandas as pd


class CsvOperation():

    """CSVファイルを操作するクラス"""

    def __init__(self):
        """TODO: to be defined. """

    def get_insert_sql(self, csv_file, db_table_name):
        """CSVファイルからInsert用SQL文を作成する
            ヘッダーがあるCSVを使用するのが前提

        :returns: TODO
        """
        sql_list = []

        #  CSVファイルをdataframeに格納 第一行をヘッダーに設定
        df = pd.read_csv(csv_file, header=0)
        #  dataframeにあるnull値を空白に書き換える
        df = df.fillna("")

        #  例：insert into table_name (col1, col2)
        insert_header = "INSERT INTO " + db_table_name + " ("

        #  listのfor文
        for item in list(df.columns):
            insert_header += item + ","
        insert_header = insert_header.rstrip(",") + ") "

        #  iterrows()メソッドを使うと、1行ずつ、インデックス名（行名）と
        #  その行のデータ（pandas.Series型）のタプル(index, Series)を取得できる。
        #  df.iterrowsでループする際はヘッダは含まれていない
        for index, row in df.iterrows():
            row_data = " VALUES("

            #  series型をlist型に変更してからループ処理
            for cell in list(row):
                row_data += "'" + str(cell) + "',"

            #  最後のカンマは削除
            row_data = row_data.rstrip(",") + ");"

            #  一行のCSVデータをInsertクエリに変換
            sql_list.append(insert_header + row_data)

        return sql_list
