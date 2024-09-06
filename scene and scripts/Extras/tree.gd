extends StaticBody2D

var CanPlay : bool = true
var CanMove : bool = false
var CoolDown : bool = true

var health : int = 100

var logInstance : PackedScene = preload("res://scene and scripts/Collectables/log.tscn")

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var damageCoolDown: Timer = $DamageCoolDown

func _physics_process(_delta: float) -> void:
	if CanPlay:
		animations.play("Normal")
	
	if CanMove and Global.hasPlayerAttacked and CoolDown:
		CanPlay = false
		CoolDown = false
		damageCoolDown.start()
		animations.play("Cutting")
		health -= 10
	
	if health <= 0:
		var Treelog = logInstance.instantiate()
		Treelog.global_position = global_position
		get_parent().add_child(Treelog)
		queue_free()

func _on_detection_area_area_entered(_area: Area2D) -> void:
	CanMove = true

func _on_detection_area_area_exited(_area: Area2D) -> void:
	CanMove = false

func _on_animated_sprite_2d_animation_finished() -> void:
	CanPlay = true


func _on_damage_cool_down_timeout() -> void:
	CoolDown = true
