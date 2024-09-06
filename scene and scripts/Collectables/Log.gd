extends Node2D

var maximum : float
var minimum : float
var CanMove : bool = true
var change : int  = 1
var direction : Vector2 = Vector2(0,0)
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	randomize()
	maximum = position.y + randf_range(1,5)
	minimum = position.y - randf_range(1,5)
	animations.play("spawn")

func _process(delta: float) -> void:
	if CanMove:
		position += Vector2(0,change) * 10 * delta
		if position.y >= maximum:
			change = -1
		elif position.y <= minimum:
			change = 1

func _on_signal_area_body_entered(_body: Node2D) -> void:
	queue_free()
