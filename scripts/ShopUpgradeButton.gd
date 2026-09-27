extends Button

enum UpgradeType { FROZEN_CHANCE, GOLDEN_CHANCE, SPICY_CHANCE, BAG_CAPACITY }

@export var item_name: String = "Upgrade Name"
@export var type: UpgradeType
@export var price: float = 50.0
@export var is_one_time_buy = false

@export var max_percent: float = 50.0
@export var effect_value: float = 5.0

@export var speed_increase: float = 0.0
@export var scale_increase: float = 0.0

func _ready() -> void:
	update_button_text()

func update_button_text() -> void:
	var effect_text = ""
	
	match type:
		UpgradeType.FROZEN_CHANCE:
			var current = GameData.frozen_chance * 100.0
			effect_text = "Current %.1f%% | +%.1f%% Chance" % [current, effect_value]
		UpgradeType.GOLDEN_CHANCE:
			var current = GameData.golden_chance * 100.0
			effect_text = "Current %.1f%% | +%.1f%% Chance" % [current, effect_value]
		UpgradeType.SPICY_CHANCE:
			var current = GameData.spicy_chance * 100
			effect_text = "Current %.1f%% |-%.1f%% Chance" % [current, effect_value]
		UpgradeType.BAG_CAPACITY:
			effect_text = "+%d Capacity" % int(effect_value)
			if speed_increase > 0.0:
				var speed_percentage = (speed_increase / 500) * 100
				effect_text += " | +%d%% Speed" % int(speed_percentage)
			if scale_increase > 0.0:
				effect_text += " | +%d%% Size" %int(scale_increase * 100)
	var rich_text_field = get_node_or_null("RichTextLabel")
	if rich_text_field:
		var bbcode = "[center]"
		bbcode += "[font_size=24]%s[/font_size]\n" % item_name.to_upper()
		bbcode += "[font_size=18][color=#55ff55]%s[/color][/font_size]\n" % effect_text
		bbcode += "[font_size=20][color=#ffd700]Cost: %.2f[/color][/font_size]" % price
		bbcode += "[/center]"
		
		rich_text_field.text = bbcode
func _pressed() -> void:
	if GameData.taco_coins >= price:
		GameData.taco_coins -= price
		var is_maxed = false
		
		match  type:
			UpgradeType.FROZEN_CHANCE:
				GameData.frozen_chance += (effect_value / 100.0)
				if GameData.frozen_chance >= (max_percent / 100.0):
					GameData.frozen_chance = max_percent / 100.0
					is_maxed = true
					
			UpgradeType.GOLDEN_CHANCE:
				GameData.golden_chance += (effect_value / 100.0)
				if GameData.golden_chance >= (max_percent / 100.0):
					GameData.golden_chance = max_percent / 100.0
					is_maxed = true
					
			UpgradeType.SPICY_CHANCE:
				GameData.spicy_chance -= (effect_value / 100.0)
				if GameData.spicy_chance <= (max_percent / 100.0):
					GameData.spicy_chance = max_percent / 100.0
					is_maxed = true
					
			UpgradeType.BAG_CAPACITY:
				GameData.max_bag_capacity += int(effect_value)
				GameData.player_speed += speed_increase
				GameData.player_scale += scale_increase
				
		spawn_floating_text("Upgraded!", Color(0.2, 1.0, 0.2))
		
		var money_node = get_node_or_null("../money")
		if money_node:
			money_node.text = "%.2f" % GameData.taco_coins	
		if is_one_time_buy or is_maxed:
			disabled = true
			
			text = ""
			var rich_text_field = get_node_or_null("RichTextLabel")
			if rich_text_field:
				var end_text = "[ MAXED OUT ]" if is_maxed else "[ SOLD OUT ]"
				
				var sold_bbcode = "[center]"
				sold_bbcode += "[font_size=22][color=#888888]%s[/color][/font_size]\n" % item_name.to_upper()
				sold_bbcode += "[font_size=24][color=#ff4444][ SOLD OUT ][/color][/font_size]"
				sold_bbcode += "[/center]"
				rich_text_field.text = sold_bbcode
		else:
			price *= 1.5
			update_button_text()
		
	else:
		spawn_floating_text("Not Enough Coins!", Color(1.0, 0.2, 0.2))
		
func spawn_floating_text(msg: String, text_color: Color ) -> void:
	var float_label = Label.new()
	float_label.text = msg
	float_label.add_theme_color_override("font_color", text_color)
	float_label.add_theme_font_size_override("font_size", 24)
	float_label.add_theme_constant_override("outline_size", 4)
	float_label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	get_parent().add_child(float_label)
	float_label.global_position = get_global_mouse_position() + Vector2(randf_range(-60, 60), randf_range(-70, -30))
	
	var tween = create_tween()
	tween.tween_property(float_label, "position:y", float_label.position.y - 60, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(float_label, "modulate:a", 0.0, 0.6).set_ease(Tween.EASE_IN)
	tween.tween_callback(float_label.queue_free)
	
	
	
