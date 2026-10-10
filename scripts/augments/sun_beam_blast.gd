extends Node2D

@export var damage: float = 1000

@export var animationPlayer: AnimationPlayer
@export var area2D: Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2D.connect("area_entered", _on_area_entered)
	animationPlayer.play("default")
	animationPlayer.connect("animation_finished", _on_animation_finished)


func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		var enemy = area as Enemy
		enemy.hit(0, damage)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "default":
		queue_free()
