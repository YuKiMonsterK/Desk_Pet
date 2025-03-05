extends Node2D

@onready var interact = get_node("..")

func _ready():
	interact.connect("interact",_received_interact)

func _received_interact():
	print("OK")

