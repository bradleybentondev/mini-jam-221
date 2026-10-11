extends CharacterBody2D

class_name Player

@export var speed = 1

@export var health: float = 100

@export var max_health: float = 100

@export var weapon_arc: Area2D

@export var base_damage: float = 50

@export var attack_charge_bonus_damage: float = 15

@export var base_attack_knockback: float = 10

@export var basic_upgrades: BasicUpgrades

var _hit: bool = false

var _attack_charge: float = 0

# Changed by buff augments like HighNoon
var damage_multiplier: float = 1
var attack_speed_multiplier: float = 1
var speed_multiplier: float = 1

signal take_damage

signal healed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_arc.connect("area_entered", on_weapon_arc_area_entered)

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction * speed * speed_multiplier

	move_and_slide()

	var direction_to_mouse = self.position.direction_to(get_global_mouse_position())
	weapon_arc.rotation = direction_to_mouse.angle()

	if Input.is_action_pressed("attack"):
		_attack_charge = clamp(_attack_charge + delta * attack_speed_multiplier, 0, 1)


	if Input.is_action_just_released("attack"):
		weapon_arc.set_deferred("monitoring", true)
		await get_tree().create_timer(0.1).timeout
		_attack_charge = 0
		weapon_arc.set_deferred("monitoring", false)
	

func on_weapon_arc_area_entered(area: Area2D) -> void:
	var enemy = area as Enemy
	
	var direction = self.position.direction_to(enemy.position)

	var normal_hit = direction * base_attack_knockback

	var hit_bonus = direction * (_attack_charge * 20)

	enemy.hit(0.05, _get_damage() , normal_hit + hit_bonus)

	get_tree().call_group("on_hit_effects", "try_proc", enemy, 1.0, false)


func hit(hit_time: float = 0.05, damage: float = 10) -> void:
	if(_hit):
		return

	health -= damage
	
	take_damage.emit()

	# if(health <= 0):
	# 	queue_free()
	# 	return

	_hit = true

	await get_tree().create_timer(hit_time).timeout

	_hit = false


func heal(amount: float) -> void:
	health = min(health + amount, max_health)

	healed.emit()


func _get_damage() -> float:
	var damage_bonus = _attack_charge * attack_charge_bonus_damage
	return (base_damage + damage_bonus + basic_upgrades.upgrades.get("damage", 1) * basic_upgrades.damage_per_level) * damage_multiplier
