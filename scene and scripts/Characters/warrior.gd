extends Player

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var HealthLable: TextureProgressBar = $Health
@onready var LeftMarker: Marker2D = $Left
@onready var RightMarker: Marker2D = $Right
@onready var HurtBox: Area2D = $HurtBox

func _ready() -> void:
	health = 100
	speed = 300
	direction = Vector2(0,0)
	power = Global.PlayerLevel * 15
	Global.PlayerPower = power
	HealthStatues = HealthLable
	HealthStatues.max_value = health
	HealthStatues.value = health

func _physics_process(_delta: float) -> void:
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
				Animations.play("attack")
				Global.hasPlayerAttacked = true
			
			PlayerState.Dead:
				pass

func AnimationHasFinished() -> void:
	MainState = GameState.Play
