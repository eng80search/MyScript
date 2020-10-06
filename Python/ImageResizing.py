import os
import sys
import shutil
from PIL import Image
import glob
import re
import pathlib
import logging
import json
import pandas as pd

#  一定の規則があるフォルダを探す
#  内部の画像ファイルを探す
#  画像ファイルをリサイズ
#  商品番号-連番の命名ルールで名前をつけて保存
#  新しいフォルダへ移動する

#  他に考慮すべき点
#  1. エラーはログに吐く

URL_PREFIX = "https://www.rakuten.ne.jp/gold/newimage/2015-7/"

def resize_image(original_image_file, resized_image_file):
    """画像を読み込んだ後、リサイズする

    :original_image_file: TODO
    :resized_image_file: TODO
    :returns: TODO

    """

    #  画像ファイルをリサイズして保存
    img = Image.open(original_image_file)
    if i == 0:
        img_resize = img.resize((900, 900))
    else:
        img_resize = img.resize((700, 700))
    img_resize.save(resized_image_file)

    return True

def read_file(file_path):
    """ファイルの内容を文字列として読み込む

    :file_path: TODO
    :returns: TODO

    """

    with open(file_path) as f:
        file_content = f.read()
    return file_content

def write_file(file_path, pc_content):
    """生成されたPC販売説明文をファイルに書き出す

    :file_path: TODO
    :returns: TODO

    """

    with open(file_path) as f:
        file_content = f.read()
    return file_content

def read_template_list(pc_descript_1,pc_descript_2):
    """PC販売説明文をテンプレートファイルからテンプレートリストを作成

    :pc_descript_1: PC用販売説明文１
    :pc_descript_2: PC用販売説明文２
    :returns: 説明文リスト

    """
    pc_template_list = []

    with open(pc_descript_1) as f1:
        pc_template_list.append(f1.read())

    with open(pc_descript_2) as f2:
        pc_template_list.append(f2.read())

    return pc_template_list

def make_pc_descript(json_data, image_list):
    """PC用販売説明文を作成する

    :json_data: Json設定値
    :image_list: 画像ファイル名リスト
    """
    pc_descript_1 = json_data["pc_descript_1"]
    pc_descript_2 = json_data["pc_descript_2"]
    pc_descript_out = json_data["pc_descript_out"]

    pc_template_list = read_template_list(pc_descript_1, pc_descript_2)
    pc_descript_str = ""

    for i, image_name in enumerate(image_list):
        print(image_name)
        #  第一枚画像用
        if i == 0:
            pc_descript_str = "--------------第一枚画像説明文-----------------\r\n"
            pc_descript_str += pc_template_list[0]
            pc_descript_str = pc_descript_str.replace('$1', image_name)
        #  第二枚画像以降用
        else:
            if i == 1:
                pc_descript_str += "--------------第二枚以降画像説明文----------------\r\n"
            pc_descript_str += pc_template_list[1]
            pc_descript_str = pc_descript_str.replace('$1', image_name)

    print(pc_descript_str)

    return True

def output_data(file_list):
    """TODO: item.csvファイルに必要なデータを作成

    :file_list: ファイル名リスト
    :returns: 

    """

    image_url = ""

    for image_file_name in file_list:
        image_url += URL_PREFIX + image_file_name + " "

    #  image_url = image_url.rstrip() + ","

    return image_url


try:
    #  jsonファイルから設定値を読み込む
    with open("settings_imageResizing.json", "r", encoding="utf-8") as json_file:
        json_data = json.loads(json_file.read())

        resize_folder = json_data["resize_folder"]
        item_csv_temp_path = json_data["item_csv_temp_path"]
        log_file_path = json_data["log_file_path"]
        log_file_name = json_data["log_file_name"]

    log_file_full_path = os.path.join(log_file_path, log_file_name)

    #  ログ設定
    formatter = "%(levelname)s : %(asctime)s : %(message)s"
    logging.basicConfig(
        filename=log_file_full_path, level=logging.INFO, format=formatter
    )
    logging.info("--log_file_full_path : " + log_file_full_path)

    #  カレントディレクトリを変更
    PATH = resize_folder
    os.chdir(PATH)

    print("*resize_folder:" + resize_folder)
    logging.info("*resize_folder:" + resize_folder)

except Exception as e:
    print(e)
    logging.error(e)
    #  プログラムはここで終了する
    sys.exit(1)

#  内包表記でパターンにマッチングするフォルダだけ処理(サブフォルダは対象外)
dir_list = [p for p in glob.iglob("**") if re.search("([A-Z]\d{6})-(\d{3}$)", p)]
#  print(type(dir_list))
#  print(dir_list)

try:
    #  マッチングされたフォルダに対して処理を行う
    for image_dir in dir_list:
        #  ディレクトリ内でJPGファイルのみ取得
        #  windowsでありがちな*.jpgファイルを抽出の場合はPythonでは\.jpg$と書く
        original_image_files = [
            p for p in glob.iglob(image_dir + "/*")
            if re.search("\.jpg$", p, re.IGNORECASE)
        ]
        #  image_files = [p for p in pathlib.Path(image_dir).iterdir() if re.search("\.jpg$", str(p))]

        #  print(image_files)
        #  logging.info(image_files)

        #  元画像を保存するフォルダを作成
        original_image_dir = image_dir + "\\00_original"
        #  変換後の画像を保存するフォルダを作成
        resized_image_dir = image_dir + "\\01_complete"

        os.makedirs(original_image_dir, exist_ok=True)
        os.makedirs(resized_image_dir, exist_ok=True)

        image_list = []

        #  フォルダにあるファイルに対して処理
        for i, original_image_file in enumerate(original_image_files):
            #  for i, image_file in enumerate(pathlib.Path(image_dir).iterdir()):

            #  dir_name, file_name = os.path.split(image_dir)
            #  1:02の意味はformatの第２引数の値を数字２桁にし、１桁の場合は、左０埋めにする
            resized_image_name = "{0:}-{1:02}.jpg".format(image_dir, i + 1)
            resized_image_file = os.path.join(resized_image_dir, resized_image_name)
            #  shutil.copy(original_image_file, resized_image_file)

            #  画像ファイルをリサイズして保存
            resize_image(original_image_file, resized_image_file)
            #  オリジナル画像ファイルを移動する
            shutil.move(original_image_file, original_image_dir)

            image_list.append(resized_image_name)

            log_info = "**original:{0}->resized:{1}".format(
                original_image_file, resized_image_file
            )
            print(log_info)
            logging.info(log_info)

        #  item.csvで使用されるデータを作成する
        out_image_url = output_data(image_list)
        print(out_image_url)

        #  item.csvテンプレートを読み込む
        df = pd.read_csv(item_csv_temp_path, encoding="shift_jis")
        #  商品画像URLを設定
        df.iat[0, 28] = out_image_url

        df.to_csv(
            os.path.join(image_dir, "item.csv"), index=False, encoding="shift_jis"
        )
        #  コピペー用のPC用販売説明文を生成する
        make_pc_descript(json_data,image_list)

except Exception as e:
    print(e)
    logging.error(e)
    #  プログラムはここで終了する
    sys.exit(1)
