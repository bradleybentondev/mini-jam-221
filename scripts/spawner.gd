extends Node2D

var enemy_scene = preload("res://scenes/enemy.tscn")
var brute_enemy_scene = preload("res://scenes/brute_enemy.tscn")

var timer: Timer
var player: Player
var spawn_distance: float = 700.0
var brute_enemy_chance: float = 0.2
var min_delay: float = 5.0
var max_delay: float = 10.0

func _ready():
	player = get_tree().get_nodes_in_group('player')[0]
	timer = Timer.new()
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	

func _on_timer_timeout():
	var spawn_location: Vector2 = player.global_position + (Vector2.RIGHT.rotated(randf() * TAU) * spawn_distance)
	var enemy: Node2D
	if randf() < brute_enemy_chance:
		enemy = brute_enemy_scene.instantiate()
	else:
		enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_location
	get_node("/root/World").add_child(enemy)
	timer.start(randf_range(min_delay, max_delay))
	min_delay = max(0.1, min_delay * 0.10)
	max_delay = max(0.3, max_delay * 0.10)
	
