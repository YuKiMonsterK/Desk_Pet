extends Sprite2D
@onready var accept = $"../accept"
@onready var books = $"../books"
#當左鍵按到功能鍵時，press為true
var move_area = false
var move = Vector2i()
# 當開始時執行
func _ready():
	pass


# 每幀執行
func _process(_delta):
	accept.position = Vector2i(get_global_mouse_position())
	
# 有輸入時執行
func _input(_event):
	# 如果按下左鍵，且在上方移動區
	if Input.is_action_pressed("accept") and move_area:
		#更改遊戲窗口至左鍵位置
		get_window().position = DisplayServer.mouse_get_position() + move


func _on_accept_area_entered(_area):
	pass

# 如果進入上方移動區
func _on_move_area_entered(area):
	move_area = true
	move = get_window().position - DisplayServer.mouse_get_position()
# 如果離開上方移動區
func _on_move_area_exited(area):
	move_area = false
