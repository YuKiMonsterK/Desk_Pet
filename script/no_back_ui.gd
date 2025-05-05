extends Node2D

@onready var game_window: Node2D = $game_window
@onready var character_body_2d: CharacterBody2D = $game_window/CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $game_window/CharacterBody2D/move/CollisionShape2D
@onready var no_back_ui: Node2D = $"."

var move_edge = false #當滑鼠在拖移區的邊緣
var move_p = Vector2i()
var accept_sec = 0
var menu_area = false
var moving = false
var character_p = 0
var direction = 0
var study = false
var stop = false
var in_move_area = false
var p = Vector2(0,0)
func _ready():
	#初始化
	collision_shape_2d.position = Vector2(-36.04,-197.078)
	SignalManager.connect("button_press", _on_button_press)
	SignalManager.connect("exit_press", _on_exit_press)
	SignalManager.connect("colliding", _on_colliding)
	SignalManager.connect("to_study", _to_study)
	SignalManager.connect("room_mode", _room_mode)
	var screen_size = get_viewport_rect().size
	game_window.position = p
func _process(_delta):
	
	#在結束拖移時才會取消moving並回到停滯狀態
	if not Input.is_action_pressed("accept") and collision_shape_2d.position == Vector2(-31.88,-217.878):
		moving = false
		SignalManager.emit_signal("character_stop")
		collision_shape_2d.position = Vector2(-36.04,-197.078)
		
	#在邊緣但沒有按左鍵就關閉move_edge
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	
	
func _input(event):
	#正在拖移
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		game_window.position = Vector2i(DisplayServer.mouse_get_position()) + move_p
		collision_shape_2d.position = Vector2(-31.88,-217.878)
		SignalManager.emit_signal("character_drag")
		moving = true
	elif Input.is_action_pressed("accept") and not move_edge and event is InputEventMouseMotion:
		#沒在拖移，但正進行可能的活動（按下左鍵並拖移）
		move_p = Vector2i(game_window.position) - DisplayServer.mouse_get_position()
	#正在摸頭，缺點是拖移時會有一段摸頭的時期
	if Input.is_action_pressed("accept") and in_move_area and event is InputEventMouseMotion and not move_edge:
		SignalManager.emit_signal("character_caress","y")
	elif not in_move_area:
		SignalManager.emit_signal("character_caress","n")
		
func _on_move_mouse_entered() -> void:
	in_move_area = true
	move_edge = false
	
func _on_move_mouse_exited():
	print("t")
	move_edge = true
	in_move_area = false
	
func _on_button_press(node_name):
	var node = game_window.get_node(node_name.replace("_button", ""))
	node.visible = true

func _on_exit_press(node_name):
	var node = game_window.get_node(node_name.replace("_button", ""))
	node.visible = false
	
func _on_colliding(d):
	if d == "left" and move_edge:
		game_window.position.x  = -404.0
	elif d == "right" and move_edge:
		game_window.position.x = 252.0
	move_edge = false
	SignalManager.emit_signal("character_stop")

func _to_study() -> void:
	SignalManager.emit_signal("start_studing")

func _on_back_to_home_pressed() -> void:
	SignalManager.emit_signal("back_home")
	
func _room_mode():
	var UI = load("res://scene/UI.tscn").instantiate()
	get_tree().root.add_child(UI)  # 把新的場景加到畫面上
	SignalManager.emit_signal("c_back") #角色回到房間的動畫
	no_back_ui.queue_free()  # 把自己刪掉
