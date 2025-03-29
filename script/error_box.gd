extends PanelContainer
@onready var panel = $"."
@onready var message = $MarginContainer/VBoxContainer/Label2
@onready var button = $MarginContainer/VBoxContainer/Button
@onready var timer = $Timer

var new_style = StyleBoxTexture.new()
var style = "pink"
var loop = 0
func _ready():
	SignalManager.connect("error", _on_error_receive)
	panel.visible = false
	timer.wait_time = 0.1
	new_style.texture = load("res://assets/測試的圖片資源/pink.png")  # 替換成你的圖片資源
	panel.add_theme_stylebox_override("panel", new_style)
	
func _on_error_receive(mes):
	panel.visible = true
	message.text = mes
	timer.start()
	loop = 0
	
func _on_button_pressed():
	panel.visible = false

func _process(_delta):
	if timer.time_left == 0 and panel.visible :
		if style == "pink" and loop < 2:
			new_style.texture = load("res://assets/測試的圖片資源/box.png")
			timer.start()
			style = "blue"
			loop+=1
		elif loop < 2:
			new_style.texture = load("res://assets/測試的圖片資源/pink.png")
			timer.start()
			style = "pink"
		#panel.add_theme_stylebox_override("panel", new_style)
		timer.wait_time = 0.1
	
