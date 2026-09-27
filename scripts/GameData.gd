extends Node

# Signal emitted whenever a hat or skin is equipped
signal hat_changed(new_sprite: Texture2D)

# Currency and Bag Progress
var taco_count: int = 0
var taco_coins: float = 0.0

# Spawn Probabilities
var frozen_chance: float = 0.2
var golden_chance: float = 0.10
var spicy_chance: float = 0.2
var minigame_taco_chance: float = 0.2

# Upgradable Player Stats
var max_bag_capacity: int = 10
var player_speed: float = 400.0
var player_scale: float = 0.8

# Equipped Hat / Skin (Triggers signal automatically when assigned)
var equipped_hat_sprite: Texture2D = null:
	set(value):
		equipped_hat_sprite = value
		hat_changed.emit(value)


func is_bag_full() -> bool:
	return taco_count >= max_bag_capacity


func add_taco(amount: int = 1, multipliar: int = 1) -> void:
	taco_count += amount * multipliar
	taco_count = clamp(taco_count, 0, max_bag_capacity)
