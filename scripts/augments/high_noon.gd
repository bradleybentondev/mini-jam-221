extends Node

@export var cooldown: float = 30
@export var duration: float = 3
@export var bonus: float = 0.1 # 0.5 = +50%
@export var glow_color: Color = Color(1, 0.8, 0.2, 1)

var level: int = 1

var player: Player
var _body: Polygon2D
var _original_color: Color
var _timer: float

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	_body = player.get_node("AnimatedSprite2D")
	_original_color = _body.color
	_timer = cooldown

func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0:
		_activate()
		_timer = cooldown

func _activate() -> void:
	player.damage_multiplier += bonus
	player.attack_speed_multiplier += bonus
	player.speed_multiplier += bonus
	_body.color = glow_color

	await get_tree().create_timer(duration, false).timeout

	player.damage_multiplier -= bonus
	player.attack_speed_multiplier -= bonus
	player.speed_multiplier -= bonus
	_body.color = _original_color

func level_up() -> void:
	level += 1
	bonus += .1
	cooldown = max(5, cooldown - 7.5)
	duration += 1.5
	
