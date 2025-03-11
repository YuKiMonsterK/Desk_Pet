extends "res://script/menu_button.gd"
@onready var tomato = $"."

func _ready():
	print(room_mode)
	tomato.self_modulate = Color(1,1,1,1)
	panel_container.visible = false
	SignalManager.connect("button_press", _on_button_press)
	if not room_mode:
		tomato.icon = load("res://assets/測試的圖片資源/Tomato.jpg")
func _on_button_press(node_name):
	print("self = ",self.name," node = ",node_name)
	if node_name == self.name:
		panel_container.visible = true

func _on_mouse_entered():
	if not room_mode:
		tomato.self_modulate = Color(0.44,0.44,0.44,1)


func _on_mouse_exited():
	tomato.self_modulate = Color(1,1,1,1)
