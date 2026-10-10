extends Node2D
class_name OnHitEffect

@export var proc_chance: float = 0.1
@export var ranged_only: bool = false

var level: int = 1

func _ready() -> void:
    add_to_group("on_hit_effects")

func try_proc(enemy: Node2D, proc_rate: float, ranged: bool) -> void:  
    if enemy.is_in_group("enemies"):
        if ranged_only and not ranged:
            return

        if randf() < proc_chance * proc_rate:
            apply_effect(enemy)

func apply_effect(enemy: Node2D) -> void:
    pass