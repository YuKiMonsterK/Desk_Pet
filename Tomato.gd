extends "res://script/menu_button.gd"
@onready var tomato = $"."
@onready var icon_container = $PanelContainer
@onready var collision_shape_2d = $move/CollisionShape2D
@onready var move = $move
@onready var confirm = $PanelContainer/MarginContainer/VBoxContainer/confirm
@onready var fous = $PanelContainer/TimeSetting/GridContainer/LineEdit
@onready var rest = $PanelContainer/TimeSetting/GridContainer/LineEdit2
@onready var loop = $PanelContainer/TimeSetting/GridContainer/LineEdit3

var fous_t = 20
var rest_t = 5
var loop_t = 4
var move_p = Vector2()
var move_edge = false
func _ready():
	print(room_mode)
	tomato.self_modulate = Color(1,1,1,1)
	panel_container.visible = false
	SignalManager.connect("button_press", _on_button_press)
	if not room_mode:
		tomato.icon = load("res://assets/測試的圖片資源/Tomato.jpg")
	# 計算該螢幕右下角的正確位置
	#icon_container.position = Vector2i(
		#window_size.x - 4100,
		#window_size.y - 2000 
	#)
	collision_shape_2d.visible = false
func _process(_delta):
	if icon_container.visible:
		collision_shape_2d.visible = true
		collision_shape_2d.position.x = icon_container.position.x +149 
		collision_shape_2d.position.y = icon_container.position.y +37
	else:
		collision_shape_2d.visible = false
	if not Input.is_action_pressed("accept") and move_edge:
		move_edge = false
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
		fous_t = fous.text
		rest_t = rest.text
		loop_t = loop.text
	else:
		SignalManager.emit_signal("error","請勿輸入文字")
