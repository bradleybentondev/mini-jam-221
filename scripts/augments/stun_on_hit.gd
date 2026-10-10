extends OnHitEffect

@export var stun_duration: float = 0.5

func apply_effect(enemy: Node2D) -> void:
	enemy.stun(stun_duration)
