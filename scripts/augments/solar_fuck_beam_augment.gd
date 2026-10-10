extends Node2D

@export var beam_length: float = 1000.0
@export var beam_width: float = 10.0
@export var beam_color: Color = Color(1, 1, 0, 1) # Yellow color
@export var beam_duration: float = 0.5 # Duration of the beam in seconds
@export var beam_damage: float = 10.0 # Damage dealt by the beam
@export var beam_cooldown: float = 10 # Cooldown time before the beam can be fired again
@export var charge_time: float = 2.0 # Time it takes to charge the beam

func _process(delta: float) -> void:
    pass
func _hit_enemy() -> void:
    pass

   