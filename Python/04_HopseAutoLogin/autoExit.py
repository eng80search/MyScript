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
import sys

#  set chrome driver location
DRIVER_PATH = "../my_driver/chromedriver.exe"

#  set webdriver options
# Seleniumをあらゆる環境で起動させるChromeオプション
options = Options()
options.add_argument('--disable-gpu')
options.add_argument('--disable-extensions')
options.add_argument('--proxy-server="direct://"')
options.add_argument('--proxy-bypass-list=*')
options.add_argument('--start-maximized')
# options.add_argument('--headless'); # ※ヘッドレスモードを使用する場合、コメントアウトを外す

#  launch browser
driver = webdriver.Chrome(executable_path=DRIVER_PATH, chrome_options=options)

#  要素を探すまでの最大の待ち時間（秒）
driver.implicitly_wait(10)

try:

    # access web page
    url = 'https://adopo.group.shiftinc.jp/sns/sns_login.cgi'
    driver.get(url)

    # get login id field
    selector_id = 'body > div > form > input:nth-child(4)'
    element_id = driver.find_element_by_css_selector(selector_id)

    # get login password field
    selector_pw = 'body > div > form > input:nth-child(5)'
    element_pw = driver.find_element_by_css_selector(selector_pw)

    # get login button field
    selector_button = 'body > div > form > button'
    element_button = driver.find_element_by_css_selector(selector_button)

    #  input login id and password
    element_id.send_keys('ri.geishun@hopes-ise.co.jp')
    element_pw.send_keys('Rigeishun2021@401')

    # click login button
    element_button.click()

    selector_button_taikin = 'body > div.container > div > div.span3.left_menu > div.left_navi > ul > div:nth-child(1) > a.btn.btn-warning'
    element_button_taikin = driver.find_element_by_css_selector(selector_button_taikin)

    # click login button
    element_button_taikin.click()

    #  工数１
    #  select_option_1 = 'body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(14) > td > div.area_option_project_list > select'
    select_option_1 = 'body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(15) > td > div.area_option_project_list > select'
    element_option_1 = driver.find_element_by_css_selector(select_option_1)

    #  select by index
    #  element_option_1.click()
    Select(element_option_1).select_by_index(1)

    #  実稼働
    #  少し間隔を置かないとdropdownlistの選択ができないので注意
    time.sleep(3)
    #  select_option_jitsukadou = 'body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(14) > td > span > select'
    select_option_jitsukadou = 'body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(15) > td > span > select'
    element_option_jitsukadou = driver.find_element_by_css_selector(select_option_jitsukadou)
    Select(element_option_jitsukadou).select_by_index(1)


    #  仕事時間
    time.sleep(1)
    #  selector_work_time = 'body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(14) > td > input[type=number]'
    selector_work_time = 'body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(15) > td > input[type=number]'
    element_work_time = driver.find_element_by_css_selector(selector_work_time)
    element_work_time.send_keys('8')

    # 一度クリックしてからページダウンするとスクロールができました
    # 最下部前スクロールしたければPAGE_DOWNを繰り返す
    driver.find_element_by_tag_name('body').click()
    driver.find_element_by_tag_name('body').send_keys(Keys.PAGE_DOWN)

    #  close browser
    #  driver.quit()
    #  退勤ボタン
    #  body > div.container > div > div.span3.left_menu > div.left_navi > ul > div:nth-child(1) > a.btn.btn-warning
    #  get login button field

    #  時間 body > div.container > div > div.span9 > form > table > tbody > tr:nth-child(14) > td > input[type=number]
    #  勤怠情報のチェック body > div.container > div > div.span9 > form > input.btn.btn-danger.btn-large

except Exception as e:
    print("Unexpected error:", sys.exc_info())

finally:
    time.sleep(3)
    now = datetime.datetime.now()
    screenshot_path = '00_screenshot/screenshot_exit_' + now.strftime('%Y%m%d_%H%M%S') + '.png'

    #  set window size to full screen
    page_width = driver.execute_script('return document.body.scrollWidth')
    page_height = driver.execute_script('return document.body.scrollHeight')
    driver.set_window_size(page_width, page_height)

    driver.save_screenshot(screenshot_path)
