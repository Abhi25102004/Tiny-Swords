class_name Enemy

extends CharacterBody2D

var level : int
var direction : Vector2
var speed : int
var attack : int 
var defence : int 
var maxHealth : int
var health : int 
var healWait : float
var healingFactor : int 

func movement(Body : CharacterBody2D):
	direction = (Body.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func takeDamage(DamageArray : Array[int]):
	while DamageArray.size():
		health -= DamageArray.pop_front() - defence if DamageArray.pop_front() - defence >= 0 else 0

func heal():
	if health < maxHealth:
		health += healingFactor

func PlayerAttack():
	Global.hasPlayerAttacked = true

func levelUp():
	level += 1
