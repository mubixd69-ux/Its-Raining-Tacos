extends Button





func _on_pressed() -> void:
	$"../TacoSpawner".visible = false
	$"../Bag".visible = false
	$"../Resturant".visible = true
	visible = false
