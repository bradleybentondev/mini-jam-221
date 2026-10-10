extends Node2D

@export var heal_per_kill: float = 0.5
var level: int = 1

func _ready() -> void:
	add_to_group("kill_listeners")

func react_to_kill(enemy: Node2D) -> void:
	if enemy is Enemy:
		var heal_amount = heal_per_kill
		get_parent().heal(heal_amount)
