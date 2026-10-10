extends Area2D

class_name Enemy

var player: Player

@export var speed: float = 1

@export var health: float = 100

@export var hit_mass: float = 10

@export var damage_to_player: float = 10

@export var shape: CollisionShape2D

@export var decompose_delay: float = 15.0

@export var sprite: AnimatedSprite2D

@export var xp_value: float = 1

var _hit: bool = false

var dead: bool = false

var _hit_velocity: Vector2 = Vector2.ZERO

var _colliding: Array[Enemy] = []

var _stun_timer: float = 0

var _slow_timer: float = 0
var _slow_factor: float = 1

var _burn_timer: float = 0
var _burn_dps: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group('player')[0]
	sprite.play()
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


func _physics_process(delta: float) -> void:
	if (_colliding.size() > 0):
		for enemy in _colliding:
			var total_radius = (shape.shape as CircleShape2D).radius + (enemy.shape.shape as CircleShape2D).radius

			var pushback_strength = (1 - (self.position.distance_to(enemy.position) / total_radius)) * 2
			var pushback_direction = (enemy.position - self.position).normalized()
			self.position -= pushback_direction * pushback_strength

	if (dead):
		return

	_process_status_effects(delta)

	if (dead):
		return

	if (_hit):
		self.position += _hit_velocity
		return

	if (_stun_timer > 0):
		return

	var direction_to_player = self.position.direction_to(player.position)
	self.position += direction_to_player * speed * _slow_factor * delta


func hit(hit_time: float = 0.05, damage: float = 10, hit_velocity: Vector2 = Vector2.ZERO) -> void:
	if (_hit || dead):
		return

	_take_damage(damage)

	if (dead):
		return

	_hit_velocity = hit_velocity
	if (hit_time > 0):
		_hit = true
		await get_tree().create_timer(hit_time).timeout
	_hit = false
	_hit_velocity = Vector2.ZERO

func _decompose() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate", Color(sprite.modulate.r, sprite.modulate.g, sprite.modulate.b, 0), 1.0)
	tween.tween_callback(self.queue_free)

func stun(duration: float) -> void:
	if (dead):
		return
	_stun_timer = max(_stun_timer, duration)


func slow(factor: float, duration: float) -> void:
	if (dead):
		return
	_slow_factor = min(_slow_factor, factor)
	_slow_timer = max(_slow_timer, duration)


func burn(damage_per_second: float, duration: float) -> void:
	if (dead):
		return

	_burn_dps = max(_burn_dps, damage_per_second)
	_burn_timer = max(_burn_timer, duration)


func _take_damage(damage: float) -> void:
	health -= damage

	if (health <= 0 && !dead):
		_die()


func _die() -> void:
	dead = true
	modulate = Color.WHITE
	sprite.stop()
	remove_from_group("enemies")
	add_to_group("corpses")
	set_deferred("monitoring", false)
	get_tree().call_group("kill_listeners", "react_to_kill", self)
	get_tree().create_timer(decompose_delay).timeout.connect(_decompose)


func _process_status_effects(delta: float) -> void:
	_stun_timer = max(_stun_timer - delta, 0)

	if (_slow_timer > 0):
		_slow_timer -= delta
		if (_slow_timer <= 0):
			_slow_factor = 1

	if (_burn_timer > 0):
		_burn_timer -= delta
		_take_damage(_burn_dps * delta)
		if (_burn_timer <= 0):
			_burn_dps = 0

	if (dead):
		return

	if (_stun_timer > 0):
		modulate = Color(1, 1, 0.4)
	elif (_burn_timer > 0):
		modulate = Color(1, 0.6, 0.3)
	elif (_slow_timer > 0):
		modulate = Color(0.5, 0.7, 1)
	else:
		modulate = Color.WHITE

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		(body as Player).hit(0.3, damage_to_player)

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		_colliding.append(area as Enemy)

func _on_area_exited(area: Area2D) -> void:
	if area is Enemy:
		_colliding.erase(area as Enemy)
