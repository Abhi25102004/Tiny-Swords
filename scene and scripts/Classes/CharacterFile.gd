class_name Player
extends CharacterBody2D

enum GameState { Blocked , Play}
enum PlayerState { Idle , Movement , Attacking , Dead }
enum DirectionState { Right , Left }

var MainState : GameState = GameState.Play
var health : int
var speed : int
var direction : Vector2
var power : int
var player : PlayerState = PlayerState.Idle
var PlayerDirection : DirectionState = DirectionState.Right
var HealthStatues : TextureProgressBar

func StateManager():
	if HealthStatues.value <= 0:
		player = PlayerState.Dead
	else:
		if Input.is_action_pressed("attack"):
			player = PlayerState.Attacking
		else:
			direction = Input.get_vector("left","right","up","down")
			player = PlayerState.Movement if direction != Vector2(0,0) else PlayerState.Idle

func movement():
	velocity = direction * speed
	move_and_slide()
	PlayerDirection = DirectionState.Right if direction.x >= 0 else DirectionState.Left

func DamageTaken():
	if Global.TotalDamage.size():
		HealthStatues.value -= Global.TotalDamage.pop_back()
