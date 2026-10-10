extends Node2D

class_name Player

@export var speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		position.y -= speed
		
	if Input.is_action_pressed("move_down"):
		position.y += speed
		
	if Input.is_action_pressed("move_left"):
		position.x -= speed
		
	if Input.is_action_pressed("move_right"):
		position.x += speed
