extends Node2D

# 节点引用
@onready var focus_time_label = $VBoxContainer/Label  # 显示专注时长的标签
@onready var clear_focus_button = $VBoxContainer/Button  # 清除所有专注时长的按钮

# 变量存储当前专注时长和累计专注时长
var current_focus_time = 0  # 当前专注时长（单位：秒）
var accumulated_focus_time = 0  # 累计专注时长（单位：秒）

# 专注时长记录定时器

@onready var focus_timer: Timer = $focus_timer

# 保存文件相关常量
const SAVE_FILE = "user://focus_save.cfg"
const SAVE_SECTION = "focus_data"

# 初始化
func _ready():
	# 设置定时器
	focus_timer.wait_time = 1  # 每秒更新一次
	SignalManager.connect("start_tracking", _start_tracking)
	SignalManager.connect("stop_tracking", _stop_tracking)
	
	## 按钮连接信号
	clear_focus_button.pressed.connect(_on_clear_focus_pressed)
	
	# 加载保存的数据
	load_data()
	
	# 更新 UI
	update_ui()

# 每秒增加当前专注时长
func _process(delta):
	if focus_timer.time_left <= 0:
		current_focus_time += 1  # 每秒加1
		accumulated_focus_time += 1  # 累计时间
		update_ui()
    
func _start_tracking():
	focus_timer.start()

# 更新 UI
func update_ui():
	focus_time_label.text = "专注时长: %s 秒" % accumulated_focus_time  # 显示累计工作时长

func _stop_tracking():
	focus_timer.stop()
	save_data()  # 停止时保存数据

func _on_focus_timer_timeout() -> void:
	current_focus_time += 1  # 每秒加1
	accumulated_focus_time += 1  # 累计时间
	update_ui()
	save_data()  # 每次更新后保存数据
	focus_timer.start()

# 保存数据
func save_data():
	var config = ConfigFile.new()
	config.set_value(SAVE_SECTION, "current_focus_time", current_focus_time)
	config.set_value(SAVE_SECTION, "accumulated_focus_time", accumulated_focus_time)
	config.save(SAVE_FILE)

# 加载数据
func load_data():
	var config = ConfigFile.new()
	var err = config.load(SAVE_FILE)
	if err == OK:  # 如果成功加载存档
		current_focus_time = config.get_value(SAVE_SECTION, "current_focus_time", 0)
		accumulated_focus_time = config.get_value(SAVE_SECTION, "accumulated_focus_time", 0)

