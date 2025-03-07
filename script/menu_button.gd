extends "res://script/base_button.gd"


func _ready():
	SignalManager.connect("button_press", _on_button_press)

func _on_button_press(node_name):
	if node_name == self.name:
		print("me")
