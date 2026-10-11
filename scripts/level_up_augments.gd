extends Control

@onready var augment1 := %Augment1
@onready var augment2 := %Augment2
@onready var augment3 := %Augment3

var augment_card = preload("res://scenes/augment_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/World/LevelSystem").connect("level_up_ready", _on_show_augments)


func _on_show_augments(choices: Array, pick_func: Callable):
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
	if choices[0].icon:
		card1.set_icon(choices[0].icon)
	
	card2.set_title(choices[1].title)
	card2.set_description(choices[1].description)
	if choices[1].icon:
		card2.set_icon(choices[1].icon)
	
	card3.set_title(choices[2].title)
	card3.set_description(choices[2].description)
	if choices[2].icon:
		card3.set_icon(choices[2].icon)

	# add buffer to not immediately click an option
	await get_tree().create_timer(1.0).timeout

	card1.connect("gui_input", Callable(self, "_on_card_input").bind(choices[0], pick_func))
	card2.connect("gui_input", Callable(self, "_on_card_input").bind(choices[1], pick_func))
	card3.connect("gui_input", Callable(self, "_on_card_input").bind(choices[2], pick_func))

func _on_card_input(event: InputEvent, choice: Dictionary, pick_func: Callable) -> void:
	if event is InputEventMouseButton and event.pressed:
		pick_func.call(choice)

		augment1.get_children().all(func(child): child.queue_free())
		augment2.get_children().all(func(child): child.queue_free())
		augment3.get_children().all(func(child): child.queue_free())
