extends Node2D

var player: Player

@export var speed: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group('player')[0]

func _physics_process(delta: float) -> void:
	var direction_to_player = player.position.direction_to(self.position)
	
	self.position -= direction_to_player * speed
