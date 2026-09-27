extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var tween: Tween

func _ready() -> void:
	set_freeze_opacity(0.0)

func trigger_freeze_effect(duration: float = 5.0) -> void:
	if tween and tween.is_running():
		tween.kill()
	print(1)
	tween = create_tween()
	
	tween.tween_method(set_freeze_opacity, 0.0, 1.0, 0.3)
	
	tween.tween_interval(duration - 0.8)
	
	tween.tween_method(set_freeze_opacity, 1.0, 0.0, 0.5)
	
func set_freeze_opacity(val: float) -> void:
	if color_rect and color_rect.material:
		color_rect.material.set_shader_parameter("opacity", val)
