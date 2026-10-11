extends Control

@onready var augment1 := %Augment1
@onready var augment2 := %Augment2
@onready var augment3 := %Augment3

var augment_card = preload("res://scenes/augment_card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("/root/World/LevelSystem").connect("level_up_ready", _on_show_augments)


func _on_show_augments(choices: Array, pick_func: Callable):
	# There can be fewer than 3 choices once most augments are maxed out,
	# so only fill as many slots as there are choices.
	var slots: Array = [augment1, augment2, augment3]
	var cards: Array = []

	for i in range(min(choices.size(), slots.size())):
		if i > 0:
			await get_tree().create_timer(0.1).timeout
		var card = augment_card.instantiate() as AugmentCard
		slots[i].add_child(card)
		card.set_title(choices[i].title)
		card.set_description(choices[i].description)
		card.set_description2(choices[i].description_level_up)
		card.set_level(choices[i].level, choices[i].is_new)
		if choices[i].icon:
			card.set_icon(choices[i].icon)
		cards.append(card)

	# add buffer to not immediately click an option
	await get_tree().create_timer(1.0).timeout

	for i in range(cards.size()):
		cards[i].connect("gui_input", _on_card_input.bind(choices[i], pick_func, cards))


func _on_card_input(event: InputEvent, choice: Dictionary, pick_func: Callable, cards: Array) -> void:
	if event is InputEventMouseButton and event.pressed:
		cards.map(func(card): card.disconnect("gui_input", _on_card_input))
		
		pick_func.call(choice)
		
		cards.map(_move_picked_card.bind(choice))
		cards.map(_move_non_picked_card.bind(choice))
		
		await get_tree().create_timer(1.0).timeout
		

		augment1.get_children().all(func(child): child.queue_free())
		augment2.get_children().all(func(child): child.queue_free())
		augment3.get_children().all(func(child): child.queue_free())

func _move_picked_card(card: AugmentCard, choice: Dictionary):
	if choice.title != card.titleLabel.text:
		return
		
	var tween = get_tree().create_tween()
	tween.tween_property(card, "offset_transform_position:y", -2000, 1.0)
	
func _move_non_picked_card(card: AugmentCard, choice: Dictionary):
	if choice.title == card.titleLabel.text:
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(card, "offset_transform_position:y", 2000, 1.0)
