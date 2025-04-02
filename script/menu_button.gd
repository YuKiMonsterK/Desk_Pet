extends Control

@onready var panel_container: PanelContainer = $"."

#為之後的房間模式做準備
@export var room_mode = true

func _ready():
	#統一監聽訊號管理腳本
	SignalManager.connect("button_press", _on_button_press)
	SignalManager.connect("room_mode", _on_room_mode)
	panel_container.visible = false
	
func _on_button_press(node_name):
	#測試按鈕與對應訊息
	print("self = ",self.name," node = ",node_name)
	if node_name == self.name + "_button":
		panel_container.visible = true

func _on_room_mode():
	room_mode = true

func _on_exit_pressed() -> void:
	panel_container.visible = false
	SignalManager.emit_signal("exit_press", self.name)
