extends Node

class_name BasicUpgrades

@export var damage_per_level: float = 5
@export var knockback_per_level: float = 5
@export var range_per_level: float = 10
@export var attack_speed_per_level: float = 10

@export var upgrades: Dictionary = {
	"damage": 1,
	"knockback": 1,
	"range": 1
}
