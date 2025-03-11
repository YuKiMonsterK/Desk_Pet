extends "res://script/menu_button.gd"

func _on_button_press(node_name):
	print(self.name)
	if node_name == self.name:
		panel_container.visible = true
