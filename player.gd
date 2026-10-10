extends Node2D

class_name Player

@export var speed = 1

@export var weapon_arc: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	weapon_arc.connect("body_entered", on_weapon_arc_body_entered)
	
func _physics_process(delta: float) -> void:

	if Input.is_action_pressed("move_up"):
		position.y -= speed
		
	if Input.is_action_pressed("move_down"):
		position.y += speed
		
	if Input.is_action_pressed("move_left"):
		position.x -= speed
		
	if Input.is_action_pressed("move_right"):
		position.x += speed
		

	var direction_to_mouse = self.position.direction_to(get_global_mouse_position())
	weapon_arc.rotation = direction_to_mouse.angle()

	if Input.is_action_just_pressed("attack"):
		weapon_arc.set_deferred("monitoring", true)
		await get_tree().create_timer(0.1).timeout
		weapon_arc.set_deferred("monitoring", false)

func on_weapon_arc_body_entered(body: Node2D) -> void:
	print(body.name)

	var enemy = body as Enemy

	enemy.hit(0.05, 50)
	enemy.apply_central_impulse(self.position.direction_to(enemy.position) * enemy.speed * 2)
