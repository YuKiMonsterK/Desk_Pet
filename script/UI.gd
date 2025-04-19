extends Node2D

@onready var game_window: Node2D = $game_window
@onready var background_click_area: CollisionPolygon2D = $game_window/Sprite2D/click_area/CollisionPolygon2D
@onready var background: Sprite2D = $game_window/Sprite2D
@onready var character_body_2d: CharacterBody2D = $game_window/CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $game_window/CharacterBody2D/move/CollisionShape2D
@onready var timer: Timer = $Timer

var move_edge = false #當滑鼠在拖移區的邊緣
var move_p = Vector2i()
var accept_sec = 0
var menu_area = false
var room_mode = true  # 為之後的房間模式做準備
var moving = false
var character_p = 0
var direction = 0

func _ready():
	collision_shape_2d.position = Vector2(-36.04,-197.078)
	SignalManager.connect("room_mode", _on_room_mode) #連接信號
	SignalManager.connect("button_press", _on_button_press)
	SignalManager.connect("exit_press", _on_exit_press)
	SignalManager.connect("colliding", _on_colliding)
	SignalManager.connect("start_studing", _on_studing)
	var screen_size = get_viewport_rect().size
	var window_size = Vector2(1000, 300)
	# 將 game_window 的左上角對齊螢幕右下角
	game_window.position = screen_size - window_size
	timer.wait_time = randf_range(5,15)
	
func _process(_delta):
	if not moving and timer.is_stopped() and character_p == 0: 
		timer.start()

	if not Input.is_action_pressed("accept") and collision_shape_2d.position == Vector2(-31.88,-217.878):
		#使只有在結束拖移時才會取消moving並回到停滯狀態
		moving = false
		SignalManager.emit_signal("character_stop")
		collision_shape_2d.position = Vector2(-36.04,-197.078)
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	if character_p != 0 and (int(character_body_2d.position.x) - int(character_p) > 20 
	or int(character_body_2d.position.x) - int(character_p) < -20):
		
		if character_body_2d.position.x > character_p:
			direction = -1
		else:
			direction = 1
		character_body_2d.velocity.x = direction * 100
		SignalManager.emit_signal("character_walk",direction)
		character_body_2d.move_and_slide()
	elif character_p != 0:
		character_p = 0
		SignalManager.emit_signal("character_stop")
func _input(event):
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		#正在拖移
		character_body_2d.position.x = DisplayServer.mouse_get_position().x + move_p
		collision_shape_2d.position = Vector2(-31.88,-217.878)
		SignalManager.emit_signal("character_move")
		moving = true
		timer.stop()
	elif Input.is_action_pressed("accept") and not move_edge and event is InputEventMouseMotion:
		#沒在拖移，但正進行可能的活動（按下左鍵並拖移）
		move_p = character_body_2d.position.x - DisplayServer.mouse_get_position().x

func _on_move_mouse_exited():
	move_edge = true
	
func _on_room_mode():
	room_mode = true
	
func _on_button_press(node_name):
	var node = game_window.get_node(node_name.replace("_button", ""))
	node.visible = true

func _on_exit_press(node_name):
	var node = game_window.get_node(node_name.replace("_button", ""))
	node.visible = false
	
func _on_colliding(d):
	if d == "left" and move_edge:
		character_body_2d.position.x  = -404.0
	elif d == "right" and move_edge:
		character_body_2d.position.x = 252.0
	move_edge = false
	SignalManager.emit_signal("character_stop")

func _on_timer_timeout() -> void:
	character_p = randi_range(-399, 237)
	timer.wait_time = randf_range(5,15)

func _on_studing():
	character_p = 157
	moving = true
