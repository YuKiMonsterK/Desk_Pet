extends Node2D

@onready var game_window: Node2D = $game_window
@onready var camera_2d: Camera2D = $Camera2D
@onready var accept: Area2D = $game_window/accept
@onready var collision_polygon_2d: CollisionPolygon2D = $game_window/click_area/CollisionPolygon2D
@onready var background: Sprite2D = $game_window/Sprite2D

var move_edge = false
var move_p = Vector2i()
var accept_sec = 0
var menu_area = false

var room_mode = true  # 為之後的房間模式做準備

func _ready():
	var screen_size = DisplayServer.screen_get_size()
	SignalManager.connect("room_mode", _on_room_mode)
	
	
func _process(_delta):
	accept.position = Vector2i(get_global_mouse_position())
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	collision_polygon_2d.position = background.position
	if not is_instance_valid(collision_polygon_2d):
		return
	var click_polygon: PackedVector2Array = collision_polygon_2d.polygon.duplicate()
	for i in range(click_polygon.size()):
		click_polygon[i] = collision_polygon_2d.to_global(click_polygon[i])
	get_window().mouse_passthrough_polygon = click_polygon

func _input(event):
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		game_window.position = Vector2(DisplayServer.mouse_get_position()) + move_p
	elif Input.is_action_pressed("accept") and not move_edge:
		move_p = game_window.position - Vector2(DisplayServer.mouse_get_position())

func _on_move_mouse_exited():
	move_edge = true

func _on_room_mode():
	room_mode = true
