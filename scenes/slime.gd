extends CharacterBody2D

const SPEED = 60
var direction = 1

@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if right.is_colliding():
		direction = -1
		print("-1")
	if left.is_colliding():
		print("-2")
		direction = 1
	
	
	position.x += delta * SPEED * direction
	
	move_and_slide()
