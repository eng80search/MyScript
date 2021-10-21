import pytest
import unittest
import time
from playwright.sync_api import Page

#  pytest-playwright option list
#  --headed  Run tests in headed mode (default: headless)
#  --output  Directory for artifacts produced by tests (default: test-results).

#  指定テストコードのみ実施
#  pytest tests/test_calc.py

#  テストケース別に結果を知りたい
#  pytest -vv

#  前回NGだったケースだけテストしたい (last-failed)
#  pytest -vv --lf

#  特定の関数のみテストする
#  pytest test/test_foo.py::test_function

#  デバイス指定でテストを行う
#  pytest -vv --device="Desktop Chrome"
#  pytest -vv --device="iPad Mini"
#  pytest -vv --device="Pixel 5"


class TestClassPc:

    @pytest.fixture(autouse=True)
    def setup(self, page: Page):
        self.page = page
        page.set_viewport_size({
            "width": 1920,
            "height": 1080
            })

    #  pytest --base-url https://acuvue.jnj.co.jp
    def test_index_working(self):

        #  Index画面
        self.page.goto("/store/index.aspx")
        time.sleep(5)

        #  確認：ヘッダ
        text = self.page.inner_text("div.contentsBodyInr > h1")
        assert text == "取扱い店検索"

        #  確認：特定の商品名が含まれているのか
        text = self.page.inner_text(
            "div#conditionalContentsInner01 > .checkBoxLeftA01 > \
                               .accordionBoxA02 > ul"
        )
        assert "ワンデー アキュビュー® セラビジョン® アレルケア®" in text

        #  確認：チェックボックスにCheck Off
        checked = self.page.is_checked("#check01_20")
        assert checked == False

        #  self.page.mouse.move(0, 0)
        #  self.page.mouse.click(860, 590)
        #  self.page.mouse.click(590, 560)
        #  time.sleep(2)
        #  self.page.mouse.click(1095, 395)
        #  time.sleep(21)

        #  save screenshot
        self.page.screenshot(path="./screenshot/01_index.png", full_page=True)

    def test_index_with_param_working(self):

        #  Index画面
        self.page.goto("/store/index.aspx?BrandID=1Day_Theravision_K")
        time.sleep(5)

        #  確認：ヘッダ
        text = self.page.inner_text("div.contentsBodyInr > h1")
        assert text == "取扱い店検索"

        #  確認：特定の商品名が含まれているのか
        text = self.page.inner_text(
            "div#conditionalContentsInner01 > .checkBoxLeftA01 > \
                               .accordionBoxA02 > ul"
        )
        assert "ワンデー アキュビュー® セラビジョン® アレルケア®" in text

        #  確認：チェックボックスにCheck ON
        checked = self.page.is_checked("#check01_20")
        assert checked == True

        #  save screenshot
        self.page.screenshot(
            path="./screenshot/01_index_with_param.png", full_page=True
        )

    def test_result_area_map_working(self):

        #  Index画面
        self.page.goto("/store/result.aspx?lat=35.690652778&lon=139.706638889")
        time.sleep(5)

        #  確認：店舗件数確認
        store_cnt_normal = self.page.inner_text("#lblStoreCnt")
        assert int(store_cnt_normal) > 20

        #  確認：店舗画像確認
        #  store_img = self.page.inner_text("div#resultList  div.storePhotoA01 > span.storePhotoA01 list")
        store_list = self.page.inner_html("div#resultList")
        #  store_img = self.page.get_attribute('img:right-of(:text("Ｊコンタクト　新宿店"))', "src")
        #  確認：既存店舗名と表示画像確認
        assert "Ｊコンタクト　新宿店" in store_list
        assert "./BinaryStoreImage.aspx?StoreSeq=10237" in store_list

        #  店舗結果画面_地域選択_初期表示
        self.page.screenshot(path="./screenshot/02_result_map_area.png", full_page=True)

        #  地図拡大
        for cnt in range(3):
            self.page.mouse.click(505, 575)
            time.sleep(3)

        #  確認：店舗件数確認_拡大後
        store_cnt_zoom_in = self.page.inner_text("#lblStoreCnt")
        assert int(store_cnt_zoom_in) < int(store_cnt_normal)

        #  店舗結果画面_地域選択_拡大表示
        self.page.screenshot(path="./screenshot/02_result_map_area_zoom_in.png", full_page=True)

        #  地図移動_倍率リセット
        for cnt in range(3):
            self.page.mouse.click(510, 705)
            time.sleep(3)

        #  地図移動_右移動
        for cnt in range(3):
            self.page.mouse.click(530, 530)
            time.sleep(3)

        #  確認：店舗件数確認_右移動後
        store_cnt_right = self.page.inner_text("#lblStoreCnt")
        assert int(store_cnt_right) != int(store_cnt_normal)

        #  店舗結果画面_地域選択_右移動後
        self.page.screenshot(path="./screenshot/02_result_map_area_move_right.png", \
                             full_page=True)

        #  地図縮小
        for cnt in range(3):
            self.page.mouse.click(510, 705)
            time.sleep(3)

        #  確認：店舗件数確認_縮小後
        store_cnt_zoom_out = self.page.inner_text("#lblStoreCnt")
        assert int(store_cnt_zoom_out) > int(store_cnt_normal)

        #  店舗結果画面_地域選択_縮小表示
        self.page.screenshot(path="./screenshot/02_result_map_area_zoom_out.png", full_page=True)


    def test_result_freeword_working(self):

        #  Index画面
        self.page.goto("/store/index.aspx")
        time.sleep(5)
        self.page.fill("#txtFreeword", "東京都 新宿区")
        self.page.click("text='この条件で検索する'")
        time.sleep(5)

        #  店舗結果画面
        self.page.screenshot(path="./screenshot/02_result.png", full_page=True)

    def test_detail_working(self):

        #  店舗詳細画面：丸尾コンタクト 高田馬場
        self.page.goto("/store/detail.aspx?StoreSeq=20758")
        time.sleep(3)

        #  確認：ワンデー アキュビュー® セラビジョン® アレルケア® 取り扱いあり
        icon_o = self.page.get_attribute("#lblHandleOnedayTheravisionK", "src")
        assert icon_o == "/shared/img/cmn_ico_034.png"

        self.page.screenshot(path="./screenshot/03_detail.png", full_page=True)

        self.page.click("text='地図を印刷する'")
        time.sleep(3)

    def test_store_list_working(self):

        #  店舗詳細画面：丸尾コンタクト 高田馬場
        self.page.goto("/store/detail.aspx?StoreSeq=20758")
        time.sleep(3)

        #  店舗一覧画面 : 東京都新宿区店舗一覧
        self.page.click("#imgStoreList")
        time.sleep(3)
        self.page.screenshot(path="./screenshot/05_store-list.png", full_page=True)

    def test_detail_print_working(self):

        #  地図印刷プレビュー画面
        self.page.goto("/store/detail-print.aspx?storeSeq=20758&mapScale=12")
        time.sleep(3)
        self.page.screenshot(path="./screenshot/04_detail-print.png", full_page=True)
