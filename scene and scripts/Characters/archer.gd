extends CharacterBody2D

var CanPlay : bool = true
var CanAttack : bool = false
var GiveDamageToPlayer : bool = true
var arrow_position : Marker2D
var arrow_direction : bool = false
var direction : Vector2 = Vector2(0,0)
var speed : int = 300
var health: int = 100
var BodyEntered: CharacterBody2D = null
var arrow : PackedScene = preload("res://scene and scripts/Extras/arrow.tscn")

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var damageCoolDown: Timer = $DamageCoolDown
@onready var HealthBar: TextureProgressBar = $Health
@onready var left: Marker2D = $Left
@onready var right: Marker2D = $Right

func _ready() -> void:
	HealthBar.value = 100
	arrow_position = right 

func _physics_process(_delta: float) -> void:
	if CanPlay:
		''' Part which takes care of motion '''
		direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
		move_and_slide()
		
		''' Part which takes care of fliping animations based of direction '''
		if direction.x > 0:
			animations.flip_h = false
			arrow_position = right
			arrow_direction = false
		elif direction.x < 0:
			animations.flip_h = true
			arrow_position = left
			arrow_direction = true
			
		''' Part which takes care of walking and idle animation '''
		if direction != Vector2(0,0):
			animations.play("walk")
		else:
			animations.play("idle")
			
		''' Part which takes care attack '''
		if Input.is_action_pressed("attack"):
			CanPlay = false
			Global.hasPlayerAttacked = true
			animations.play("attack")

func _on_animated_sprite_2d_animation_finished() -> void:
	CanPlay = true
	if Global.hasPlayerAttacked:
		CreateArrow()
		Global.hasPlayerAttacked = false

func _on_damage_cool_down_timeout() -> void:
	''' Part which check damage taken '''
	if GiveDamageToPlayer:
		randomize()
		HealthChecker()
	damageCoolDown.start()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	GiveDamageToPlayer = true
	damageCoolDown.start()

func _on_hitbox_area_exited(_area: Area2D) -> void:
	GiveDamageToPlayer = false
	damageCoolDown.stop()

func CreateArrow():
	var arrow_instance : CharacterBody2D = arrow.instantiate()
	arrow_instance.direction.x = -1 if arrow_position == left else 1 
	arrow_instance.movement = arrow_direction
	arrow_instance.global_position = arrow_position.global_position
	get_parent().add_child(arrow_instance)

func HealthChecker():
	health -= randi_range(1,5)
	HealthBar.value = health
