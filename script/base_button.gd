extends Button

	
func _on_button_down():
	#統一發送至訊號管理腳本
	SignalManager.emit_signal("button_press", self.name)
