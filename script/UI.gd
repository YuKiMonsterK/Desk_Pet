extends Node2D

@onready var accept = $"accept"
@onready var camera_2d = $"Camera2D"
@onready var tomato = $Tomato

var move_edge = false
var move_p = Vector2i()
var accept_sec = 0
var menu_area = false

#為之後的房間模式做準備
var room_mode = true

# 當開始時執行
func _ready():
	var screen_id = DisplayServer.window_get_current_screen()  # 取得目前視窗所在的螢幕 ID
	var screen_size = DisplayServer.screen_get_size(screen_id)  # 取得該螢幕解析度
	var screen_position = DisplayServer.screen_get_position(screen_id)  # 取得該螢幕的起始座標
	var window_size = get_window().size  # 取得視窗大小
	# 計算該螢幕右下角的正確位置
	var target_position = Vector2i(
		screen_position.x + screen_size.x - window_size.x,  # 螢幕起始座標 + 螢幕寬度 - 視窗寬度
		screen_position.y + screen_size.y - window_size.y   # 螢幕起始座標 + 螢幕高度 - 視窗高度
	)
	# 設定視窗位置
	get_window().position = target_position
	SignalManager.connect("room_mode", _on_room_mode)
# 每幀執行
func _process(_delta):
	#使滑鼠碰撞框每幀都在滑鼠上
	accept.position = Vector2i(get_global_mouse_position())
	#if Input.is_action_pressed("accept"):
		#accept_sec += 1
	#else:
		#accept_sec = 0
	if not Input.is_action_pressed("accept") and move_edge:
			move_edge = false
	if room_mode:
		tomato.size.x = 331
		tomato.size.y = 124
		tomato.position.x = 244
		tomato.position.y = 21
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

func _on_room_mode():
	room_mode = true
