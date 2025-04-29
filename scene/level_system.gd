extends Node

var total_seconds = 0
var level = 1
@onready var timer = $Timer
@onready var level_label = $LevelLabel
@onready var progress_label = $ProgressLabel
@onready var progress_bar = $LabelProgress

const SAVE_FILE = "user://level_save.cfg"
const SAVE_SECTION = "level_data"

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	load_data()  # 加载存档数据
	update_ui()

func start_tracking():
	timer.start()

func _on_timer_timeout():
	total_seconds += 1
	level = get_level_from_seconds(total_seconds)
	update_ui()
	save_data()  # 每次更新后保存数据
	print("秒數：%s，等級：%s" % [total_seconds, level])  # 除錯輸出

func get_level_from_seconds(total_seconds):
	return floor(sqrt(total_seconds / 60)) + 1

func update_ui():
	if progress_label:
		progress_label.text = "總陪伴時間: %s 秒" % total_seconds
	if level_label:
		level_label.text = "等級: %s" % level
	if progress_bar:
		progress_bar.value = total_seconds % 60  # 使用模60來顯示進度

func save_data():
	var config = ConfigFile.new()
	config.set_value(SAVE_SECTION, "total_seconds", total_seconds)
	config.set_value(SAVE_SECTION, "level", level)
	config.save(SAVE_FILE)

func load_data():
	var config = ConfigFile.new()
	var err = config.load(SAVE_FILE)
	if err == OK:  # 如果成功加载存档
		total_seconds = config.get_value(SAVE_SECTION, "total_seconds", 0)
		level = config.get_value(SAVE_SECTION, "level", 1)
