"""Excel 操作クラス """
import openpyxl
import pandas as pd


class ExcelOperation():
    """Excel 操作クラス """
    def __init__(self):
        """TODO: 初期化クラス. """
        pass

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
            data_frame.to_excel(writer, sheet_name=sheet_name, index=False, header=True)
