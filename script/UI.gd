extends Node2D

@onready var accept = $"accept"
@onready var camera_2d = $"Camera2D"

var move_edge = false
var move_p = Vector2i()
var accept_sec = 0
var test_area = false
signal interact

# 當開始時執行
func _ready():
	camera_2d.position.x = 0
	camera_2d.position.y = 0
	camera_2d.set_zoom(Vector2(1, 1))
# 每幀執行
func _process(_delta):
	#使滑鼠碰撞框每幀都在滑鼠上
	accept.position = Vector2i(get_global_mouse_position())
	#if Input.is_action_pressed("accept"):
		#accept_sec += 1
	#else:
		#accept_sec = 0
	if Input.is_action_pressed("accept") and test_area:
		emit_signal("interact")
		test_area = false
	if not Input.is_action_pressed("accept") and move_edge:
			move_edge = false
# 有輸入時執行
func _input(event):
	# 如果按下左鍵並移動，且在移動區邊緣
	if Input.is_action_pressed("accept") and move_edge and event is InputEventMouseMotion:
		#更改遊戲窗口至左鍵位置
		get_window().position = DisplayServer.mouse_get_position() + move_p
	# 如果只按下左鍵，且在移動區邊緣
	# 此處缺點：平常按確定也會計算move_
	elif Input.is_action_pressed("accept") and not move_edge:
		move_p = get_window().position - DisplayServer.mouse_get_position()
	
# 如果到移動區的邊緣
func _on_move_mouse_exited():
	move_edge = true
	
func _on_test_button_area_entered(_area):
	test_area = true
func _on_test_button_area_exited(area):
	test_area = false
