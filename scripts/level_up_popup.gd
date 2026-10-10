extends Control

# The level-up card picker.
#
# SETUP (in the editor):
#   1. Create a new scene: root node = Control, name it "LevelUpPopup", attach this script.
#      Set the root's Layout to "Full Rect".
#   2. Add children:
#        ColorRect            (Full Rect, black, alpha ~0.6 -> dims the game)
#        HBoxContainer        (centered) with 3 Buttons inside: Card1, Card2, Card3
#      Tip: a Button's text can hold several lines ("Title\nDescription\nNEW").
#      Later you can swap Buttons for nicer Panels with Labels.
#   3. Drag the 3 buttons into the `cards` array in the inspector.
#   4. IMPORTANT: select the root node -> Inspector -> Process -> Mode = Always.
#      Otherwise the popup freezes along with the rest of the game when it pauses.
#   5. Add this scene under World/CanvasLayer in world.tscn.

@export var cards: Array[Button] = []

var level_system: LevelSystem

# The choices currently shown, so a button press knows which one it was.
var _choices: Array = []


func _ready() -> void:
	# TODO: start hidden
	# TODO: find the level system:
	#       get_tree().get_first_node_in_group("level_system")
	#       (LevelSystem joins that group in its own _ready -- if this returns null,
	#        try `await get_tree().process_frame` first so it has time to join)
	# TODO: connect its level_up_ready signal to _on_level_up_ready
	# TODO: connect each card's "pressed" signal to _on_card_pressed, passing the
	#       card's index. Hint:  cards[i].pressed.connect(_on_card_pressed.bind(i))
	pass


func _on_level_up_ready(choices: Array) -> void:
	# TODO: store choices in _choices
	# TODO: for each card index i:
	#         - if there's a choice at i: show the card and set its text with
	#           _card_text(choices[i])
	#         - otherwise hide the card (there can be fewer than 3 choices)
	# TODO: show the popup
	pass


func _on_card_pressed(index: int) -> void:
	# TODO: hide the popup
	# TODO: call level_system.pick() with the choice at that index
	#       (hide FIRST: pick() might immediately open the next level-up)
	pass


# Turns a choice Dictionary into the text shown on a card.
func _card_text(choice: Dictionary) -> String:
	# TODO: return the title, the description, and "NEW" if choice["is_new"]
	#       or "Lv 2" / "Lv 3"... using choice["level"]. Use "\n" between lines.
	return ""
