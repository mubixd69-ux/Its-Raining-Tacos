extends Area2D

# Reference to the bag's Sprite2D child node
@onready var sprite: Sprite2D = $Sprite2D

@export var speed: float = 400.0
@export var acceleration: float = 2000.0
@export var friction: float = 2000.0

@export var hud: Control

var screen_size: Vector2
var combo_count: int = 0
var velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	screen_size = get_viewport_rect().size

	# Listen for hat/skin changes from GameData
	if GameData.has_signal("hat_changed"):
		GameData.hat_changed.connect(_on_hat_changed)
		
	# Apply equipped hat if one was previously selected
	if GameData.equipped_hat_sprite:
		_on_hat_changed(GameData.equipped_hat_sprite)


func _process(delta: float) -> void:
	scale = Vector2(GameData.player_scale, GameData.player_scale)
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = move_toward(
			velocity.x,
			direction * GameData.player_speed,
			acceleration * delta
		)
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			friction * delta
		)

	position.x += velocity.x * delta

	if position.x <= 50.0 or position.x >= screen_size.x - 50.0:
		velocity.x = 0.0

	position.x = clamp(position.x, 50.0, screen_size.x - 50.0)


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_caught"):

		if GameData.is_bag_full():
			spawn_bag_full_text()
			area.get_caught(0)
			return

		combo_count += 1

		var multipliar = 1

		if combo_count >= 15:
			multipliar = 4
		elif combo_count >= 10:
			multipliar = 3
		elif combo_count >= 5:
			multipliar = 2

		# Check for custom taco values (e.g., Golden Taco = 10)
		var taco_value = 1
		if "taco_value" in area:
			taco_value = area.taco_value

		# Check if this taco initiates a minigame scene change
		var starts_minigame = false
		if "starts_minigame" in area:
			starts_minigame = area.starts_minigame

		area.get_caught(multipliar)

		# Skip floating text if transitioning to a minigame
		if starts_minigame:
			return

		if hud and hud.has_method("update_tacos"):
			hud.update_tacos()

		var total_earned = taco_value * multipliar
		spawn_floating_text(total_earned, combo_count)


func reset_combo() -> void:
	combo_count = 0


# Hat/Skin Swapping Callbacks
func _on_hat_changed(new_texture: Texture2D) -> void:
	if sprite and new_texture:
		sprite.texture = new_texture


func update_hat() -> void:
	if sprite and GameData.equipped_hat_sprite:
		sprite.texture = GameData.equipped_hat_sprite


# Floating Text Popups
func spawn_floating_text(amount: int, combo: int) -> void:
	var popup = Label.new()
	popup.set_script(load("res://scripts/FloatingText.gd"))

	var spawn_pos = global_position + Vector2(-10, -40)

	get_tree().current_scene.add_child(popup)
	popup.start(amount, combo, spawn_pos)


func spawn_bag_full_text() -> void:
	var popup = Label.new()
	popup.text = "BAG FULL!"
	popup.modulate = Color(1.0, 0.0, 0.0, 1.0)
	popup.global_position = global_position + Vector2(-30, -50)

	get_tree().current_scene.add_child(popup)

	var tween = create_tween()
	tween.tween_property(
		popup,
		"position:y",
		popup.position.y - 30,
		0.5
	)
	tween.parallel().tween_property(
		popup,
		"modulate:a",
		0.0,
		0.5
	)
	tween.tween_callback(popup.queue_free)
