extends "res://script/base_button.gd"

@onready var panel_container = $PanelContainer

#為之後的房間模式做準備
@export var room_mode = false

func _ready():
	#統一監聽訊號管理腳本
	SignalManager.connect("button_press", _on_button_press)
	panel_container.visible = false
	
func _on_button_press(node_name):
	#測試按鈕與對應訊息
	print(self.name)
	if node_name == self.name:
		panel_container.visible = true


func _on_exit_button_down():
	panel_container.visible = false
