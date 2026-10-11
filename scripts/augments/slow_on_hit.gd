extends OnHitEffect

@export var slow_duration: float = 1.25
@export var slow_factor: float = 0.45


func apply_effect(enemy: Node2D) -> void:
    enemy.slow(slow_factor, slow_duration)

func level_up() -> void:
    level += 1
    slow_duration += 0.25
    slow_factor += 0.05