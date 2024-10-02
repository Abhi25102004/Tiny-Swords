extends StaticBody2D

signal AnimationFinished

var BowVector : Vector2
var BaseVector : Vector2
@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var shooter: Marker2D = $Shooter

func _physics_process(_delta: float) -> void:
	BowVector = (get_global_mouse_position() - global_position).normalized()
	Animations.flip_h = true if (get_global_mouse_position().x < global_position.x) else false
	BaseVector = Vector2.LEFT if Animations.flip_h else Vector2.RIGHT
	rotation_degrees = rad_to_deg(BaseVector.angle_to(BowVector))
	
	if Input.is_action_pressed("attack"):
		Animations.play("attack")

func AnimationCompleted() -> void:
	Animations.play("idle")
	AnimationFinished.emit()
