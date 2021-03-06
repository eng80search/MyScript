import sys
import os
import json

#  自分より上のフォルダにあるモジュールを参照するために必要な設定
sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
import my_lib

"""
excelファイルから特定範囲のデータをOracleのdelete Sql文として出力する
手順：
    ・ExcelファイルからCSVファイルを作成
    ・CSVファイルからDelete用SQL文を生成し、ファイルに保存
"""

if __name__ == "__main__":
    try:

        #  json設定ファイルから必要情報を取得
        with open("settings_delete.json", "r", encoding="utf-8") as json_file:
            json_data = json.loads(json_file.read())

            #  import用Excelの情報を読み取り
            json_data_import = json_data["import_excel_info"]
            import_dir = json_data_import["DIRECTORY"]
            import_file = json_data_import["FILE_NAME"]
            import_selections = json_data_import["selection"]
            encoding = json_data_import["encoding"]

        #  フォルダとファイル名を結合して、フルパスを取得する
        _fileio = my_lib.FileIo()
        import_excel_file = _fileio.combine_file_path(import_dir, import_file)
        delete_sql_list = []

        #  必要なクラスの初期化
        #  _oracle = my_lib.OracleOperation(HOST, PORT, SVS, ID, PASSWORD)
        _csv = my_lib.CsvOperation()
        _excel = my_lib.ExcelOperation(import_excel_file)

        for item in import_selections:

            export_csv_file = _fileio.combine_file_path(
                import_dir, item["export_file"] + ".csv"
            )
            #  ExcelファイルからCSVファイルを作成する
            result = _excel.excel_to_csv(
                import_excel_file,
                item["SHEET_NAME"],
                item["selection_infos"],
                item["duplicate_infos"],
                export_csv_file,
                encoding,
                [0],
            )

            if not result:
                raise Exception(
                    "Error: Excelから" + item["export_file"] 
                    + ".csvファイル作成が失敗しました"
                )
            else:
                print("Success: Excelから" + item["export_file"] 
                      + ".csvファイル作成が完了しました。")

            #  CSVファイルからDelete用SQLを作成する
            delete_sql_list = _csv.get_delete_sql(export_csv_file,
                                                  item["db_table"],
                                                  item["key_infos"],
                                                  encoding)

            if len(delete_sql_list) < 1:
                raise Exception(
                    "Error: CSVから" + item["db_table"] + "のDelete用Sql文作成が失敗しました"
                )
            else:
                print("Success: CSVから" + item["db_table"] 
                      + "のDelete用Sql文作成が完了しました")

            #  Sql文の結果を出力
            export_sql_file = _fileio.combine_file_path(
                import_dir, item["export_file"] + ".sql"
            )
            #  Delete用SQLをファイルに出力する
            result = _fileio.write_list_tofile(delete_sql_list, export_sql_file)

            if not result:
                raise Exception(
                    "Error: Delete用" + item["export_file"] 
                    + ".sql文のファイル出力が失敗しました"
                )
            else:
                print("Success: Delete用" 
                      + item["export_file"] + ".sql文のファイル出力が完了しました")

    except Exception:
        print("Unexpected error:", sys.exc_info())
