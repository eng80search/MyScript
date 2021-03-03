"""Excel 操作クラス """
import openpyxl
import pandas as pd
import csv
import re


class ExcelOperation:
    """Excel 操作クラス """

    def __init__(self):
        """TODO: 初期化クラス. """
        pass

    def __init__(self, excel_file):
        """Excel 操作クラス　コンストラクタ

        :excel_file: Excelファイル
        :returns: TODO

        """
        self.wb = openpyxl.load_workbook(excel_file)

    def excel_to_csv(
        self,
        file_name,
        sheet_name,
        user_cols_list,
        duplicate_cols_list,
        export_csv_name,
        encoding,
        column_name_infos=None,
        skip_rows_list=None,
        skipfooter_num=0,
    ):
        """Excelの特定のシートの指定部分をCSVファイルへ出力する
           (読込範囲はpandasが自動的に決めてくれるので、
           空白でないセルが読込対象になる)

        :file_name: 読込元のExcelファイル
        :sheet_name: Excelシート名
        :user_cols: CSVデータにしたい列を指定する(例：[0,1,3])
        :duplicate_cols_list: 重複する列名(例：３行が他の列名と同じの場合: [3])
        :export_csv_name: 出力されるCSVファイル
        :encoding: 文字化け対策のためcp932など指定
        :column_name_infos: Excelファイルにある列名と別の列名を使用する際に指定
        :skip_rows: 読込スキップ行を指定する(例：[0,1])
        :skipfooter: 読込対象の列の中、下から数えて何行をスキップするのかを指定する(例：1)
        :returns: TODO

        """

        try:

            #  Excelから指定範囲のセルをDataframeへ読み込み
            df = pd.read_excel(
                file_name,
                usecols=user_cols_list,
                skiprows=skip_rows_list,
                skipfooter=skipfooter_num,
                sheet_name=sheet_name,
            )

            #  設定ファイルで列名を明示した場合は、列名を設定した値に変更
            for new_col_name,col_index in column_name_infos.items():
                original_col_name = df.columns[col_index]
                df.rename(columns={original_col_name: new_col_name}, 
                          inplace=True)

            #  Excelの一つのsheetに重複する列名が存在する場合は、列名の後ろの「.数字」を削除する
            #  注意：pandasでexcelを読み込むと、同じ列名が複数ある場合は、
            #  ２番めの 列には[columnsName.1]のように強制的なる模様。

            #  列名重複の正規表現 \.は文字列「.」\d+$は行の最後に数字が一個以上を表す
            pattern_replace = "\.\d+$"
            for duplicate_col in duplicate_cols_list:
                original_col_name = df.columns[duplicate_col]
                #  original_col_nameから重複した列名の後ろの「.数字」を削除する
                #  関数の使い方に注意、戻り値から置換した文字列が取得できる
                new_col_name = re.sub(pattern_replace, "", original_col_name)
                #  注意：列名を変更する 自分自身の列名を変更するので
                #        inplace=Trueを指定する必要あり
                df.rename(columns={original_col_name: new_col_name}, 
                          inplace=True)

            #  DataframeをCSVへ出力 index=FalseはDataframeのindexを出力しない
            #  QUOTE_NONNUMERIC: 数値以外はダブルコーテーションをつける
            df.to_csv(export_csv_name, index=False, encoding=encoding,
                      quoting=csv.QUOTE_NONNUMERIC)
            return True

        except Exception as e:
            print(e)
            return False

    def clear_excel_sheet(self, book_name, sheet_name):
        """Clear All cell contents(メソッドがないので手動で範囲を指定)
        """

        wb = openpyxl.load_workbook(book_name)
        sheet = wb[sheet_name]

        #  メイン処理
        #  既存の内容をクリア
        rows = sheet["A1":"ZZ999"]
        for row in rows:
            for cell in row:
                cell.value = ""

    def write_excel_sheet(self, book_name, sheet_name, data_frame):
        """ Write excel data using DataFrame 
        """

        #  まずは既存のデータをクリアする
        self.clear_excel_sheet(book_name, sheet_name)
        with pd.ExcelWriter(book_name, mode="a", engine="openpyxl") as writer:
            data_frame.to_excel(writer, sheet_name=sheet_name, index=False, header=True)
