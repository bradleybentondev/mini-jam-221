extends Node

class_name LevelSystem

# UI listens to this to redraw the XP bar.
signal xp_changed(xp: float, xp_to_next: float, level: int)

# Popup listens to this. choices is an Array of Dictionaries shaped like:
# { "id": "burn", "title": "Burning Effect", "description": "...", "is_new": true, "level": 1 }
signal level_up_ready(choices: Array)


var xp: float = 0
var level: int = 1
var xp_to_next: float = 3

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
	},
	{
		"id": "corpse_explosion",
		"title": "Corpse Explosion",
		"description": "Explodes a corpse, damaging nearby enemies",
		"scene": "res://scenes/augments/corpse_explosion.tscn",
		"max_level": 5,
	},
	{
		"id": "sun_beam_blast",
		"title": "Sun Beam Blast",
		"description": "Shoots a beam of sunlight, damaging enemies in its path",
		"scene": "res://scenes/augments/sun_beam_blast_augment.tscn",
		"max_level": 3,
	},
	{
		"id": "vampyric_suck",
		"title": "Vampyric Suck",
		"description": "Absorbs health from enemies, healing the player",
		"scene": "res://scenes/augments/vampyric_suck.tscn",
		"max_level": 5,
	},
	{
		"id": "high_noon",
		"title": "High Noon",
		"description": "Energized by the power of the sun, allowing for rapid attacks",
		"scene": "res://scenes/augments/high_noonselfbuff.tscn",
		"max_level": 3,
	},
	{
		"id": "stun",
		"title": "Stun",
		"description": "Stuns enemies for a short duration",
		"scene": "res://scenes/augments/stun.tscn",
		"max_level": 5
	},
	{
		"id": "burning",
		"title": "Burning Effect",
		"description": "Sets enemies on fire, dealing damage over time",
		"scene": "res://scenes/augments/burn.tscn",
		"max_level": 5
	},
	{
		"id": "slow",
		"title": "Slow Effect",
		"description": "Slows enemies, reducing their movement speed",
		"scene": "res://scenes/augments/slow.tscn",
		"max_level": 5
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
	xp += enemy.xp_value
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = 5 + level * 3
		_pending_level_ups += 1
	emit_signal("xp_changed", xp, xp_to_next, level)
	_show_next_level_up()



# Opens the popup for one waiting level-up, if there is one and none is open.
func _show_next_level_up() -> void:
	if _choosing or _pending_level_ups <= 0:
		return
	_pending_level_ups -= 1
	var choices = _make_choices()
	if choices.is_empty():
		player.heal(10) 
		return 
	_choosing = true
	#get_tree().paused = true
	emit_signal("level_up_ready", choices)

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
	get_tree().paused = false
	_show_next_level_up()


# HELPERS
func _find_entry(id: String) -> Dictionary:
	for entry in catalog:
		if entry["id"] == id:
			return entry
	return {}
