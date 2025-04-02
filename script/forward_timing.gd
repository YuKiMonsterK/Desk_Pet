extends Control

var current_time: int = 0  # 當前剩餘時間（秒）
var is_working: bool = true  # 是否處於工作狀態
var is_running: bool = false  # 計時器是否在運行
var current_session: int = 0  # 當前工作週期計數

@onready var forward_timing: Control = $"."
@onready var panel_container: PanelContainer = $PanelContainer
@onready var timer_label: Label = $PanelContainer/MarginContainer/VBoxContainer/TimerLabel
@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/StartButton
@onready var reset_button: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResetButton
@onready var exit_button: Button = $exit_button
@onready var timer_node: Timer = $TimerNode

func _ready():
	SignalManager.connect("button_press", _on_button_press)
	panel_container.visible = false
	exit_button.visible = false
	
func _on_timer_timeout():
	current_time += 1
	update_display()

func update_display():
	# 將秒數轉換為 分:秒 格式
	var minutes = current_time / 60
	var seconds = current_time % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _on_start_button_pressed():
	is_running = !is_running
	start_button.text = "暫停" if is_running else "開始"
	if is_running:
		timer_node.start()
	else:
		timer_node.stop()

func _on_reset_button_pressed():
	is_running = false
	timer_node.stop()
	start_button.text = "開始"
	current_time = 0
	update_display()

func _on_timer_complete():
	is_running = false
	timer_node.stop()
	start_button.text = "開始"
	
	if is_working:
		current_session += 1
		is_working = false
		current_session = 0
	update_display() 

func _on_exit_button_pressed() -> void:
	panel_container.visible = false
	exit_button.visible = false
	SignalManager.emit_signal("exit_press", self.name)
	
func _on_button_press(node_name):
	if node_name == self.name + "_button":
		panel_container.visible = true
		exit_button.visible = true
