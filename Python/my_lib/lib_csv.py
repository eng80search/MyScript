import csv
import pandas as pd


class CsvOperation:
    """CSVファイルを操作するクラス"""

    def __init__(self):
        """TODO: to be defined. """

    def get_insert_sql(self, csv_file, db_table_name, encoding):
        """CSVファイルからInsert用SQL文を作成する
            ヘッダーがあるCSVを使用するのが前提

        :returns: TODO
        """
        sql_list = []

        #  CSVファイルをdataframeに格納 第一行をヘッダーに設定
        df = pd.read_csv(csv_file, header=0, encoding=encoding, dtype=str)
        #  dataframeにあるnull値を空白に書き換える
        #  注意：NULLとnullはOK Nullは文字列として認識される
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

    def get_update_sql(self, csv_file, db_table_name, key_infos, encoding):
        """CSVファイルからUpdate用SQL文を作成する
            ヘッダーがあるCSVを使用するのが前提

        :key_infos: Update文のプライマリーキー
        :returns: TODO
        : 構文：UPDATE TABLE_NAME SET COL1 = VALUE1, COL2 = VALUE2 WHERE 1=1
        """
        sql_list = []

        #  CSVファイルをdataframeに格納 第一行をヘッダーに設定
        #  注意：01を勝手に1として取り込むことを防ぐため、dtype=strを指定
        df = pd.read_csv(csv_file, header=0, encoding=encoding, dtype=str)

        #  dataframeにあるnull値を空白に書き換える
        #  注意：NULLとnullはOK Nullは文字列として認識される
        df = df.fillna("")

        #  例：update table_name set col1 = value1, col2 = value2 where 1=1
        update_template = "UPDATE " + db_table_name + " SET "
        update_template_where = " WHERE "

        #  #  リスト内包表記でキー列でない列名リストを作成
        #  columns_update_list = [col_name for col_name in list(df.columns)
        #                         if col_name not in key_infos.keys()]

        #  listのfor文 まずはUpdate文の雛形を作成 enumerateはcol_indexを取得するために必要
        for col_index, col_name in enumerate(list(df.columns)):
            col_index_str = str(col_index)
            if col_name not in key_infos.keys():
                update_template += col_name + " = $" + col_index_str + ", "
            else:
                update_template_where += col_name + " = $" + col_index_str + " AND "

        #  SET文の最後のカンマとWHERE文の最後のANDは不要
        update_template = update_template.rstrip(", ")
        update_template_where = update_template_where.rstrip(" AND ")
        update_template += update_template_where

        #  iterrows()メソッドを使うと、1行ずつ、インデックス名（行名）と
        #  その行のデータ（pandas.Series型）のタプル(index, Series)を取得できる。
        #  注意!：iterrows()で行を取得するためには、for文で必ずindex, rowの形で指定する
        #  df.iterrowsでループする際はヘッダは含まれていない
        for index, row in df.iterrows():
            update_one_row = update_template

            #  series型をlist型に変更してからループ処理
            for col_index, update_value in enumerate(list(row)):
                replace_index = "$" + str(col_index)
                update_value_single_qutote = "'" + str(update_value) + "'"
                update_one_row = update_one_row.replace(
                    replace_index, update_value_single_qutote
                )

            #  一行SQL文終了
            update_one_row += ";"

            #  一行のCSVデータをInsertクエリに変換
            sql_list.append(update_one_row)

        return sql_list

    def get_delete_sql(self, csv_file, db_table_name, key_infos, encoding):
        """CSVファイルからDelete用SQL文を作成する
            ヘッダーがあるCSVを使用するのが前提

        :key_infos: Delete文のプライマリーキー
        :returns: TODO
        : 構文：DELETE FROM TABLE_NAME 
                WHERE  KEY_INFOS[0] = VALUE0 
                   AND KEY_INFOS[1] = VALUE1
        """
        sql_list = []

        #  CSVファイルをdataframeに格納 第一行をヘッダーに設定
        #  注意：01を勝手に1として取り込むことを防ぐため、dtype=strを指定
        df = pd.read_csv(csv_file, header=0, encoding=encoding, dtype=str)

        #  dataframeにあるnull値を空白に書き換える
        #  注意：NULLとnullはOK Nullは文字列として認識される
        df = df.fillna("")

        #  例：update table_name set col1 = value1, col2 = value2 where 1=1
        delete_template = "DELETE FROM " + db_table_name 
        delete_template_where = " WHERE "

        #  listのfor文 まずはDelete文の雛形を作成 enumerateはcol_indexを取得するために必要
        for col_index, col_name in enumerate(list(df.columns)):
            col_index_str = str(col_index)
            if col_name in key_infos.keys():
                #  注意：$とANDの前は2つの空欄が必要
                delete_template_where += col_name + " =  $" + col_index_str + "  AND  "

        # WHERE文の最後のANDは不要
        delete_template_where = delete_template_where.rstrip("  AND  ") + "  "
        delete_template += delete_template_where

        #  iterrows()メソッドを使うと、1行ずつ、インデックス名（行名）と
        #  その行のデータ（pandas.Series型）のタプル(index, Series)を取得できる。
        #  注意!：iterrows()で行を取得するためには、for文で必ずindex, rowの形で指定する
        #  df.iterrowsでループする際はヘッダは含まれていない
        for index, row in df.iterrows():
            delete_one_row = delete_template

            #  series型をlist型に変更してからループ処理
            for col_index, delete_value in enumerate(list(row)):
                #  苦肉の策 $2の前後に空白を入れることで $2と$25を区別させる
                replace_index = " $" + str(col_index) + " "

                if replace_index in delete_template_where:
                    #  キー項目の場合、CSVファイルから値を取得する
                    delete_value_single_qutote = "'" + str(delete_value) + "'"
                    delete_one_row = delete_one_row.replace(
                        replace_index, delete_value_single_qutote
                    )

            #  一行SQL文終了
            delete_one_row += ";"

            #  一行のCSVデータをInsertクエリに変換
            sql_list.append(delete_one_row)

        return sql_list
