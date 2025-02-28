extends Node2D

@onready var accept = $"accept"
@onready var tomato = $"tomato"
@onready var camera_2d = $"Camera2D"

var move_area = false
var move_p = Vector2i()
var tomato_area = false

# 當開始時執行
func _ready():
	camera_2d.position.x = 0
	camera_2d.position.y = 0
	camera_2d.set_zoom(Vector2(1, 1))
	
# 每幀執行
func _process(_delta):
	accept.position = Vector2i(get_global_mouse_position())
	
# 有輸入時執行
func _input(event):
	
	# 如果按下左鍵並移動，且在上方移動區
	if Input.is_action_pressed("accept") and move_area and event is InputEventMouseMotion:
		#更改遊戲窗口至左鍵位置
		get_window().position = DisplayServer.mouse_get_position() + move_p
	# 如果只按下左鍵，且在上方移動區
	elif Input.is_action_pressed("accept") and move_area:
		move_p = get_window().position - DisplayServer.mouse_get_position()
	
	if Input.is_action_pressed("accept")and tomato_area:
		print("tomato")
		
# 如果進入上方移動區
func _on_move_area_entered(_area):
	move_area = true
	
# 如果離開上方移動區
func _on_move_area_exited(_area):
	move_area = false

func _on_tomato_area_entered(_area):
	tomato_area = true
	
func _on_tomato_area_exited(_area):
	tomato_area = false
