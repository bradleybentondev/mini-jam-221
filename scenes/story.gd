extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_next_text("Reports are saying this is a rapidly approaching ice age due to the earths orbit moving further away and that temperatures will drop exponentially throughout the day and night.")
	await get_tree().create_timer(5.0).timeout
	_set_next_text("As many people as possible are being evacuated to shelters, but the majority of the population won't be able to fit or survive")
	await get_tree().create_timer(5.0).timeout
	_set_next_text("You remember an odd looking item above the fireplace downstairs. The note on the mantle reads 'In case of an ice age, take outside and power up to pull the earth closer to the sun' ")
	await get_tree().create_timer(5.0).timeout
	_set_next_text("You take the item outside, and see monsters from the ice ages past approaching....")
	
	await get_tree().create_timer(10.0).timeout
	
	var label: Label = $%Label
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1,1,1,0), 2.0)
	
	await get_tree().create_timer(5.0).timeout
	
	get_tree().change_scene_to_file("res://scenes/world.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _set_next_text(text: String) -> void:
	var label: Label = $%Label
	var tween = get_tree().create_tween()
	
	tween.tween_property(label, "modulate", Color(1,1,1,0), 0.25)
	
	await get_tree().create_timer(0.5).timeout
	
	label.text = text
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(label, "modulate", Color(1,1,1,1), 0.5)
