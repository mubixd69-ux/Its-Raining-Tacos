extends Node2D

@onready var ray_cast_2_right: RayCast2D = $RayCast2Right
@onready var ray_cast_2_left: RayCast2D = $RayCast2Left

const speed = 45

var direction = 1

func _process(delta: float) -> void:
	if ray_cast_2_right.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = true
	if ray_cast_2_left.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = false
		
	position.x += direction * speed * delta
