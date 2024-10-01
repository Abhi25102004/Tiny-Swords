extends Player

var Arrow : PackedScene = preload("res://scene and scripts/Extras/arrow.tscn")
var ArrowPosition : Marker2D
var ArrowInstance : CharacterBody2D
@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var HealthLable: TextureProgressBar = $Health
@onready var LeftMarker: Marker2D = $Left
@onready var RightMarker: Marker2D = $Right

func _ready() -> void:
	health = 100
	speed = 300
	direction = Vector2(0,0)
	power = Global.PlayerLevel * 10
	Global.PlayerPower = power
	HealthLable.max_value = Global.PlayerLevel * health
	HealthLable.value = Global.PlayerLevel * health
	ArrowPosition = LeftMarker

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
						ArrowPosition = RightMarker
			
					DirectionState.Left:
						Animations.flip_h = true
						ArrowPosition = LeftMarker
			
			PlayerState.Attacking:
				MainState = GameState.Blocked
				Animations.play("attack")
				ArrowInstance = Arrow.instantiate()
				ArrowInstance.direction.x = -1 if ArrowPosition == LeftMarker else 1 
				ArrowInstance.movement = Animations.flip_h
				ArrowInstance.global_position = ArrowPosition.global_position
			
			PlayerState.Dead:
				get_tree().quit()

func AnimationHasFinished() -> void:
	if MainState == GameState.Blocked:
		get_parent().add_child(ArrowInstance)
	
	MainState = GameState.Play
