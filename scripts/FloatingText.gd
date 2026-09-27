extends Label

func start(amount: int, combo: int, spawn_position: Vector2, minigame_taco: bool = false) -> void:
	if not minigame_taco and combo > 1:
		text = "+" + str(amount) + " (" + str(combo) + "x COMBO!)"
	else:
		text = "+" + str(amount)

	position = spawn_position

	var font_size = min(20 + (combo * 4), 48)
	add_theme_font_size_override("font_size", font_size)

	if combo >= 10:
		add_theme_color_override("font_color", Color(1.0, 0.2, 0.2))
	elif combo >= 5:
		add_theme_color_override("font_color", Color(1.0, 0.5, 0.0))
	else:
		add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))

	var tween = create_tween().set_parallel(true)

	tween.tween_property(self, "position:y", position.y - 60.0, 0.8)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 0.0, 0.8)

	tween.finished.connect(queue_free)
