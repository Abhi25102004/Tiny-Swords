extends CharacterBody2D

var CanPlay : bool = true
var CanMove : bool = false
var CanSlide : bool = false
var direction : Vector2 = Vector2(1,0)
var health : int = 100
var CoolDown : bool = true

var meatInstance : PackedScene = preload("res://scene and scripts/Collectables/meat.tscn")

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var damageCoolDown: Timer = $DamageCoolDown

func _ready() -> void:
	timer.start()

func _physics_process(_delta: float) -> void:
	if CanPlay:
		if direction.x < 0:
			animations.flip_h = true
		else:
			animations.flip_h = false
		animations.play("idle")
		if CanSlide:
			velocity =  direction * 50
			move_and_slide()
	
	if CanMove and Global.hasPlayerAttacked and CoolDown:
		CanPlay = false
		CoolDown = false
		damageCoolDown.start()
		animations.play("walk")
		health -= 10
		CoolDown = false
	
	if health <= 0:
		var meat = meatInstance.instantiate()
		meat.global_position = global_position
		get_parent().add_child(meat)
		queue_free()

func _on_detection_area_area_entered(_area: Area2D) -> void:
	CanMove = true

func _on_detection_area_area_exited(_area: Area2D) -> void:
	CanMove = false

func _on_animated_sprite_2d_animation_finished() -> void:
	CanPlay = true

func _on_timer_timeout() -> void:
	randomize()
	direction = Vector2(randi_range(-1,1),randi_range(-1,1)).normalized()
	CanSlide = !(CanSlide)
	timer.wait_time = randf_range(5,7)
	timer.start()

func _on_damage_cool_down_timeout() -> void:
	CoolDown = true
