extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	SignalManager.connect("character_move", _on_move)
	SignalManager.connect("character_stop", _stop)
	animated_sprite_2d.animation = "default"

func _process(delta: float) -> void:
	if animated_sprite_2d.animation == "default":
		animated_sprite_2d.scale = Vector2(0.511,0.511)
	elif animated_sprite_2d.animation == "move":
		animated_sprite_2d.scale = Vector2(0.306,0.306)
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play()
	
func _on_move():
	animated_sprite_2d.animation = "move"

func _stop():
	animated_sprite_2d.animation = "default"
