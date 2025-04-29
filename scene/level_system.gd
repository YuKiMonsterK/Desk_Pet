extends Node

var total_seconds = 0
var level = 1
@onready var timer = $Timer
@onready var label_level = $"../Label_Level"
@onready var label_time = $"../Label_Time"

func _ready():
	timer.timeout.connect(_on_timer_timeout)


func start_tracking():
	timer.start()

func _on_timer_timeout():
	total_seconds += 1
	level = get_level_from_seconds(total_seconds)
	update_ui()
	print(level)

func get_level_from_seconds(total_seconds):
	return floor(sqrt(total_seconds / 60)) + 1

func update_ui():
	if label_time:
		label_time.text = "總陪伴時間: %s 秒" % total_seconds
	if label_level:
		label_level.text = "等級: %s" % level
