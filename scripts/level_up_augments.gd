extends Control

@onready var augment1 := %Augment1
@onready var augment2 := %Augment2
@onready var augment3 := %Augment3

var augment_card = preload("res://scenes/augment_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/World/LevelSystem").connect("level_up_ready", _on_show_augments)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_level_up_augments() -> void:
	# Implement the logic to display level-up augments here.
	pass

func _on_show_augments(choices: Array):
	print("showing")
	var card1 = augment_card.instantiate() as AugmentCard
	var card2 = augment_card.instantiate() as AugmentCard
	var card3 = augment_card.instantiate() as AugmentCard
	
	augment1.add_child(card1)
	await get_tree().create_timer(0.1).timeout
	augment2.add_child(card2)
	await get_tree().create_timer(0.1).timeout
	augment3.add_child(card3)
	
	card1.set_title(choices[0].title)
	card1.set_description(choices[0].description)
	
	card2.set_title(choices[1].title)
	card2.set_description(choices[1].description)
	
	card3.set_title(choices[2].title)
	card3.set_description(choices[2].description)
