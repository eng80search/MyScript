import pytest
from playwright.sync_api import sync_playwright


@pytest.fixture()
def browser():

    playwright = sync_playwright().start()

    #  setting proxy
    browser = playwright.chromium.launch(proxy={
        "server": "http://w50743:passwordq1@proxy1.scskinfo.jp:8089",
        "username": "w50743",
        "password": "passwordq1"
    }, headless=False, slow_mo=1000)

    #  return browser.new_page()
    return browser


@pytest.fixture()
def page():

    playwright = sync_playwright().start()

    #  setting proxy
    browser = playwright.chromium.launch(proxy={
        "server": "http://w50743:passwordq1@proxy1.scskinfo.jp:8089",
        "username": "w50743",
        "password": "passwordq1"
    })

    return browser.new_page()
    #  return browser
