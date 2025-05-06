extends Node3D
@onready var book: MeshInstance3D = $book

func _ready() -> void:
	SignalManager.connect("start_studing", _start_studing)
	SignalManager.connect("end_study", _end_study)
	
func _start_studing():
	book.visible = false
	
func _end_study():
	book.visible = true
