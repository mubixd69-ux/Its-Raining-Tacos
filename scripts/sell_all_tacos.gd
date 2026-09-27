extends Button

@export var ui: Control
var random_price: float = 2.0
var price_timer: Timer

func _ready() -> void:
	_change_price()
	
	
	price_timer = Timer.new()
	price_timer.wait_time = 60.0
	price_timer.autostart = true
	price_timer.timeout.connect(_change_price)
	add_child(price_timer)
	
func _process(delta: float) -> void:
		if price_timer and  has_node("../TimeLabel"):
			$"../TimeLabel".text = "%ds" % int(price_timer.time_left)

func _change_price():
	random_price = randf_range(1.5, 2.5)
	
	text = "SELL ALL TACOS\n[ x%.2f ]" % random_price

func _pressed() -> void:
	var tacos_sold = GameData.taco_count
	
	if tacos_sold <= 0:
		spawn_floating_text("No Tacos!", Color(1.0, 0.2, 0.2))
		return
	
	var earned_coins = tacos_sold * random_price
	GameData.taco_coins += earned_coins
	GameData.taco_count = 0
	
	if has_node("../money"):
		$"../money".text = str(snapped(GameData.taco_coins, 0.01))
	
	spawn_floating_text("+%.2f Coins!" % earned_coins, Color(0.2, 1.0, 0.2))

func spawn_floating_text(msg: String, text_color: Color) -> void:
	var float_label = Label.new()
	float_label.text = msg
	
	float_label.add_theme_color_override("font_color", text_color)
	float_label.add_theme_font_size_override("font_size", 32)
	float_label.add_theme_constant_override("outline_size", 6)
	float_label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	get_parent().add_child(float_label)
	
	float_label.global_position = get_global_mouse_position() + (size / 2.0) - Vector2(40, 20)
	
	
	var tween = create_tween()
	tween.tween_property(float_label, "position:y", float_label.position.y - 80.0, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(float_label, "modulate:a", 0.0, 0.8).set_ease(Tween.EASE_IN)
	tween.tween_callback(float_label.queue_free)
