import os
import sys
import shutil
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
    logging.info("log_file_full_path : " + log_file_full_path)

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

try:
    #  マッチングされたフォルダに対して処理を行う
    for image_dir in dir_list:
        #  ディレクトリ内でJPGファイルのみ取得
        #  windowsでありがちな*.jpgファイルを抽出の場合はPythonでは\.jpg$と書く
        original_image_files = [
            p
            for p in glob.iglob(image_dir + "/*")
            if re.search("\.jpg$", p, re.IGNORECASE)
        ]
        #  image_files = [p for p in pathlib.Path(image_dir).iterdir() if re.search("\.jpg$", str(p))]

        #  print(image_files)
        #  logging.info(image_files)

        #  元画像を保存するフォルダを作成
        original_image_dir = image_dir + "\\00_original"
        #  変換後の画像を保存するフォルダを作成
        complete_image_dir = image_dir + "\\01_complete"

        os.makedirs(original_image_dir, exist_ok=True)
        os.makedirs(complete_image_dir, exist_ok=True)

        #  フォルダにあるファイルに対して処理
        for i, original_image_file in enumerate(original_image_files):
            #  for i, image_file in enumerate(pathlib.Path(image_dir).iterdir()):

            #  dir_name, file_name = os.path.split(image_dir)
            new_image_file = "{}-{}.jpg".format(image_dir, i + 1)
            new_image_file = os.path.join(complete_image_dir, new_image_file)
            #  shutil.copy(original_image_file, new_image_file)

            img = Image.open(original_image_file)
            if i == 0:
                img_resize = img.resize((900, 900))
            else:
                img_resize = img.resize((700, 700))
            img_resize.save(new_image_file)

            shutil.move(original_image_file, original_image_dir)

            print(new_image_file)
            print(original_image_file)
            logging.info(new_image_file)

except Exception as e:
    print(e)
    logging.error(e)
    #  プログラムはここで終了する
    sys.exit(1)
