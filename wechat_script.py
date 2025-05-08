import pyautogui
import time


pyautogui.FAILSAFE = True


pyautogui.hotkey('command', 'tab')
time.sleep(0.5)






pyautogui.click(1266, 746)
time.sleep(0.5)


pyautogui.write('123')


pyautogui.press('enter')

print("消息已发送")