extends Button


func _ready():
	pass
	
func _on_button_down():
	print(self .name)
	#統一發送至訊號管理腳本
	SignalManager.emit_signal("button_press", self.name)
