extends Control

# 匯出變數
@export var options: Array = ["選項1", "選項2", "選項3"]  # 下拉選單選項列表
@export var button_text: String = "下拉選單"  # 按鈕文本

# 內部變數
var is_open = false  # 下拉選單是否開啟
var selected_option = 0  # 當前選擇的選項索引

# 節點引用
@onready var main_button: Button = $MainButton # 主按鈕
@onready var options_container = $OptionsContainer  # 選項容器

# 初始化函式
func _ready():
	main_button.text = button_text  # 設定按鈕文本
	update_options()  # 更新選項列表
	

# 更新選項列表函式
func update_options():
	# 清除現有選項
	for child in options_container.get_children():
		child.queue_free()
	
	# 添加新選項
	for i in range(options.size()):
		var button = Button.new()
		button.text = options[i]
		button.custom_minimum_size = Vector2(100, 30)
		button.pressed.connect(_on_option_selected.bind(i))
		options_container.add_child(button)
	
	# 初始時隱藏選項
	options_container.visible = false

# 主按鈕點擊事件
func _on_main_button_pressed():
	is_open = !is_open
	options_container.visible = is_open

# 選項選擇事件
func _on_option_selected(index: int):
	selected_option = index
	main_button.text = options[index]
	is_open = false
	options_container.visible = false 
