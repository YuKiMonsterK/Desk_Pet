extends Node2D

@onready var interact = get_node("..")

signal send_message

func _ready():
	interact.connect("interact",_received_interact)

func _received_interact():
	emit_signal(owner.name)
	print(self)

