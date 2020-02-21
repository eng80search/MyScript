import pyautogui
import sys
import time

#  #  スクリンショットを取る
#  sc = pyautogui.screenshot('test.png')

#  screen_x,screen_y = pyautogui.size()
#  curmus_x,curmus_y = pyautogui.position()
#  print (u"printについてる[u]はunicodeにするのuでマルチバイト表記が化けるときにつけるよ")
#  print (u"画面サイズ [" + str(screen_x) + "]/[" + str(screen_y) + "]")
#  print (u"現在のマウス位置 [" + str(curmus_x) + "]/[" + str(curmus_y) + "]")
#  center_x = screen_x / 2
#  center_y = screen_y / 2
#  print (u"画面中央 [" + str(center_x) + "]/[" + str(center_y) + "]")
#  pyautogui.moveTo(center_x, center_y, duration=2)
#  print (u"２秒かけて、マウスが中央に移動したかい?、duration=(移動にかける時間[sec])だよ")


#  マウスの位置を表示してくれるスクリプト
print('Press Ctrl-C to quit.')
try:
    while True:
        x, y = pyautogui.position()
        positionStr = 'X: ' + str(x).rjust(4) + ' Y: ' + str(y).rjust(4)
        print(positionStr, end='')
        print('\b' * len(positionStr), end='', flush=True)
except KeyboardInterrupt:
    print('\n')
