extends CharacterBody2D

var direction : Vector2 = Vector2(0,0)
var movement : bool = false
var speed : float = 650

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var appered: Timer = $Appered

func _ready() -> void:
	sprite_2d.flip_h = movement
	appered.start()
	
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_appered_timeout() -> void:
	queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
