extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var book: AnimatedSprite2D = $Book
@onready var character_body_2d: CharacterBody2D = $"."

var back = false
var back_p = 0

func _ready() -> void:
	SignalManager.connect("character_drag", _on_drag)
	SignalManager.connect("character_stop", _stop)
	SignalManager.connect("character_walk", _walk)
	SignalManager.connect("start_studing", _on_studing)
	SignalManager.connect("stop_study", _stop_study)
	SignalManager.connect("end_study", _end_study)
	SignalManager.connect("character_caress", _caress)
	SignalManager.connect("back_home", _back_home)
	animated_sprite_2d.animation = "default"
	book.visible = false
	
func _process(delta: float) -> void:
	
	if animated_sprite_2d.animation == "default" and not back:
		animated_sprite_2d.scale = Vector2(0.511,0.511)
	elif animated_sprite_2d.animation == "drag":
		animated_sprite_2d.scale = Vector2(0.256,0.256)
	elif  animated_sprite_2d.animation == "walk":
		animated_sprite_2d.scale = Vector2(0.34,0.34)
	elif  animated_sprite_2d.animation == "studing":
		animated_sprite_2d.scale = Vector2(0.101,0.101)
	elif  animated_sprite_2d.animation == "caress":
		animated_sprite_2d.scale = Vector2(0.9,0.9)
		
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play()
	if left_ray.is_colliding():
		SignalManager.emit_signal("colliding","left")
	elif right_ray.is_colliding():
		SignalManager.emit_signal("colliding","right")
	if character_body_2d.scale.y == 3:
		SignalManager.emit_signal("room_mode")
	
func _on_drag():
	animated_sprite_2d.animation = "drag"
		
func _stop():
	if not book.visible:
		animated_sprite_2d.animation = "default"
	
func _walk(d):
	if d == 1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	if not book.visible:
		animated_sprite_2d.animation = "walk"
	
func _caress(mode):
	if mode == "y" and animated_sprite_2d.animation != "drag":
		animated_sprite_2d.animation = "caress"
	elif mode == "n" and animated_sprite_2d.animation == "caress":
		animated_sprite_2d.animation = "default"
func  _on_studing():
	book.visible = true
	animated_sprite_2d.animation = "studing"
	book.play()
	
func  _stop_study():
	book.stop()
	book.frame = 1
	
func  _end_study():
	book.visible = false
	animated_sprite_2d.animation = "default"

func _back_home():
	back = true
	animated_sprite_2d.animation = "default"
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale:y", 3.0, 0.5)
	back = false
