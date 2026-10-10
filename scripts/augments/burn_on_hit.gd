extends OnHitEffect

@export var burn_duration: float = 3.0
@export var burn_damage_per_second: float = 5.0

func apply_effect(enemy: Node2D) -> void:
    enemy.burn(burn_damage_per_second, burn_duration)