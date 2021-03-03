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


def write_file(pc_descript_out, pc_descript_str):
    """生成されたPC販売説明文をファイルに書き出す

    :pc_descript_out: PC用説明文の出力ファイル
    :pc_descript_str: PC用説明文本体

    """

    #  mode="w" ファイルが存在しなければ新規作成、存在していれば上書き（既存の内容は削除）
    with open(pc_descript_out, mode="w", newline="\n") as f:
        f.write(pc_descript_str)

    return True


def read_template_list(pc_descript_part1, pc_descript_part2, pc_descript_all):
    """PC販売説明文をテンプレートファイルからテンプレートリストを作成

    :pc_descript_part1: PC用販売説明文第１枚画像用
    :pc_descript_part2: PC用販売説明文第２枚画像以降用
    :pc_descript_all: PC用販売説明文全文（part1とpart2合成したもの）
    :returns: 説明文リスト

    """
    pc_template_list = []

    with open(pc_descript_part1) as f1:
        pc_template_list.append(f1.read())

    with open(pc_descript_part2) as f2:
        pc_template_list.append(f2.read())

    with open(pc_descript_all) as f3:
        pc_template_list.append(f3.read())

    return pc_template_list


def make_pc_descript(json_data, image_list, image_dir):
    """PC用販売説明文を作成する

    :json_data: Json設定値
    :image_list: 画像ファイル名リスト
    """
    pc_descript_part1 = json_data["pc_descript_part1"]
    pc_descript_part2 = json_data["pc_descript_part2"]
    pc_descript_all = json_data["pc_descript_all"]
    pc_descript_out = json_data["pc_descript_out"]

    pc_template_list = read_template_list(pc_descript_part1,
                                          pc_descript_part2, pc_descript_all)
    descript_part1 = ""
    descript_part2 = ""
    descript_all = ""

    for i, image_name in enumerate(image_list):
        #  第一枚画像用
        if i == 0:
            #  descript_part1 = "<!-- ----第一枚画像説明文----- -->\n"
            descript_part1 += pc_template_list[0]
            descript_part1 = descript_part1.replace("$1", image_name)
        #  第二枚画像以降用
        else:
            #  if i == 1:
                #  descript_part2 += "<!-- ----第二枚以降画像説明文----- -->\n"
            descript_part2 += pc_template_list[1]
            descript_part2 = descript_part2.replace("$1", image_name)

    #  第一枚説明文と第二枚以降の説明文を統合して、PC説明文を仕上げる
    descript_all = pc_template_list[2]
    descript_all = descript_all.replace("$1", descript_part1)
    descript_all = descript_all.replace("$2", descript_part2)

    #  pc_descript_out = os.path.join(image_dir, pc_descript_out)
    #  print(descript_all)
    #  write_file(pc_descript_out, descript_part)

    return descript_all


def make_image_url(file_list):
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

    log_info = "*resize_root folder -> {0}".format(resize_folder) 
    print(log_info)
    logging.info(log_info)

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
            p
            for p in glob.iglob(image_dir + "/*")
            if re.search("\.jpg$", p, re.IGNORECASE)
        ]

        log_info = "--image resize_dir is {0}".format(image_dir)
        print(log_info)
        logging.info(log_info)

        #  元画像を保存するフォルダを作成
        original_image_dir = image_dir + "\\00_original"
        #  変換後の画像を保存するフォルダを作成
        resized_image_dir = image_dir + "\\01_complete"

        os.makedirs(original_image_dir, exist_ok=True)

        #  リサイズ画像ファイルがある際には01_completeフォルダを初期化
        if len(original_image_files) > 0 :
            #  01_completeファルダにある既存のすべてのファイルを削除
            if os.path.exists(resized_image_dir):
                shutil.rmtree(resized_image_dir)
            os.makedirs(resized_image_dir, exist_ok=True)


        image_list = []

        #  各商品画像フォルダにあるファイルに対してリサイズ処理
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
            #  移動先にファイルが存在するとmoveするとエラーになるので先に削除する
            dest_image_file = original_image_dir + "\\" + \
                                os.path.basename(original_image_file)
            if os.path.exists(dest_image_file):
                os.remove(dest_image_file)
            shutil.move(original_image_file, original_image_dir)

            image_list.append(resized_image_name)

            log_info = "  resized:from [{0}] -> to [{1}]".format(
                original_image_file, resized_image_file
            )
            print(log_info)
            logging.info(log_info)


        #  リサイズ処理が合った場合、item.csvファイルを作成する
        if len(original_image_files) > 0 :
            #  item.csvで使用されるデータを作成する
            out_image_url = make_image_url(image_list)
            #  print(out_image_url)

            #  コピペー用のPC用販売説明文を生成する
            pc_descript_all = make_pc_descript(json_data, image_list,
                                               resized_image_dir)

            #  item.csvテンプレートを読み込む
            df = pd.read_csv(item_csv_temp_path, encoding="shift_jis")

            pc_descript_item = df.iat[0, 27]

            #  pythonの正規表現では途中から一部の文字列を抽出する際には、その部分を括弧で囲み、
            #  group(1)でその部分を取得する。group(0)は全体を取得する
            #  複数の行を跨って検索する際には\s:空白文字 \S:空白以外の文字 *?:繰り返しが最小限マッチ
            patternReplace = r'[\s\S]*?(<table\s+width="700"\s+border="0"\s+align="center">[\s\S]*?</table>)' 
            #  正規表現確認用コード
            #  m = re.match(patternReplace, pc_descript_item)
            #  print(m.group(1))

            #  正規表現でマッチングして、その対象を置換する場合はre.sub関数を使用する
            pc_descript_item = re.sub(patternReplace, pc_descript_all, pc_descript_item)
            #  print(pc_descript_item)
            #  商品画像URLを設定
            df.iat[0, 27] = pc_descript_item

            #  商品画像URLを設定
            df.iat[0, 28] = out_image_url

            df.to_csv(os.path.join(resized_image_dir, "item.csv"), 
                      index=False, encoding="shift_jis")

        #  リスサイズ対象が存在しない
        else:

            log_info = "     [Not exists target Files]"
            print(log_info)
            logging.info(log_info)

except Exception as e:
    print(e)
    logging.error(e)
    #  プログラムはここで終了する
    sys.exit(1)
