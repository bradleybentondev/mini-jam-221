extends Node

class_name Pausable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("paused", _pause)
	
func _pause(value: bool):
	if value:
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	else:
		get_parent().process_mode = Node.PROCESS_MODE_INHERIT
