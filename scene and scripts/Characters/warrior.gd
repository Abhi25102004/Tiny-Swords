extends Player

var CanPlay : bool = true
var CanAttack : bool = false
var GiveDamageToPlayer : bool = true


var direction : Vector2 = Vector2(0,0)
var speed : int = 300
var health: int = 100
var BodyEntered: CharacterBody2D = null

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var damageCoolDown: Timer = $DamageCoolDown
@onready var HealthBar: TextureProgressBar = $Health
@onready var left: Marker2D = $Left
@onready var right: Marker2D = $Right
@onready var hurt_box: Area2D = $HurtBox

func _ready() -> void:
	HealthBar.value = 100

func _physics_process(_delta: float) -> void:
	if CanPlay:
		''' Part which takes care of motion '''
		direction = Input.get_vector("left","right","up","down")
		velocity = direction * speed
		move_and_slide()
		
		''' Part which takes care of fliping animations based of direction '''
		if direction.x > 0:
			animations.flip_h = false
			hurt_box.position = right.position
		elif direction.x < 0:
			animations.flip_h = true
			hurt_box.position = left.position
			
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
		Global.hasPlayerAttacked = false

func _on_damage_cool_down_timeout() -> void:
	''' Part which check damage taken '''
	if GiveDamageToPlayer:
		randomize()
		health -= randi_range(1,5)
		HealthBar.value = health
	damageCoolDown.start()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.collision_layer == 2048:
		health -= 10
		HealthBar.value = health
	else:
		GiveDamageToPlayer = true
		damageCoolDown.start()

func _on_hitbox_area_exited(_area: Area2D) -> void:
	GiveDamageToPlayer = false
	damageCoolDown.stop()
