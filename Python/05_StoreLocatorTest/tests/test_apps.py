import pytest
import time
from playwright.sync_api import sync_playwright


def ttest_index_working(browser):

    page = browser.new_page()
    page.goto("https://acuvue.jnj.co.jp/store/index.aspx")
    time.sleep(3)
    page.fill('#txtFreeword', '東京都 新宿区')
    page.click("text='この条件で検索する'")
    #  page.screenshot(path="test.png", full_page=True)
    browser.close()


def test_index_working2(page):

    page.goto("https://acuvue.jnj.co.jp/store/index.aspx")
    time.sleep(3)
    #  page.screenshot(path="test.png", full_page=True)
