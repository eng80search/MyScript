import sys
import os


class FileIo:
    """ファイル入出力を行うクラス"""

    def __init__(self):
        """TODO: to be defined. """

    def write_list_tofile(self, data_list, export_file):
        """リストデータをファイルを出力する
        :data_list: 書き込むべきデータ（リスト）
        :export_file: 書き込む先のファイル
        :returns: True 成功 False 失敗
        """
        try:

            #  mode='w'ファイルが存在しなければ新規作成、
            #  存在していれば上書き（既存の内容は削除）で保存される。
            with open(export_file, mode="w") as f:
                #  注：リストの要素ごとに改行したい場合はwriteメソッドを使い
                #      且つ'\n'を追加
                f.write("\n".join(data_list))

            return True

        except Exception as e:
            print(e)
            return False

    def combine_file_path(self, directory, file_name):
        """ファイルのディレクトリとファイルを結合するtest

        :directory: ディレクトリ
        :file_name: ファイル名
        :returns: TODO

        """
        path = os.path.join(directory, file_name)

        return path
