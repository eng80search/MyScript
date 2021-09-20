import sys
import os
import shutil
import pathlib


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

    def make_dirs(self, dir_path):
        """深い階層のディレクトリまで再帰的にフォルダを作成する
           注：すでに存在する際には作成しない
        例：C:\\00_dir\\01_sub_dir\\を一気に作成

        :dir_path: TODO
        :returns: TODO

        """
        #  ディレクトリが存在しない場合のみ、作成する
        if not os.path.isdir(dir_path):
            os.makedirs(dir_path)

    def delete_dirs(self, dir_path):
        """深い改装のディレクトリまで一気に削除する

        :dir_path: TODO
        :returns: TODO

        """
        #  ディレクトリが存在する場合のみ、削除する
        if os.path.isdir(dir_path):
            shutil.rmtree(dir_path)

    def get_directory_name_from_file(self, file_name_with_path):
        """フォルダパス付きファイル名からフォルダ名を取得する

        :file_name_with_path: C:\\dir1\\dir2\\test.txt
        :returns: C:\\dir1\\dir2

        """
        p_file = pathlib.Path(file_name_with_path)
        #  ファイルが所在しているディレクトリ名を取得
        current_dir = p_file.parent

        return current_dir

    def get_filename_without_extention(self, file_name):
        """拡張子のないファイル名返す（a.txt -> a）

        :file_name: ファイル名のみもしくはフォルダパス付き
        :returns: TODO

        """
        file_name = os.path.basename(file_name)
        file_name_without_extention = os.path.splitext(file_name)[0]
        return file_name_without_extention

    def get_file_extention(self, file_name):
        """ファイルの拡張子を返す（a.txt -> .txt）

        :file_name: ファイル名のみもしくはフォルダパス付き
        :returns: 拡張子

        """
        file_name = os.path.basename(file_name)
        file_name_without_extention = os.path.splitext(file_name)[1]
        return file_name_without_extention

    def copy_file(self, source_file, dest_file):
        """ファイルをコピーする。既にファイルが存在する場合は上書きされる
           コピー先のディレクトリがなければエラーになる

        :source_file: C:\\dir1\\dir2\\source.txt
        :dest_file: D:\\dir1\\dest.txt
        :returns: TODO

        """

        #  ファイルをコピー
        shutil.copy2(source_file, dest_file)

    def copy_file_with_check_path(self, source_file, dest_file):
        """ファイルをコピーする。
           コピー先のディレクトリをチェックし、なければ作成する

        :source_file: C:\\dir1\\dir2\\source.txt
        :dest_file: D:\\dir1\\dest.txt
        :returns: TODO

        """
        dest_dir = self.get_directory_name_from_file(dest_file)
        #  コピー先のフォルダがなければ、先に作成する
        self.make_dirs(dest_dir)

        #  ファイルをコピー
        shutil.copy2(source_file, dest_file)
