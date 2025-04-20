extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var book: AnimatedSprite2D = $Book

@export var state = "idle"

func _ready() -> void:
	SignalManager.connect("character_drag", _on_drag)
	SignalManager.connect("character_stop", _stop)
	SignalManager.connect("character_walk", _walk)
	SignalManager.connect("start_studing", _on_studing)
	animated_sprite_2d.animation = "default"
	book.visible = false
	
func _process(delta: float) -> void:
	
	if animated_sprite_2d.animation == "default":
		animated_sprite_2d.scale = Vector2(0.511,0.511)
	elif animated_sprite_2d.animation == "drag":
		animated_sprite_2d.scale = Vector2(0.306,0.306)
	elif  animated_sprite_2d.animation == "walk":
		animated_sprite_2d.scale = Vector2(0.34,0.34)
	elif  animated_sprite_2d.animation == "studing":
		animated_sprite_2d.scale = Vector2(0.101,0.101)
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play()
	if left_ray.is_colliding():
		SignalManager.emit_signal("colliding","left")
	elif right_ray.is_colliding():
		SignalManager.emit_signal("colliding","right")
		
func _on_drag():
	animated_sprite_2d.animation = "drag"
	state = "drag"
		
func _stop():
	if not book.visible:
		animated_sprite_2d.animation = "default"
		state = "idle"
	
func _walk(d):
	if d == 1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	if not book.visible:
		animated_sprite_2d.animation = "walk"
	
func  _on_studing():
	book.visible = true
	animated_sprite_2d.animation = "studing"
	book.play()
	
