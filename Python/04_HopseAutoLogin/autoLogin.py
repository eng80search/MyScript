# browser_auto_foods.py
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.select import Select
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.alert import Alert
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

import datetime
import time
import random
import sys
import logging

#  set chrome driver location
DRIVER_PATH = "../my_driver/chromedriver.exe"

#  set log format
logging.basicConfig(filename='myapp.log', format='%(asctime)s %(message)s', level=logging.INFO)

#  set webdriver options
# Seleniumをあらゆる環境で起動させるChromeオプション
options = Options()
options.add_argument("--disable-gpu")
options.add_argument("--disable-extensions")
options.add_argument('--proxy-server="direct://"')
options.add_argument("--proxy-bypass-list=*")
options.add_argument("--start-maximized")
options.add_argument('--headless'); # ※ヘッドレスモードを使用する場合、コメントアウトを外す

#  launch browser
driver = webdriver.Chrome(executable_path=DRIVER_PATH, chrome_options=options)

#  要素を探すまでの最大の待ち時間（秒）
driver.implicitly_wait(10)

try:

    logging.info('start access web page...')
    # access web page
    url = "https://adopo.group.shiftinc.jp/sns/sns_login.cgi"
    driver.get(url)

    logging.info('get login field')
    # get login id field
    selector_id = "body > div > form > input:nth-child(4)"
    element_id = driver.find_element_by_css_selector(selector_id)

    # get login password field
    selector_pw = "body > div > form > input:nth-child(5)"
    element_pw = driver.find_element_by_css_selector(selector_pw)

    # get login button field
    selector_button = "body > div > form > button"
    element_button = driver.find_element_by_css_selector(selector_button)

    logging.info('input login id and password')
    #  input login id and password
    element_id.send_keys("ri.geishun@hopes-ise.co.jp")
    element_pw.send_keys("Rigeishun2021@401")

    # click login button
    element_button.click()
    logging.info('clicked login button')

    selector_button_syukin = "#regist_syukkin_date_nowtime_from_left_menu"
    element_button_syukin = driver.find_element_by_css_selector(selector_button_syukin)

    #  遅延秒数を設定
    delay_second = random.randrange(2, 60)
    time.sleep(delay_second)
    element_button_syukin.click()
    logging.info('clicked 出勤 button')

    #  close browser
    #  driver.quit()
    #  退勤ボタン
    #  body > div.container > div > div.span3.left_menu > div.left_navi > ul > div:nth-child(1) > a.btn.btn-warning
    #  get login button field

    #  時間 body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(14) > td > input[type=number]
    #  勤怠情報のチェック body > div.container > div > div.span9 > form > input.btn.btn-danger.btn-large

except Exception as e:
    print("Unexpected error:", sys.exc_info())
    logging.error('Unexpected error:'.join(map(str, sys.exc_info())))

finally:
    #  time.sleep(9)
    now = datetime.datetime.now()
    screenshot_path = (
        "00_screenshot/screenshot_login_" + now.strftime("%Y%m%d_%H%M%S") + ".png"
    )

    #  set window size to full screen
    page_width = driver.execute_script('return document.body.scrollWidth')
    page_height = driver.execute_script('return document.body.scrollHeight')
    driver.set_window_size(page_width, page_height)

    driver.save_screenshot(screenshot_path)
    logging.info('saved screenshot')
