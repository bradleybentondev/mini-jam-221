extends Node

class_name LevelSystem

# UI listens to this to redraw the XP bar.
signal xp_changed(xp: float, xp_to_next: float, level: int)

# Popup listens to this. choices is an Array of Dictionaries shaped like:
# { "id": "burn", "title": "Burning Effect", "description": "...", "icon": <Texture2D or null>, "is_new": true, "level": 1 }
signal level_up_ready(choices: Array, pick_func: Callable)


var xp: float = 0
var level: int = 1
var xp_to_next: float = 3

# Scales all XP from kills. Lower = slower leveling (0.5 = half speed).
@export var xp_gain_multiplier: float = 0.5

# How many level-ups are waiting to be shown (one kill can give two levels).
var _pending_level_ups: int = 0

# True while the popup is open, so a second popup doesn't open on top of it.
var _choosing: bool = false

var player: Player

# id -> the augment node on the player, e.g. { "scythe_throw": <ScytheThrowAugment node> }
var owned: Dictionary = {}

# Every augment the game can offer.
var catalog: Array = [
	{
		"id": "scythe_throw",
		"title": "Scythe Throw",
		"description": "Throws a scythe at the closest enemy",
		"scene": "res://scenes/augments/scythe_throw_augment.tscn",
		"max_level": 5,
		"icon": preload("res://art/AUGMENT PICTURES/scythethrow.png"),
	},
	{
		"id": "corpse_explosion",
		"title": "Corpse Explosion",
		"description": "Explodes a corpse, damaging nearby enemies",
		"scene": "res://scenes/augments/corpse_explosion.tscn",
		"max_level": 5,
		"icon": preload("res://art/AUGMENT PICTURES/corpseexplosion.png"),
	},
	{
		"id": "sun_beam_blast",
		"title": "Sun Beam Blast",
		"description": "Shoots a beam of sunlight, damaging enemies in its path",
		"scene": "res://scenes/augments/sun_beam_blast_augment.tscn",
		"max_level": 3,
		"icon": preload("res://art/AUGMENT PICTURES/sunbeam.png"),
	},
	{
		"id": "vampyric_suck",
		"title": "Vampyric Suck",
		"description": "Absorbs health from enemies, healing the player",
		"scene": "res://scenes/augments/vampyric_suck.tscn",
		"max_level": 5,
		"icon": preload("res://art/AUGMENT PICTURES/suck.png"),
	},
	{
		"id": "high_noon",
		"title": "High Noon",
		"description": "Energized by the power of the sun, allowing for rapid attacks",
		"scene": "res://scenes/augments/high_noonselfbuff.tscn",
		"max_level": 3,
		"icon": preload("res://art/AUGMENT PICTURES/highnoon.png"),
	},
	{
		"id": "stun",
		"title": "Stun",
		"description": "Stuns enemies for a short duration",
		"scene": "res://scenes/augments/stun.tscn",
		"max_level": 5,
		"icon": preload("res://art/AUGMENT PICTURES/stun.png"),
	},
	{
		"id": "burning",
		"title": "Burning Effect",
		"description": "Sets enemies on fire, dealing damage over time",
		"scene": "res://scenes/augments/burn.tscn",
		"max_level": 5,
		"icon": preload("res://art/AUGMENT PICTURES/burn.png"),
	},
	{
		"id": "slow",
		"title": "Slow Effect",
		"description": "Slows enemies, reducing their movement speed",
		"scene": "res://scenes/augments/slow.tscn",
		"max_level": 5,
		"icon": preload("res://art/AUGMENT PICTURES/slow.png"),
	}
]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("level_up_key"):
		print("showing level up")
		_pending_level_ups += 1
		_show_next_level_up()


func _ready() -> void:
	add_to_group("kill_listeners")
	add_to_group("level_system")
	player = get_parent().get_node("Player")


# Called by enemy.gd every time an enemy dies.
func react_to_kill(enemy: Enemy) -> void:
	xp += enemy.xp_value * xp_gain_multiplier
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next *= 1.5
		_pending_level_ups += 1
	emit_signal("xp_changed", xp, xp_to_next, level)
	_show_next_level_up()



# Opens the popup for one waiting level-up, if there is one and none is open.
func _show_next_level_up() -> void:
	if _choosing or _pending_level_ups <= 0:
		SignalBus.emit_signal("paused", false)
		return
	_pending_level_ups -= 1
	var choices = _make_choices()
	# Everything is maxed out, so heal instead and move on to the next waiting level-up.
	if choices.is_empty():
		player.heal(10)
		_show_next_level_up()
		return
	_choosing = true
	SignalBus.emit_signal("paused", true)
	emit_signal("level_up_ready", choices, pick)

# Returns up to 3 random choice dictionaries (shape is at the top of this file).
func _make_choices() -> Array:
	var choices: Array = []
	var pool: Array = catalog.duplicate()
	pool.shuffle()
	for entry in pool:
		if choices.size() >= 3:
			break
		var id = entry["id"]
		if owned.has(id) and owned[id].level >= entry["max_level"]:
			continue
		var choice: Dictionary = {
			"id": id,
			"title": entry["title"],
			"description": entry["description"],
			"icon": entry["icon"],
			"is_new": not owned.has(id),
			"level": 1 if not owned.has(id) else owned[id].level + 1
		}
		choices.append(choice)
	return choices


# The popup calls this when a card is clicked.
func pick(choice: Dictionary) -> void:
	if choice["is_new"]:
		var entry = _find_entry(choice["id"])
		var augment_scene = load(entry["scene"])
		var augment_instance = augment_scene.instantiate()
		player.add_child(augment_instance)
		owned[choice["id"]] = augment_instance
	else:
		owned[choice["id"]].level_up()
	_choosing = false
	_show_next_level_up()


# HELPERS
func _find_entry(id: String) -> Dictionary:
	for entry in catalog:
		if entry["id"] == id:
			return entry
	return {}
