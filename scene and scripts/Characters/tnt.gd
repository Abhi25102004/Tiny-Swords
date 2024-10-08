extends CharacterBody2D

var CanPlay : bool = true
var CanAttack : bool = false
var CanWalk : bool = false
var TakeDamage : bool = false
var CoolDown : bool = true
var arrow_position : Marker2D
var BodyEntered : CharacterBody2D = null
var direction : Vector2 = Vector2(0,0)
var speed : int = 250
var health: int = 100
var dirctionOfArrow : Vector2 = Vector2(0,0)
var arrow_direction : bool = false
var power: int 
var arrowInstance : CharacterBody2D

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var HealthBar: TextureProgressBar = $Health
@onready var hurt_box: Area2D = $HurtBox
@onready var left: Marker2D = $Left
@onready var right: Marker2D = $Right
@onready var damageCoolDown: Timer = $DamageCoolDown

var BagOfGold : PackedScene = preload("res://scene and scripts/Collectables/coin_bag.tscn")
var arrow : PackedScene = preload("res://scene and scripts/Extras/dyanamite.tscn")

func _ready() -> void:
	power = randi_range(1,3)
	HealthBar.value = 100
	arrow_position = right 

func _physics_process(_delta: float) -> void:
	if CanPlay:
		if CanWalk:
			''' Part which takes care of motion '''
			direction = (BodyEntered.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide()
			
			''' Part which takes care of fliping animations based of direction '''
			if direction.x > 0:
				arrow_position = right
				arrow_direction = false
			elif direction.x < 0:
				arrow_position = left
				arrow_direction = true
				
		''' Part which takes care of walking and idle animation '''
		if direction != Vector2(0,0):
			animations.play("walk")
		else:
			animations.play("idle")
			
		''' Part which takes care attack '''
		if CanAttack and CoolDown:
			CanPlay = false
			CoolDown = false
			damageCoolDown.start()
			animations.play("attack")
	
	''' Part which takes care of damage taken'''
	if Global.hasPlayerAttacked and TakeDamage:
		HealthChecker()
		Global.hasPlayerAttacked = false
		
	
	''' Checking if health is decreased to zero then playing death animation if needed '''
	if health <= 0:
		CanAttack = false
		CanPlay = false
		health = -1
		HealthBar.visible = false
		animations.play("death")
		await get_tree().create_timer(1.0).timeout
		var bag = BagOfGold.instantiate()
		bag.global_position = global_position
		await get_tree().create_timer(0.6).timeout
		get_parent().add_child(bag)
		queue_free()
	
	''' To change direction based on the player position '''
	if BodyEntered != null:
		animations.flip_h = true if BodyEntered.global_position.x < global_position.x else false 
	
func _on_animated_sprite_2d_animation_finished() -> void:
	CanPlay = true
	if CanAttack:
		CreateArrow()

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	CanWalk = true
	BodyEntered = body

func _on_detection_area_body_exited(_body: CharacterBody2D) -> void:
	CanWalk = false
	direction = Vector2(0,0)
	BodyEntered = null

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.collision_layer == 2048:
		HealthChecker()
	else:
		TakeDamage = true

func _on_hitbox_area_exited(_area: Area2D) -> void:
	TakeDamage = false

func _on_damage_cool_down_timeout() -> void:
	CoolDown = true

func HealthChecker():
	health -= 10
	HealthBar.value = health

func _on_hurt_box_body_entered(body: CharacterBody2D) -> void:
	CanWalk = false
	CanAttack = true
	direction = Vector2(0,0)

func _on_hurt_box_body_exited(_body: Node2D) -> void:
	CanWalk = true
	CanAttack = false

func CreateArrow():
	var arrow_instance : CharacterBody2D = arrow.instantiate()
	arrow_instance.bodyPosition = BodyEntered.global_position
	arrow_instance.instancePosition = arrow_position.global_position
	arrow_instance.movement = arrow_direction
	arrow_instance.global_position = arrow_position.global_position
	get_parent().add_child(arrow_instance)
