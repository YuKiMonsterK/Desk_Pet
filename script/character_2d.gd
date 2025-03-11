
extends Sprite2D

var is_dragging = false
var actions = ["摸頭", "拖移", "讀書", "吃東西", "回房間", "擦玻璃", "爬"]
var current_action = ""

func _ready():
	current_action = "站立"
	print("角色初始化完成，當前動作：", current_action)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if get_rect().has_point(to_local(event.position)):
				is_dragging = true
				current_action = "拖移"
				print("角色正在被拖動")
		elif not event.pressed:
			is_dragging = false
			current_action = "站立"
	
	if event is InputEventMouseMotion and is_dragging:
		position += event.relative

func do_action(action_name):
	if action_name in actions:
		current_action = action_name
		match action_name:
			"摸頭":
				print("角色摸了摸自己的頭")
			"讀書":
				print("角色開始讀書")
			"吃東西":
				print("角色在吃東西")
			"回房間":
				print("角色回到房間")
				position = Vector2(100, 100)  # 角色移動回預設位置
			"擦玻璃":
				print("角色正在擦玻璃")
			"爬":
				print("角色開始爬行")
				position.y += 10  # 爬行時向下移動一點
		print("當前動作：", current_action)

