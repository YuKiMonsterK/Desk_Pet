extends Node2D

# 节点引用
@onready var focus_time_label = $VBoxContainer/Label  # 显示专注时长的标签
@onready var clear_focus_button = $VBoxContainer/Button  # 清除所有专注时长的按钮

# 变量存储当前专注时长和累计专注时长
var current_focus_time = 0  # 当前专注时长（单位：秒）
var accumulated_focus_time = 0  # 累计专注时长（单位：秒）

# 专注时长记录定时器
@onready var focus_timer: Timer = $focus_timer


# 初始化
func _ready():
	# 设置定时器
	focus_timer.wait_time = 1  # 每秒更新一次
	SignalManager.connect("start_tracking", _start_tracking)
	SignalManager.connect("stop_tracking", _stop_tracking)
	
	## 按钮连接信号
	clear_focus_button.pressed.connect(_on_clear_focus_pressed)
	
	# 更新 UI
	update_ui()

# 每秒增加当前专注时长
func _start_tracking():
		focus_timer.start()
# 更新 UI
func update_ui():
	focus_time_label.text = "专注时长: %s 秒" % accumulated_focus_time  # 显示累计工作时长

# 清除所有专注时长
func _on_clear_focus_pressed():
	current_focus_time = 0  # 重置当前专注时长
	accumulated_focus_time = 0  # 重置累计专注时长
	update_ui()

func _stop_tracking():
	focus_timer.stop()

func _on_focus_timer_timeout() -> void:
	current_focus_time += 1  # 每秒加1
	accumulated_focus_time += 1  # 累计时间
	update_ui()
	focus_timer.start()
