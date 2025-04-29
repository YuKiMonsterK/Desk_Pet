extends Node2D

@onready var game_window: Node2D = $game_window
@onready var background: Sprite2D = $"game_window/room-1"
@onready var character_body_2d: CharacterBody2D = $game_window/CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $game_window/CharacterBody2D/move/CollisionShape2D
@onready var timer: Timer = $Timer
@onready var level_system: Node2D = $"."


var move_edge = false #當滑鼠在拖移區的邊緣
var move_p = Vector2i()
var accept_sec = 0
var menu_area = false
var room_mode = true  # 為之後的房間模式做準備
var moving = false
var character_p = 0
var direction = 0
var study = false
var stop = false

func _ready():
	#初始化
	collision_shape_2d.position = Vector2(-36.04,-197.078)
	SignalManager.connect("room_mode", _on_room_mode) #連接信號
	SignalManager.connect("button_press", _on_button_press)
	SignalManager.connect("exit_press", _on_exit_press)
	SignalManager.connect("colliding", _on_colliding)
	SignalManager.connect("start_studing", _on_study)
	SignalManager.connect("to_study", _to_study)
	SignalManager.connect("end_study", _end_study)
	SignalManager.connect("start_studing", _on_studing)
	var screen_size = get_viewport_rect().size
	var window_size = Vector2(1000, 300)
	# 將 game_window 的左上角對齊螢幕右下角
	game_window.position = screen_size - window_size
	timer.wait_time = randf_range(5,15)
	var level_system = $LevelSystem
	level_system.start_tracking()
	
func _process(_delta):
	
	#當沒移動且沒開計時且沒有目標位置
	if not moving and timer.is_stopped() and character_p == 0 and not stop: 
		timer.start()
		
	#在結束拖移時才會取消moving並回到停滯狀態
	if not Input.is_action_pressed("accept") and collision_shape_2d.position == Vector2(-31.88,-217.878):
		moving = false
		SignalManager.emit_signal("character_stop")
		collision_shape_2d.position = Vector2(-36.04,-197.078)
		
	#在邊緣但沒有按左鍵就關閉move_edge
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	
	#如果有目標位置且相距大於20就向那裡移動
	if character_p != 0 and (int(character_body_2d.position.x) - int(character_p) > 5 
	or int(character_body_2d.position.x) - int(character_p) < -5):
		if character_body_2d.position.x > character_p:
			direction = -1
		else:
			direction = 1
		character_body_2d.velocity.x = direction * 100
		SignalManager.emit_signal("character_walk",direction)
		character_body_2d.move_and_slide()
	#如果相距小於20就判斷完成移動
	elif character_p != 0:
		character_p = 0
		SignalManager.emit_signal("character_stop")
		if study:
			SignalManager.emit_signal("start_studing")
		
func _input(event):
	#正在拖移
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		character_body_2d.position.x = DisplayServer.mouse_get_position().x + move_p
		collision_shape_2d.position = Vector2(-31.88,-217.878)
		SignalManager.emit_signal("character_drag")
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
	if not stop:
		character_p = randi_range(-399, 237)
		timer.wait_time = randi_range(5,15)

func _to_study():
	character_p = 157
	#moving = true
	study = true
	print("f")
	
func _on_study():
	character_p = 0
	study = false
	
func _on_studing():
	stop = true
	
func _end_study():
	stop = false
	
