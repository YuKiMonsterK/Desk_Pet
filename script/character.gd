extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay

@export var state = "idle"

func _ready() -> void:
	SignalManager.connect("character_move", _on_move)
	SignalManager.connect("character_stop", _stop)
	SignalManager.connect("character_walk", _walk)
	animated_sprite_2d.animation = "default"

func _process(delta: float) -> void:
	
	if animated_sprite_2d.animation == "default":
		animated_sprite_2d.scale = Vector2(0.511,0.511)
	elif animated_sprite_2d.animation == "move":
		animated_sprite_2d.scale = Vector2(0.306,0.306)
	elif  animated_sprite_2d.animation == "walk":
		animated_sprite_2d.scale = Vector2(0.34,0.34)
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play()
	if left_ray.is_colliding():
		SignalManager.emit_signal("colliding","left")
	elif right_ray.is_colliding():
		SignalManager.emit_signal("colliding","right")
		
func _on_move():
	animated_sprite_2d.animation = "move"
	state = "move"
	
func _stop():
	animated_sprite_2d.animation = "default"
	state = "idle"
	
func _walk(d):
	if d == 1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	animated_sprite_2d.animation = "walk"
