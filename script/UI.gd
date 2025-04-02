extends Node2D

@onready var game_window: Node2D = $game_window
@onready var background_click_area: CollisionPolygon2D = $game_window/Sprite2D/click_area/CollisionPolygon2D
@onready var background: Sprite2D = $game_window/Sprite2D

var move_edge = false
var move_p = Vector2i()
var accept_sec = 0
var menu_area = false
var area_in = "null"
var room_mode = true  # 為之後的房間模式做準備

func _ready():
	SignalManager.connect("room_mode", _on_room_mode)
	SignalManager.connect("button_press", _on_button_press)
	SignalManager.connect("exit_press", _on_exit_press)
	var BG_click_polygon: PackedVector2Array = background_click_area.polygon.duplicate()
	var screen_size = get_viewport_rect().size  # 取得螢幕大小
	var window_size = Vector2(1000, 300)
	# 將 game_window 的左上角對齊螢幕右下角
	game_window.position = screen_size - window_size
	
func _process(_delta):
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	var BG_click_polygon: PackedVector2Array = background_click_area.polygon.duplicate()
	for i in range(BG_click_polygon.size()):
		BG_click_polygon[i] = background_click_area.to_global(BG_click_polygon[i])
	get_window().mouse_passthrough_polygon = BG_click_polygon
	

func _input(event):
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		game_window.position = Vector2(DisplayServer.mouse_get_position()) + move_p
	elif Input.is_action_pressed("accept") and not move_edge:
		move_p = game_window.position - Vector2(DisplayServer.mouse_get_position())

func _on_move_mouse_exited():
	move_edge = true

func _on_room_mode():
	room_mode = true

func _on_click_area_mouse_entered() -> void:
	area_in = "background"
	
func _on_button_press(node_name):
	var node = game_window.get_node(node_name.replace("_button", ""))
	node.visible = true

func _on_exit_press(node_name):
	var node = game_window.get_node(node_name.replace("_button", ""))
	node.visible = false
