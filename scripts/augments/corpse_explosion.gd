extends Node

@export var cooldown: float = 25.0
@export var explosion_radius: float = 10.0
@export var explosion_damage: float = 20.0

var level: int = 1

var explosions = preload("res://scenes/explosion.tscn")

var _timer: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_timer = cooldown


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0:
		_explode()
		_timer = cooldown

func _explode() -> void:
	var corpses = get_tree().get_nodes_in_group("corpses")
	var timePerExplode = 0.8 / corpses.size()
	for corpse in corpses:
		var explosion_instance = explosions.instantiate() as AnimatedSprite2D
		explosion_instance.position = corpse.position
		get_tree().current_scene.add_child(explosion_instance)
		corpse.queue_free()
		explosion_instance.play()
		explosion_instance.connect("animation_finished", func(): explosion_instance.queue_free())

		_hit_enemies_in_area(corpse)

		await get_tree().create_timer(timePerExplode).timeout


func _hit_enemies_in_area(corpse: Node2D) -> void:
	var space_state = get_viewport().world_2d.direct_space_state

	var query =  PhysicsShapeQueryParameters2D.new()
	query.shape = CircleShape2D.new()
	query.shape.radius = explosion_radius
	query.transform = corpse.transform
	query.collide_with_areas = true
	query.collision_mask = 1 << 1

	var results: Array[Dictionary] = space_state.intersect_shape(query, 100)

	for result in results:
		var enemy = result.collider
		if !enemy.dead:
			enemy.hit(0, explosion_damage)

func level_up() -> void:
	level += 1
	explosion_radius += 15.0
	explosion_damage += 20.0
	cooldown = max(5.0, cooldown - 2.0)
