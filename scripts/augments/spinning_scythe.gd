extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float
var damage: float
var distance: float 

var level: int = 1

var _already_hit: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta
	distance -= speed * delta
	if distance <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy && not _already_hit.has(area):
		var enemy = area as Enemy
		enemy.hit(0.05, damage, direction * 10)
		_already_hit[enemy] = true
