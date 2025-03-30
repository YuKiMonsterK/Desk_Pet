extends Control

func _ready():
	# 讓 Control 節點的所有點擊直接穿透
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
