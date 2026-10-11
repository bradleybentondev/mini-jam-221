extends OnHitEffect

@export var stun_duration: float = 0.45

func apply_effect(enemy: Node2D) -> void:
	enemy.stun(stun_duration)

func level_up() -> void:
	level += 1
	stun_duration += 0.05
