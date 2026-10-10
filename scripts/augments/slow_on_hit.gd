extends OnHitEffect

@export var slow_duration: float = 2.0
@export var slow_factor: float = 0.5

func apply_effect(enemy: Node2D) -> void:
    enemy.slow(slow_factor, slow_duration)