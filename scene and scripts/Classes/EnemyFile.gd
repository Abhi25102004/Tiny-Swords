class_name Enemy
extends CharacterBody2D

enum GameState { Blocked , Play}
enum EnemyState { Idle , Movement , Attacking , Dead }
enum DirectionState { Right , Left }
enum PlayerCanAttack { In , Out }
var MainState : GameState = GameState.Play
var health : int
var speed : int
var direction : Vector2
var power : int
var enemy : EnemyState = EnemyState.Idle
var EnemyDirection : DirectionState = DirectionState.Right
var PlayerCharacter : CharacterBody2D = null
var PlayerAttackState : PlayerCanAttack = PlayerCanAttack.Out
var HealthStatues : TextureProgressBar
var BagOfGold : PackedScene = preload("res://scene and scripts/Collectables/coin_bag.tscn")


func StateManager():
	if HealthStatues.value <= 0:
		enemy = EnemyState.Dead
	elif PlayerCharacter == null:
		enemy = EnemyState.Idle

func movement():
	direction = (PlayerCharacter.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	EnemyDirection = DirectionState.Right if direction.x >= 0 else DirectionState.Left

func TakingDamage():
	if Global.hasPlayerAttacked and PlayerAttackState == PlayerCanAttack.In:
		Global.hasPlayerAttacked = false
		HealthStatues.value -= Global.PlayerPower
