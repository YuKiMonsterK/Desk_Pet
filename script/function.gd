extends Area2D

@onready var box = $box

func _ready():
	box.visible = false
	
func _on_node_2d_interact():
	print("receive")
	box.visible = true
