extends Node

# 匯出變數
@export var work_time: int = 25  # 工作時間（分鐘）
@export var break_time: int = 5  # 休息時間（分鐘）
@export var long_break_time: int = 15  # 長休息時間（分鐘）
@export var sessions_before_long_break: int = 4  # 多少個工作週期後進行長休息

var current_time: int = 0  # 當前剩餘時間（秒）
var is_working: bool = true  # 是否處於工作狀態
var is_running: bool = false  # 計時器是否在運行
var current_session: int = 0  # 當前工作週期計數

@onready var timer_node = $tomato/TimerNode
@onready var timer_label = $tomato/PanelContainer/MarginContainer/VBoxContainer/TimerLabel
@onready var start_button = $tomato/PanelContainer/MarginContainer/VBoxContainer/StartButton
@onready var reset_button = $tomato/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResetButton
@onready var settings_button = $tomato/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SettingsButton
@onready var settings_panel = $tomato/SettingsPanel
@onready var work_time_spin = $tomato/SettingsPanel/MarginContainer/VBoxContainer/WorkTimeSpinBox
@onready var break_time_spin = $tomato/SettingsPanel/MarginContainer/VBoxContainer/BreakTimeSpinBox
@onready var long_break_time_spin = $tomato/SettingsPanel/MarginContainer/VBoxContainer/LongBreakTimeSpinBox
@onready var sessions_spin = $tomato/SettingsPanel/MarginContainer/VBoxContainer/SessionsSpinBox
@onready var save_button = $tomato/SettingsPanel/MarginContainer/VBoxContainer/SaveButton
@onready var panel_container: PanelContainer = $tomato/PanelContainer
@onready var exit_button: Button = $tomato/exit_button
@onready var label: Label = $tomato/PanelContainer/MarginContainer/VBoxContainer/Label
@onready var move_area: Control = $"move_area"

func _ready():
	# 初始化時間為工作時間（分鐘轉換為秒）
	current_time = work_time * 60
	update_display()
	settings_panel.visible = false
	SignalManager.connect("button_press", _on_button_press)
	# 初始化設定面板的值
	work_time_spin.value = work_time
	break_time_spin.value = break_time
	long_break_time_spin.value = long_break_time
	sessions_spin.value = sessions_before_long_break
	panel_container.visible = false
	exit_button.visible = false
	label.text = "番茄鐘"
	
func _on_timer_timeout():
	current_time -= 1
	update_display()
	if current_time <= 0:
		_on_timer_complete()

func update_display():
	# 將秒數轉換為分:秒格式
	var minutes = current_time / 60
	var seconds = current_time % 60
	timer_label.text = "%02d:%02d (%02d/%02d)" % [minutes, seconds , current_session, sessions_spin.value]

func _on_start_button_pressed():
	is_running = !is_running
	start_button.text = "暫停" if is_running else "開始"
	if is_running:
		label.text = "已暫停"
		timer_node.start()
	else:
		timer_node.stop()
	if is_working:
		label.text = "讀書中..."
	else:
		label.text = "休息中..."
	if current_session == 0:
		current_session = 1
	if start_button.text == "暫停":
		SignalManager.emit_signal("to_study")
	elif start_button.text == "開始":
		SignalManager.emit_signal("stop_study")

func _on_reset_button_pressed():
	is_running = false
	timer_node.stop()
	start_button.text = "開始"
	label.text = "番茄鐘"
	current_time = work_time * 60  # 重置為工作時間（分鐘轉換為秒）
	current_session = 0
	update_display()
	SignalManager.emit_signal("end_study")

func _on_settings_button_pressed():
	settings_panel.visible = !settings_panel.visible
	exit_button.visible = false
	panel_container.visible = false
	
func _on_save_button_pressed():
	# 更新所有時間設定
	work_time = int(work_time_spin.value)
	break_time = int(break_time_spin.value)
	long_break_time = int(long_break_time_spin.value)
	sessions_before_long_break = int(sessions_spin.value)
	exit_button.visible = true
	panel_container.visible = true
	# 更新當前時間（分鐘轉換為秒）
	if is_working:
		current_time = work_time * 60
	else:
		current_time = break_time * 60
	update_display()
	settings_panel.visible = false

func _on_timer_complete():
	is_running = false
	timer_node.stop()
	start_button.text = "開始"
	if is_working:
		label.text = "點擊開始來休息"
		is_working = false
		if current_session >= sessions_before_long_break:
			current_time = long_break_time * 60  # 使用長休息時間（分鐘轉換為秒）
			current_session = 0
		else:
			current_time = break_time * 60  # 使用休息時間（分鐘轉換為秒）
	else:
		current_session += 1
		label.text = "讀書中..."
		is_working = true
		current_time = work_time * 60  # 使用工作時間（分鐘轉換為秒）
	update_display() 

func _on_exit_button_pressed() -> void:
	panel_container.visible = false
	settings_panel.visible = false
	exit_button.visible = false
	SignalManager.emit_signal("exit_press", self.name)

func _on_button_press(node_name):
	if node_name == self.name + "_button":
		panel_container.visible = true
		exit_button.visible = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
