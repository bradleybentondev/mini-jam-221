extends Node2D

@export var throw_speed: float = 100.0
@export var throw_distance: float = 100.0
@export var damage: float = 5.0
@export var cooldown: float = 18.0


var level: int = 1
var _timer: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer -= delta
	if _timer < 0:
		var closest_enemy = Util.get_closest_enemy(get_tree().get_nodes_in_group("enemies"), self.global_position)
		if !is_instance_valid(closest_enemy):
			return
			
		_throw_scythe(closest_enemy)
		_timer = cooldown
	
func _throw_scythe(closest_enemy: Node2D):
	var direction = self.global_position.direction_to(closest_enemy.global_position)
	var scythe_instance = preload("res://scenes/augments/spinning_scythe.tscn").instantiate() as Area2D
	scythe_instance.direction = direction
	scythe_instance.speed = throw_speed
	scythe_instance.damage = damage
	scythe_instance.distance = throw_distance
	get_node("/root/World").add_child(scythe_instance)
	scythe_instance.global_position = self.global_position

func level_up() -> void:
	level += 1
	throw_distance += 250.0
	throw_speed += 250.0
	damage += 10
