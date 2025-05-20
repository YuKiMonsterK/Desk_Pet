extends Button

# 保存文件相关常量
const SAVE_FILE = "user://button_save.cfg"
const SAVE_SECTION = "button_data"

var total_press_time = 0  # 总点击次数

func _ready():
	load_data()  # 加载保存的数据

func _on_button_down():
	#統一發送至訊號管理腳本
	SignalManager.emit_signal("button_press", self.name)
	total_press_time += 1
	save_data()  # 保存数据

# 保存数据
func save_data():
	var config = ConfigFile.new()
	config.set_value(SAVE_SECTION, "total_press_time", total_press_time)
	config.save(SAVE_FILE)

# 加载数据
func load_data():
	var config = ConfigFile.new()
	var err = config.load(SAVE_FILE)
	if err == OK:  # 如果成功加载存档
		total_press_time = config.get_value(SAVE_SECTION, "total_press_time", 0)
