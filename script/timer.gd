extends Node

@export var work_time: int = 25  # 工作时间（分钟）
@export var break_time: int = 5  # 休息时间（分钟）
@export var long_break_time: int = 15  # 长休息时间（分钟）
@export var sessions_before_long_break: int = 4  # 多少个工作周期后进行长休息

var current_time: int = 0  # 当前剩余时间（秒）
var is_working: bool = true  # 是否处于工作状态
var is_running: bool = false  # 计时器是否在运行
var current_session: int = 0  # 当前工作周期计数

@onready var timer_node = $TimerNode
@onready var timer_label = $PanelContainer/MarginContainer/VBoxContainer/TimerLabel
@onready var start_button = $PanelContainer/MarginContainer/VBoxContainer/StartButton
@onready var reset_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResetButton
@onready var settings_button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SettingsButton
@onready var settings_panel = $SettingsPanel
@onready var work_time_spin = $SettingsPanel/VBoxContainer/WorkTimeSpinBox
@onready var break_time_spin = $SettingsPanel/VBoxContainer/BreakTimeSpinBox
@onready var long_break_time_spin = $SettingsPanel/VBoxContainer/LongBreakTimeSpinBox
@onready var sessions_spin = $SettingsPanel/VBoxContainer/SessionsSpinBox
@onready var save_button = $SettingsPanel/VBoxContainer/SaveButton
@onready var panel_container: PanelContainer = $PanelContainer
@onready var exit_button: Button = $exit_button

func _ready():
	# 初始化时间为工作时间（分钟转换为秒）
	current_time = work_time * 60
	update_display()
	settings_panel.visible = false
	SignalManager.connect("button_press", _on_button_press)
	# 初始化设置面板的值
	work_time_spin.value = work_time
	break_time_spin.value = break_time
	long_break_time_spin.value = long_break_time
	sessions_spin.value = sessions_before_long_break
	panel_container.visible = false
	exit_button.visible = false
	
func _on_timer_timeout():
	current_time -= 1
	update_display()
	
	if current_time <= 0:
		_on_timer_complete()

func update_display():
	# 将秒数转换为分:秒格式
	var minutes = current_time / 60
	var seconds = current_time % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _on_start_button_pressed():
	is_running = !is_running
	start_button.text = "暂停" if is_running else "开始"
	if is_running:
		timer_node.start()
	else:
		timer_node.stop()

func _on_reset_button_pressed():
	is_running = false
	timer_node.stop()
	start_button.text = "开始"
	if is_working:
		current_time = work_time * 60  # 重置为工作时间（分钟转换为秒）
	else:
		current_time = break_time * 60  # 重置为休息时间（分钟转换为秒）
	update_display()

func _on_settings_button_pressed():
	settings_panel.visible = !settings_panel.visible

func _on_save_button_pressed():
	# 更新所有时间设置
	work_time = int(work_time_spin.value)
	break_time = int(break_time_spin.value)
	long_break_time = int(long_break_time_spin.value)
	sessions_before_long_break = int(sessions_spin.value)
	
	# 更新当前时间（分钟转换为秒）
	if is_working:
		current_time = work_time * 60
	else:
		current_time = break_time * 60
	
	update_display()
	settings_panel.visible = false

func _on_timer_complete():
	is_running = false
	timer_node.stop()
	start_button.text = "开始"
	
	if is_working:
		current_session += 1
		is_working = false
		if current_session >= sessions_before_long_break:
			current_time = long_break_time * 60  # 使用长休息时间（分钟转换为秒）
			current_session = 0
		else:
			current_time = break_time * 60  # 使用休息时间（分钟转换为秒）
	else:
		is_working = true
		current_time = work_time * 60  # 使用工作时间（分钟转换为秒）
	
	update_display() 

func _on_exit_button_pressed() -> void:
	panel_container.visible = false
	settings_panel = false
	exit_button.visible = false

func _on_button_press(node_name):
	if node_name == self.name + "_button":
		panel_container.visible = true
		exit_button.visible = true
