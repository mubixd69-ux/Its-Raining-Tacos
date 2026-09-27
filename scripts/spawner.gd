extends Node2D

const TACO = preload("uid://oyjm4g70q2t7")
const GOLDEN_TACO = preload("res://scenes/goldentaco.tscn")
const SPICY_TACO = preload("res://scenes/spicy.tscn")
const FROZEN_TACO = preload("res://scenes/frozen_taco.tscn")

@export var bag: Area2D
@export var ui: Control

var frozen_chance = 0.1
var golden_chance = 0.1
var spicy_chance = 0.2

var freeze_active := false


func _ready() -> void:
	spawn_tacos()

func spawn_tacos() -> void:
	var taco
	var roll = randf()

	var combo = 0
	if bag and "combo_count" in bag:
		combo = bag.combo_count

	if combo >= 5 and roll < frozen_chance:
		taco = FROZEN_TACO.instantiate()
	elif roll < golden_chance:
		taco = GOLDEN_TACO.instantiate()
	elif roll < spicy_chance:
		taco = SPICY_TACO.instantiate()
	else:
		taco = TACO.instantiate()

	taco.position = Vector2(
		randf_range(50, get_viewport_rect().size.x - 50),
		randf_range(-500, 0)
	)

	if bag and "combo_count" in bag and taco.has_method("set_combo"):
		taco.set_combo(bag.combo_count)

	# Apply frozen effect to newly spawned tacos
	if freeze_active and taco.has_method("slow_down"):
		taco.slow_down(0.5)

	taco.missed.connect(_on_taco_missed)
	taco.tree_exited.connect(_on_taco_despawned)
	add_child(taco)

func activate_freeze() -> void:
	freeze_active = true
	
	var freeze_overlay = get_node_or_null("%FreezeOverlay")
	if freeze_overlay and freeze_overlay.has_method("trigger_freeze_effect"):
		freeze_overlay.trigger_freeze_effect(5.0)
	
	await get_tree().create_timer(5.0).timeout

	freeze_active = false

func _on_taco_missed() -> void:
	if bag and bag.has_method("reset_combo"):
		bag.reset_combo()

func _on_taco_despawned() -> void:
	if not is_inside_tree():
		return

	var combo = 0
	if bag and "combo_count" in bag:
		combo = bag.combo_count

	var speed_boost = min(combo * 0.08, 0.8)

	var min_delay = max(0.05, 0.3 - speed_boost)
	var max_delay = max(0.15, 1.2 - speed_boost)

	var random_delay = randf_range(min_delay, max_delay)

	await get_tree().create_timer(random_delay).timeout
	spawn_tacos()
