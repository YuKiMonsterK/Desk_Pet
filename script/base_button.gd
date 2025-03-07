extends Button


func _ready():
	pass
	
func _on_button_down():
	SignalManager.emit_signal("button_press", self.name)
