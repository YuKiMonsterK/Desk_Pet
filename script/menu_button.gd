extends "res://script/base_button.gd"

@onready var canvas_layer = $CanvasLayer
#為之後的房間模式做準備
@export var room_mode = false
var box = false

func _ready():
	#統一監聽訊號管理腳本
	SignalManager.connect("button_press", _on_button_press)
	canvas_layer.visible = false
func _on_button_press(node_name):
	#測試按鈕與對應訊息
	if node_name == "MenuB" and not box:
		print("I am MenuB")
		canvas_layer.visible = true

func _on_exit_button_down():
	canvas_layer.visible = false
