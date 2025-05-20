extends Node2D

# 節點引用
@onready var focus_time_label = $VBoxContainer/Label  # 顯示專注時長的標籤
@onready var clear_focus_button = $VBoxContainer/Button  # 清除所有專注時長的按鈕

# 變數儲存當前專注時長和累計專注時長
var current_focus_time = 0  # 當前專注時長（單位：秒）
var accumulated_focus_time = 0  # 累計專注時長（單位：秒）

# 專注時長記錄計時器
@onready var focus_timer: Timer = $focus_timer

# 儲存檔案相關常數
const SAVE_FILE = "user://focus_save.cfg"
const SAVE_SECTION = "focus_data"

# 初始化
func _ready():
	# 設定計時器
	focus_timer.wait_time = 1  # 每秒更新一次
	SignalManager.connect("start_tracking", _start_tracking)
	SignalManager.connect("stop_tracking", _stop_tracking)
	
	# 載入儲存的資料
	load_data()
	
	# 更新 UI
	update_ui()

## 每秒增加當前專注時長
#func _process(delta):
	#if focus_timer.time_left <= 0:
		#current_focus_time += 1  # 每秒加1
		#accumulated_focus_time += 1  # 累計時間
		#update_ui()
	
func _start_tracking():
	focus_timer.start()

# 更新 UI
func update_ui():
	focus_time_label.text = "專注時長: %s 秒" % accumulated_focus_time  # 顯示累計工作時長

func _stop_tracking():
	focus_timer.stop()
	save_data()  # 停止時儲存資料

func _on_focus_timer_timeout() -> void:
	current_focus_time += 1  # 每秒加1
	accumulated_focus_time += 1  # 累計時間
	update_ui()
	save_data()  # 每次更新後儲存資料
	focus_timer.start()

# 儲存資料
func save_data():
	var config = ConfigFile.new()
	config.set_value(SAVE_SECTION, "current_focus_time", current_focus_time)
	config.set_value(SAVE_SECTION, "accumulated_focus_time", accumulated_focus_time)
	config.save(SAVE_FILE)

# 載入資料
func load_data():
	var config = ConfigFile.new()
	var err = config.load(SAVE_FILE)
	if err == OK:  # 如果成功載入存檔
		current_focus_time = config.get_value(SAVE_SECTION, "current_focus_time", 0)
		accumulated_focus_time = config.get_value(SAVE_SECTION, "accumulated_focus_time", 0)
