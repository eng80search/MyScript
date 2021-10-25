import pytest
from playwright.sync_api import sync_playwright

with sync_playwright() as p:

    #  #  setting proxy
    #  browser = p.chromium.launch(proxy={
    #      "server": "http://w50743:passwordq1@proxy1.scskinfo.jp:8089",
    #      "username": "w50743",
    #      "password": "passwordq1"
    #  }, headless=False, slow_mo=1000)

    #  setting proxy
    browser = p.chromium.launch(
        args= ['--window-position=-9,0'],
        headless= False,
        slow_mo= 1000
        )

    context = browser.new_context(viewport={'width': 1920, 'height': 1080})

    page = context.new_page()
    page.goto("https://acuvue.jnj.co.jp/store/index.aspx")
    page.screenshot(path="example.png")
    browser.close()
