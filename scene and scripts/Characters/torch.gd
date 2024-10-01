extends Enemy

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var HealthLable: TextureProgressBar = $Health
@onready var LeftMarker: Marker2D = $Left
@onready var RightMarker: Marker2D = $Right
@onready var HurtBox: Area2D = $HurtBox

func _ready() -> void:
	health = Global.PlayerLevel * 150
	speed = 250
	direction = Vector2(0,0)
	power = Global.PlayerLevel * 5
	HealthStatues = HealthLable
	HealthStatues.max_value = health
	HealthStatues.value = health

func _physics_process(_delta: float) -> void:
	if MainState == GameState.Play:
		StateManager()
		
		TakingDamage()
		
		match enemy:
			
			EnemyState.Idle:
				Animations.play("idle")
			
			EnemyState.Movement:
				movement()
				Animations.play("walk")
				
				match EnemyDirection:
				
					DirectionState.Right:
						Animations.flip_h = false
						HurtBox.position = RightMarker.position
				
					DirectionState.Left:
						Animations.flip_h = true
						HurtBox.position = LeftMarker.position
			
			EnemyState.Attacking:
				MainState = GameState.Blocked
				Animations.play("attack")
				Global.TotalDamage.append(power)
			
			EnemyState.Dead:
				MainState = GameState.Blocked
				HealthLable.value = 0
				HealthLable.visible = false
				Animations.play("death")
				await get_tree().create_timer(1.0).timeout
				var bag = BagOfGold.instantiate()
				bag.global_position = global_position
				await get_tree().create_timer(0.6).timeout
				get_parent().add_child(bag)
				queue_free()

func AnimationHasFinished() -> void:
	MainState = GameState.Play

func _on_hitbox_area_entered(_area: Area2D) -> void:
	PlayerAttackState = PlayerCanAttack.In

func _on_hitbox_area_exited(_area: Area2D) -> void:
	PlayerAttackState = PlayerCanAttack.Out

func _on_hurt_box_area_entered_(_area: Area2D) -> void:
	print("hurtbox entered")
	enemy = EnemyState.Attacking

func _on_hurt_box_area_exited(_area: Area2D) -> void:
	print("hurtbox exited")
	enemy = EnemyState.Movement

func _on_detection_area_body_entered(body: Node2D) -> void:
	PlayerCharacter = body
	enemy = EnemyState.Movement

func _on_detection_area_body_exited(_body: Node2D) -> void:
	PlayerCharacter = null
