extends CharacterBody2D

var direction : Vector2 
var movement : bool = false
var speed : float = 650
var splitPoint : Vector2
var bodyPosition : Vector2
var instancePosition : Vector2

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var appered: Timer = $Appered

func _ready() -> void:
	direction = (bodyPosition - instancePosition).normalized()
	sprite_2d.flip_h = movement
	appered.start()

func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

func _on_appered_timeout() -> void:
	queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()

