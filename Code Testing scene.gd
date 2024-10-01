extends Node2D

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		print("Attack event")
	elif (!Input.is_action_just_pressed("attack")):
		print("movement")
	else:
		print("idle")
