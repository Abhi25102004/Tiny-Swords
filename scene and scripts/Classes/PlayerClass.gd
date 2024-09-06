class_name Player

extends CharacterBody2D

var level : int
var direction : Vector2
var speed : int
var attack : int 
var defence : int 
var health : int 
var healWait : float
var healingFactor : int 

func movement():
	direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()

func takeDamage(DamageArray : Array[int]):
	while DamageArray.size():
		health -= DamageArray.pop_front() - defence if DamageArray.pop_front() - defence >= 0 else 0

func heal():
	health += healingFactor

func PlayerAttack():
	Global.hasPlayerAttacked = true

func levelUp():
	level += 1
