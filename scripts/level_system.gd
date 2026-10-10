extends Node

class_name LevelSystem

# HOW IT CONNECTS:
#   enemy dies -> react_to_kill() -> xp goes up -> enough? -> _level_up()
#   -> pause game -> emit level_up_ready(choices) -> popup shows cards
#   -> player clicks -> popup calls pick(choice) -> augment added/leveled -> unpause
#
# The popup (level_up_popup.gd) only ever uses the two signals and pick().


# UI listens to this to redraw the XP bar.
signal xp_changed(xp: float, xp_to_next: float, level: int)

# Popup listens to this. choices is an Array of Dictionaries shaped like:
# { "id": "burn", "title": "Burning Effect", "description": "...", "is_new": true, "level": 1 }
signal level_up_ready(choices: Array)


var xp: float = 0
var level: int = 1
var xp_to_next: float = 8

# How many level-ups are waiting to be shown (one kill can give two levels).
var _pending_level_ups: int = 0

# True while the popup is open, so a second popup doesn't open on top of it.
var _choosing: bool = false

var player: Player

# id -> the augment node on the player, e.g. { "scythe_throw": <ScytheThrowAugment node> }
var owned: Dictionary = {}

# Every augment the game can offer. Fill in the rest (see the table in
# docs/xp-levelup-assignment.md). Check each scene path exists in scenes/augments/.
var catalog: Array = [
	{
		"id": "scythe_throw",
		"title": "Scythe Throw",
		"description": "Throws a scythe at the closest enemy",
		"scene": preload("res://scenes/augments/scythe_throw_augment.tscn"),
		"max_level": 5,
	},
	{
		"id": "corpse_explosion",
		"title": "Corpse Explosion",
		"description": "Explodes a corpse, damaging nearby enemies",
		"scene": preload("res://scenes/augments/corpse_explosion.tscn"),
		"max_level": 5,
	},
	{
		"id": "sun_beam_blast",
		"title": "Sun Beam Blast",
		"description": "Shoots a beam of sunlight, damaging enemies in its path",
		"scene": preload("res://scenes/augments/sun_beam_blast_augment.tscn"),
		"max_level": 3,
	},
	{
		"id": "vampyric_suck",
		"title": "Vampyric Suck",
		"description": "Absorbs health from enemies, healing the player",
		"scene": preload("res://scenes/augments/vampyric_suck.tscn"),
		"max_level": 5,
	},
	{
		"id": "high_noon",
		"title": "High Noon",
		"description": "Energized by the power of the sun, allowing for rapid attacks",
		"scene": preload("res://scenes/augments/high_noonselfbuff.tscn"),
		"max_level": 3,
	},
	{
		"id": "stun",
		"title": "Stun",
		"description": "Stuns enemies for a short duration",
		"scene": preload("res://scenes/augments/stun.tscn"),
		"max_level": 5
	},
	{
		"id": "burning",
		"title": "Burning Effect",
		"description": "Sets enemies on fire, dealing damage over time",
		"scene": preload("res://scenes/augments/burn.tscn"),
		"max_level": 5
	},
	{
		"id": "slow",
		"title": "Slow Effect",
		"description": "Slows enemies, reducing their movement speed",
		"scene": preload("res://scenes/augments/slow.tscn"),
		"max_level": 5
	}
]


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
	# TODO: if the popup is already open (_choosing) or nothing is waiting, return
	# TODO: subtract 1 from _pending_level_ups
	# TODO: build the choices with _make_choices()
	# TODO: if there are no choices (everything maxed): heal the player a bit
	#       instead, then return (don't pause)
	# TODO: set _choosing to true
	# TODO: pause the game:  get_tree().paused = true
	# TODO: emit level_up_ready with the choices
	pass


# Returns up to 3 random choice dictionaries (shape is at the top of this file).
func _make_choices() -> Array:
	var choices: Array = []

	# TODO: copy the catalog (catalog.duplicate()) and shuffle() the copy
	# TODO: for each entry in the shuffled copy:
	#         - stop once you have 3 choices
	#         - if it's owned and its level is already entry["max_level"], skip it
	#           (owned[id].level tells you its current level)
	#         - otherwise append a Dictionary with:
	#             id, title, description  -> copied from the entry
	#             is_new                  -> true if the id is NOT in owned
	#             level                   -> 1 if new, otherwise current level + 1

	return choices


# The popup calls this when a card is clicked.
func pick(choice: Dictionary) -> void:
	# TODO: if choice["is_new"]:
	#         - find the catalog entry with the same id (use _find_entry below)
	#         - instantiate its scene
	#         - add it as a child of the player
	#         - store it in owned under its id
	#       else:
	#         - call level_up() on owned[choice["id"]]
	# TODO: set _choosing back to false
	# TODO: unpause the game:  get_tree().paused = false
	# TODO: call _show_next_level_up() (in case one kill gave two levels)
	pass


# Helper: returns the catalog entry whose "id" matches, or an empty Dictionary.
func _find_entry(id: String) -> Dictionary:
	# TODO: loop over catalog, return the entry whose "id" == id
	return {}


# AUGMENT LEVELS (Task 8) -- every augment script needs:
#
#   var level: int = 1
#
#   func level_up() -> void:
#       level += 1
#       # make its numbers better, e.g. for scythe_throw_augment.gd:
#       damage *= 1.25
#       cooldown *= 0.85
#
# Suggested numbers per augment are in docs/xp-levelup-assignment.md.
#
# GOTCHA: high_noon.gd uses create_timer(duration), which keeps counting while
# the game is paused. Change it to create_timer(duration, false) so the buff
# doesn't run out while you're picking a card.
