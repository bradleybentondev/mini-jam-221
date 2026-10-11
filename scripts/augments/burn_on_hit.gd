extends OnHitEffect

@export var burn_duration: float = 1.0
@export var burn_damage_per_second: float = 2.0

func apply_effect(enemy: Node2D) -> void:
	enemy.burn(burn_damage_per_second, burn_duration)

func level_up() -> void:
	level += 1
	burn_duration += 0.75  
	burn_damage_per_second += 1.5  
