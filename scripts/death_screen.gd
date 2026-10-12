extends CanvasLayer

class_name DeathScreen

# Built entirely in code so it can be dropped in with DeathScreen.new().
# Pauses the whole game and restarts the scene when Respawn is clicked.

func _ready() -> void:
	# Keep running while the rest of the game is paused, and draw on top of everything.
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	get_tree().paused = true

	var background := ColorRect.new()
	background.color = Color(0, 0, 0, 0.7)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 24)
	center.add_child(box)

	var title := Label.new()
	title.text = "YOU DIED"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))
	box.add_child(title)

	var level_system = get_tree().get_first_node_in_group("level_system")
	if level_system:
		var stats := Label.new()
		stats.text = "You reached level %d" % level_system.level
		stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		stats.add_theme_font_size_override("font_size", 24)
		box.add_child(stats)

	var respawn_button := Button.new()
	respawn_button.text = "Respawn"
	respawn_button.custom_minimum_size = Vector2(200, 60)
	respawn_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	respawn_button.add_theme_font_size_override("font_size", 28)
	respawn_button.pressed.connect(_on_respawn_pressed)
	box.add_child(respawn_button)
	respawn_button.grab_focus()


func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
