"""Excel 操作クラス """
import openpyxl
import pandas as pd
import csv


class ExcelOperation():
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

    def excel_to_csv(self,
                     file_name,
                     sheet_name,
                     user_cols_list,
                     export_csv_name,
                     skip_rows_list=None,
                     skipfooter_num=0):
        """Excelの特定のシートの指定部分をCSVファイルへ出力する
           (読込範囲はpandasが自動的に決めてくれるので、
           空白でないセルが読込対象になる)

        :file_name: 読込元のExcelファイル
        :sheet_name: Excelシート名
        :user_cols: CSVデータにしたい列を指定する(例：[0,1,3])
        :skip_rows: 読込スキップ行を指定する(例：[0,1])
        :skipfooter: 読込対象の列の中、下から数えて何行をスキップするのかを指定する(例：1)
        :export_csv_name: 出力されるCSVファイル
        :returns: TODO

        """

        try:

            #  Excelから指定範囲のセルをDataframeへ読み込み
            df = pd.read_excel(file_name,
                               usecols=user_cols_list,
                               skiprows=skip_rows_list,
                               skipfooter=skipfooter_num,
                               sheet_name=sheet_name)

            #  DataframeをCSVへ出力 index=FalseはDataframeのindexを出力しない
            #  QUOTE_NONNUMERIC: 数値以外はダブルコーテーションをつける
            df.to_csv(export_csv_name,
                      index=False,
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
        rows = sheet["A1":"ZZ9999"]
        for row in rows:
            for cell in row:
                cell.value = ""

    def write_excel_sheet(self, book_name, sheet_name, data_frame):
        """ Write excel data using DataFrame 
        """

        #  まずは既存のデータをクリアする
        self.clear_excel_sheet(book_name, sheet_name)
        with pd.ExcelWriter(book_name, mode='a', engine="openpyxl") as writer:
            data_frame.to_excel(writer,
                                sheet_name=sheet_name,
                                index=False,
                                header=True)
