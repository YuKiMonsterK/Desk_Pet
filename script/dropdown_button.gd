extends Control

# 导出变量
@export var options: Array = ["选项1", "选项2", "选项3"]  # 下拉选项列表
@export var button_text: String = "下拉選單"  # 按钮文本

# 内部变量
var is_open = false  # 下拉菜单是否打开
var selected_option = 0  # 当前选中的选项索引

# 节点引用
@onready var main_button: Button = $MainButton #主按鈕
@onready var options_container = $OptionsContainer  # 选项容器

# 初始化函数
func _ready():
	main_button.text = button_text  # 设置按钮文本
	update_options()  # 更新选项列表
	
	# 连接主按钮信号
	#main_button.pressed.connect(_on_main_button_pressed)

# 更新选项列表函数
func update_options():
	# 清除现有选项
	for child in options_container.get_children():
		child.queue_free()
	
	# 添加新选项
	for i in range(options.size()):
		var button = Button.new()
		button.text = options[i]
		button.custom_minimum_size = Vector2(100, 30)
		button.pressed.connect(_on_option_selected.bind(i))
		options_container.add_child(button)
	
	# 初始时隐藏选项
	options_container.visible = false

# 主按钮点击事件

func _on_main_button_pressed():
	is_open = !is_open
	options_container.visible = is_open

# 选项选择事件
func _on_option_selected(index: int):
	selected_option = index
	main_button.text = options[index]
	is_open = false
	options_container.visible = false 
