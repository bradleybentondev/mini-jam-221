extends Area2D

class_name Enemy

var player: Player

@export var speed: float = 1

@export var health: float = 100

@export var hit_mass: float = 10

@export var damage_to_player: float = 10

@export var shape: CollisionShape2D

var _hit: bool = false

var dead: bool = false

var _hit_velocity: Vector2 = Vector2.ZERO

var _colliding: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group('player')[0]
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


func _physics_process(delta: float) -> void:

	if(_colliding.size() > 0):
		for enemy in _colliding:
			var total_radius = (shape.shape as CircleShape2D).radius + (enemy.shape.shape as CircleShape2D).radius

			var pushback_strength = (1 - (self.position.distance_to(enemy.position)/total_radius))*2
			var pushback_direction = (enemy.position - self.position).normalized()
			self.position -= pushback_direction * pushback_strength

	if(dead):
		return

	if(_hit):
		self.position += _hit_velocity
		return

	var direction_to_player = self.position.direction_to(player.position)
	self.position += direction_to_player * speed * delta


func hit(hit_time: float = 0.05, damage: float = 10, hit_velocity: Vector2 = Vector2.ZERO) -> void:
	if(_hit || dead):
		return

	health -= damage

	if(health <= 0):
		dead = true
		remove_from_group("enemies")
		add_to_group("corpses")
		self.monitoring =false
		return

	_hit_velocity = hit_velocity
	if(hit_time > 0):
		_hit = true
		await get_tree().create_timer(hit_time).timeout
	_hit = false
	_hit_velocity = Vector2.ZERO

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).hit(0.3, damage_to_player)

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		_colliding.append(area as Enemy)
		
func _on_area_exited(area: Area2D) -> void:
	if area is Enemy:
		_colliding.erase(area as Enemy)
