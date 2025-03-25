extends "res://script/menu_button.gd"

@onready var tomato = $"."
@onready var icon_container = $PanelContainer
@onready var collision_shape_2d = $move/CollisionShape2D
@onready var move = $move
@onready var confirm = $PanelContainer/TimeSetting/VBoxContainer/confirm
@onready var fous = $PanelContainer/TimeSetting/VBoxContainer/GridContainer/LineEdit
@onready var rest = $PanelContainer/TimeSetting/VBoxContainer/GridContainer/LineEdit2
@onready var loop = $PanelContainer/TimeSetting/VBoxContainer/GridContainer/LineEdit3
@onready var timer = $Timer
@onready var start_tomato = $PanelContainer/start_tomato
@onready var time_setting = $PanelContainer/TimeSetting
@onready var now_mode = $PanelContainer/start_tomato/VBoxContainer/now_mode
@onready var left_time = $PanelContainer/start_tomato/VBoxContainer/left_time
@onready var loop_left = $PanelContainer/start_tomato/VBoxContainer/loop_left


var fous_t = 20
var rest_t = 5
var loop_t = 4
var move_p = Vector2()
var move_edge = false
var loop_cur = 0
var current = "讀書"

func _ready():
	print(room_mode)
	panel_container.self_modulate = Color(1,1,1,1)
	SignalManager.connect("button_press", _on_button_press)
	panel_container.visible = false
	if not room_mode:
		tomato.icon = load("res://assets/測試的圖片資源/Tomato.jpg")
	collision_shape_2d.visible = false
	start_tomato.visible = false
	time_setting.visible = true
	
func _process(_delta):
	if icon_container.visible:
		collision_shape_2d.visible = true
		collision_shape_2d.position.x = icon_container.position.x +149 
		collision_shape_2d.position.y = icon_container.position.y +37
	else:
		collision_shape_2d.visible = false
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
	if timer.time_left > 0:
		left_time.text = "剩餘時間："+ str(ceil(timer.time_left))
		now_mode.text = current
		loop_left.text = "番茄次數：" + str(loop_cur/2) + "/" + str(loop_t)
func _on_button_press(node_name):
	print("self = ",self.name," node = ",node_name)
	if node_name == self.name:
		panel_container.visible = true
		
func _input(event):
	# 如果按下左鍵並移動，且在移動區邊緣
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		icon_container.position = Vector2(DisplayServer.mouse_get_position()) + move_p
	elif Input.is_action_pressed("accept") and not move_edge:
		move_p = icon_container.position - Vector2(DisplayServer.mouse_get_position())
func _on_mouse_entered():
	if not room_mode:
		tomato.self_modulate = Color(0.44,0.44,0.44,1)

func _on_mouse_exited():
	tomato.self_modulate = Color(1,1,1,1)

func _on_move_area_exited(_area):
	move_edge = true

func _on_confirm_button_down():
	print("time")
	if fous.text.is_valid_int() and rest.text.is_valid_int() and loop.text.is_valid_int():
		fous_t = int(fous.text)
		rest_t = int(rest.text)
		loop_t = int(loop.text)
		timer.wait_time = int(fous_t)
		time_setting.visible = false
		start_tomato.visible = true
		timer.start()
	else:
		SignalManager.emit_signal("error","請勿輸入文字")

func _on_timer_timeout():
	if loop_cur <= loop_t*2 -1:
		if current == "讀書":
			timer.wait_time = rest_t
			current = "休息"
		else:
			timer.wait_time = fous_t
			current = "讀書"
		loop_cur += 1
		timer.start()
	else:
		print("end")
		loop_cur = 0
		timer.stop()
