extends Node2D

@onready var game_window: Node2D = $game_window
@onready var background: Sprite2D = $"game_window/room-1"
@onready var character_body_2d: CharacterBody2D = $game_window/CharacterBody2D
@onready var collision_shape_2d: CollisionShape2D = $game_window/CharacterBody2D/move/CollisionShape2D
@onready var timer: Timer = $Timer
@onready var switch_room: Sprite2D = $game_window/SwitchRoom
@onready var ui: Node2D = $"."

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
var in_move_area = false
func _ready():
	#初始化
	collision_shape_2d.position = Vector2(-36.04,-197.078)
	SignalManager.connect("room_mode", _room_mode) #連接信號
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
	switch_room.visible = false
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
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	#如果有目標位置且相距大於20就向那裡移動
	if character_p != 0 and (int(character_body_2d.position.x) - int(character_p) > 5 
	or int(character_body_2d.position.x) - int(character_p) < -5):
		if character_body_2d.position.x > character_p:
			direction = -1
		else:
			direction = 1
		character_body_2d.velocity.x = direction * 200
		SignalManager.emit_signal("character_walk",direction)
		character_body_2d.move_and_slide()
		
	#如果相距小於20就判斷完成移動
	elif character_p != 0:
		character_p = 0
		SignalManager.emit_signal("character_stop")
		if study:
			SignalManager.emit_signal("start_studing")
	
	if character_body_2d.position.y < -115 and not move_edge:
		character_body_2d.velocity.y = 200
		character_p = 0
		character_body_2d.move_and_slide()
	elif character_body_2d.position.y >= -114:
		character_body_2d.velocity.y = 0
		character_body_2d.position.y = -114
	#模式切換提示
	if character_body_2d.position.y < -152:
		switch_room.self_modulate = Color8(255,255,255,-1*character_body_2d.position.y)
		if character_body_2d.position.y <= -300:
			_room_mode()
		switch_room.visible = true
	elif room_mode:
		switch_room.visible = false
	
func _input(event):
	#正在拖移
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		character_body_2d.position = Vector2i(DisplayServer.mouse_get_position()) + move_p
		collision_shape_2d.position = Vector2(-31.88,-217.878)
		SignalManager.emit_signal("character_drag")
		if character_body_2d.position.y > -114:
			character_body_2d.position.y = -114
		moving = true
		
		
		#hhflrshfelsfh
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)

		timer.stop()
	elif Input.is_action_pressed("accept") and not move_edge and event is InputEventMouseMotion:
		#沒在拖移，但正進行可能的活動（按下左鍵並拖移）
		move_p = Vector2i(character_body_2d.position) - DisplayServer.mouse_get_position()
	#正在摸頭，缺點是拖移時會有一段摸頭的時期
	if Input.is_action_pressed("accept") and in_move_area and event is InputEventMouseMotion and not move_edge:
		SignalManager.emit_signal("character_caress","y")
		timer.stop()
	elif in_move_area:
		SignalManager.emit_signal("character_caress","n")
		
func _on_move_mouse_entered() -> void:
	in_move_area = true
	
func _on_move_mouse_exited():
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
	study = true
	
func _on_study():
	character_p = 0
	study = false
	
func _on_studing():
	stop = true
	
func _end_study():
	stop = false
	
func _room_mode():
	var no_back = load("res://scene/no_back_ui.tscn").instantiate()
	no_back.p = Vector2(character_body_2d.position.x,character_body_2d.position.y)
	get_tree().root.add_child(no_back)  # 把新的場景加到畫面上
	ui.queue_free()  # 把自己刪掉
