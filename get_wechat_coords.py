import pyautogui
import time
import os

print("鼠标坐标获取工具")
print("请在5秒内将鼠标移动到微信输入框位置...")

for i in range(5, 0, -1):
print(f"{i}...")
time.sleep(1)


current_position = pyautogui.position()
print(f"当前鼠标坐标为: {current_position}")
print(f"X: {current_position.x}, Y: {current_position.y}")


with open("/Users/zzy/hope/rpa/wechat_coords.txt", "w") as f:
f.write(f"{current_position.x},{current_position.y}")

print(f"坐标已保存到文件: {os.path.abspath("/Users/zzy/hope/rpa/wechat_coords.txt")}")