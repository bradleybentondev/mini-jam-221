extends Panel

class_name AugmentCard

@export var icon: TextureRect
@export var titleLabel: RichTextLabel
@export var levelLabel: Label
@export var descriptionLabel: Label
@export var descriptionLabel2: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	offset_transform_position.y += 100
	modulate = Color(1,1,1,0)

	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "offset_transform_position:y", 0, 1.0)
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
func set_title(title: String) -> void:
	titleLabel.text = title

func set_description(description: String) -> void:
	descriptionLabel.text = description
	
func set_description2(description: String) -> void:
	descriptionLabel2.text = "On upgrade: " + description

# level is the level the augment will be at after picking it.
func set_level(level: int, is_new: bool) -> void:
	if is_new:
		levelLabel.text = "NEW!"
	else:
		levelLabel.text = "Lv. %d -> %d" % [level - 1, level]

func set_icon(texture: Texture) -> void:
	icon.texture = texture

func _on_mouse_entered():
	scale *= 1.01
	pass
	
func _on_mouse_exited():
	scale = Vector2(1,1)
	pass
