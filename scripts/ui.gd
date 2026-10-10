extends Control

@export var health_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_nodes_in_group("player")[0]
	player.connect("take_damage", func take_damage():
		_on_player_take_damage(player.health)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_take_damage(player_health: float):
	health_bar.value = player_health
	
