import os
import sys
from PIL import Image
import glob
import re
import pathlib
import logging
import json

#  一定の規則があるフォルダを探す
#  内部の画像ファイルを探す
#  画像ファイルをリサイズ
#  商品番号-連番の命名ルールで名前をつけて保存
#  新しいフォルダへ移動する

#  他に考慮すべき点
#  1. エラーはログに吐く

try:
    #  jsonファイルから設定値を読み込む
    with open("settings_imageResizing.json", "r", encoding="utf-8") as json_file:
        json_data = json.loads(json_file.read())

        resize_folder = json_data["resize_folder"]
        log_file_path = json_data["log_file_path"]
        log_file_name = json_data["log_file_name"]

    log_file_full_path = os.path.join(log_file_path, log_file_name)


    #  ログ設定
    formatter = "%(levelname)s : %(asctime)s : %(message)s"
    logging.basicConfig(
        filename=log_file_full_path, level=logging.INFO, format=formatter
    )
    logging.info(log_file_full_path)

    #  カレントディレクトリを変更
    PATH = resize_folder
    os.chdir(PATH)

except Exception as e:
    print(e)
    logging.error(e)
    #  プログラムはここで終了する
    sys.exit(1)

#  内包表記でパターンにマッチングするフォルダだけ処理(サブフォルダは対象外)
dir_list = [p for p in glob.iglob("**") if re.search("(\w+)-(\d{4}$)", p)]
#  print(type(dir_list))
print(dir_list)

#  マッチングされたフォルダに対して処理を行う
for image_dir in dir_list:
    #  ディレクトリ内でJPGファイルのみ取得
    #  windowsでありがちな*.jpgファイルを抽出の場合はPythonでは\.jpg$と書く
    image_files = [
        p for p in glob.iglob(image_dir + "/*") if re.search("\.jpg$", p)
    ]
    #  image_files = [p for p in pathlib.Path(image_dir).iterdir() if re.search("\.jpg$", str(p))]

    #  print(image_files)
    #  logging.info(image_files)

    #  フォルダにあるファイルに対して処理
    for i, image_file in enumerate(image_files):
        #  for i, image_file in enumerate(pathlib.Path(image_dir).iterdir()):

        #  dir_name, file_name = os.path.split(image_dir)
        new_name = "{}-{}".format(image_dir, i + 1)
        print(new_name)
        print(image_file)
        logging.info(new_name)
