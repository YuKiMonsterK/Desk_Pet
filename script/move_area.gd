extends Node2D
var move_edge = false
var move_p : Vector2i
var node

@onready var area_2d: Area2D = $"."

func _ready() -> void:
	node = get_parent()
	print(node)
	area_2d.visible = false

func _process(delta: float) -> void:
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	if node.visible == true:
		area_2d.visible = true
	else:
		area_2d.visible = false
func _input(event):
	#正在拖移
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		node.position = Vector2i(DisplayServer.mouse_get_position()) + move_p
	elif Input.is_action_pressed("accept") and not move_edge and event is InputEventMouseMotion:
		#沒在拖移，但正進行可能的活動（按下左鍵並拖移）
		move_p = Vector2i(node.position) - DisplayServer.mouse_get_position()
	
func _on_mouse_exited() -> void:
	move_edge = true
