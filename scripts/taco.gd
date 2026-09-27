extends Area2D

signal missed
signal caught

@export var taco_value: int = 1
@export var ignores_multiplier: bool = false
@export var is_frozen_taco: bool = false
@export var freezes_time := false
@export var starts_minigame: bool = false

var fall_speed = 200.0
var speed_multiplier := 1.0

func set_combo(combo: int):
	fall_speed = min(200.0 + (combo * 35.0), 700)

func slow_down(multiplier: float):
	speed_multiplier = multiplier

func _process(delta):
	position.y += fall_speed * speed_multiplier * delta

	if position.y > 700:
		missed.emit()
		queue_free()

func get_caught(multiplier: int = 1) -> void:
	if ignores_multiplier:
		GameData.add_taco(taco_value)
	else:
		GameData.add_taco(taco_value, multiplier)

	if is_frozen_taco:
		var spawner = get_parent()
		if spawner.has_method("activate_freeze"):
			spawner.activate_freeze()

	if starts_minigame:
		var spawner = get_parent()
		if spawner.has_method("send_to_minigame"):
			spawner.send_to_minigame()
		else:
			print("ERROR: send_to_minigame() not found!")

	caught.emit()
	queue_free()
