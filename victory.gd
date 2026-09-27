extends Node2D

@onready var animation_player: AnimationPlayer = $"../CanvasLayer/AnimationPlayer"



func _on_area_2d_body_entered(body: Node2D) -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")
