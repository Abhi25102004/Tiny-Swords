extends Player

enum AttackState { Cut , Build }

var AttackType = AttackState.Build

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var HealthLable: TextureProgressBar = $Health
@onready var LeftMarker: Marker2D = $Left
@onready var RightMarker: Marker2D = $Right
@onready var HurtBox: Area2D = $HurtBox

func _ready() -> void:
	health = 100
	speed = 300
	direction = Vector2(0,0)
	power = Global.PlayerLevel * 10
	Global.PlayerPower = power
	HealthLable.max_value = Global.PlayerLevel * health
	HealthLable.value = Global.PlayerLevel * health

func _physics_process(delta: float) -> void:
	if MainState == GameState.Play:
		StateManager()
		
		DamageTaken()
		
		match player:
			
			PlayerState.Idle:
				Animations.play("idle")
			
			PlayerState.Movement:
				movement()
				Animations.play("walk")
				
				match PlayerDirection:
				
					DirectionState.Right:
						Animations.flip_h = false
						HurtBox.position = RightMarker.position
				
					DirectionState.Left:
						Animations.flip_h = true
						HurtBox.position = LeftMarker.position
			
			PlayerState.Attacking:
				MainState = GameState.Blocked
				Global.hasPlayerAttacked = true
				
				match AttackType:
					AttackState.Cut:
						Animations.play("cut")
					AttackState.Build:
						Animations.play("build")
			
			PlayerState.Dead:
				get_tree().quit()

func AnimationHasFinished() -> void:
	MainState = GameState.Play
