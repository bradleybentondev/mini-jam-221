extends RigidBody2D

class_name Enemy

var player: Player

@export var speed: float = 1

@export var health: float = 100

var _hit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group('player')[0]

func _physics_process(delta: float) -> void:

	if(_hit):
		return

	var direction_to_player = self.position.direction_to(player.position)
	apply_central_force(direction_to_player * speed)
	

func hit(hit_time: float = 0.05, damage: float = 10) -> void:
	if(_hit):
		return

	health -= damage

	if(health <= 0):
		queue_free()
		return

	_hit = true
	self.mass = 1000
	await get_tree().create_timer(hit_time).timeout
	_hit = false
	self.mass = 1