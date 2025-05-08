import pyautogui
import time

print("鼠标坐标获取工具")
print("请在5秒内将鼠标移动到微信输入框位置...")

for i in range(5, 0, -1):
print(f"{i}...")
time.sleep(1)


current_position = pyautogui.position()
print(f"当前鼠标坐标为: {current_position}")
print(f"X: {current_position.x}, Y: {current_position.y}")
print("请记下这些坐标，用于微信自动化脚本")


print("接下来10秒将实时显示鼠标坐标，您可以微调鼠标位置...")
end_time = time.time() + 10

while time.time() < end_time:
x, y = pyautogui.position()
position_str = f"X: {x}, Y: {y}"
print(position_str, end="\r")
time.sleep(0.1)