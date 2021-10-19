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
