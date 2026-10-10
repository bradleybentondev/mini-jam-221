extends Node2D

@export var cooldown: float = 10


var _timer: float

var _beam = preload("res://scenes/augments/sun_beam_blast.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0:
		_timer = cooldown
		# Trigger the sun beam blast augment effect here
		_spawn_beam()


func _spawn_beam() -> void:
	var beam_instance = _beam.instantiate() as Node2D
	add_child(beam_instance)
	var rotation_to_mouse = (get_global_mouse_position() - global_position).angle()
	beam_instance.global_position = global_position
	beam_instance.global_rotation = rotation_to_mouse
