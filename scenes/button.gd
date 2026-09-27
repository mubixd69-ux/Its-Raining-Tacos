extends Button





func _on_pressed() -> void:
	%TacoSpawner.visible = true
	$"../../Bag".visible = true
	$"../../HUD".visible = true
	$"../../Change scene".visible = true
	$"..".visible = false
