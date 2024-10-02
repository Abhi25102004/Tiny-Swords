extends Player

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var HealthLable: TextureProgressBar = $Health
var Bow: StaticBody2D

func _ready() -> void:
	health = 100
	speed = 300
	direction = Vector2(0,0)
	power = Global.PlayerLevel * 15
	Global.PlayerPower = power
	HealthStatues = HealthLable
	HealthStatues.max_value = health
	HealthStatues.value = health
	Bow = get_node("Bow")
	Bow.connect("AnimationFinished",AnimationHasFinished)

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
					
					DirectionState.Left:
						Animations.flip_h = true
				
			PlayerState.Attacking:
				MainState = GameState.Blocked
			
			PlayerState.Dead:
				get_tree().quit()

func AnimationHasFinished() -> void:
	MainState = GameState.Play
