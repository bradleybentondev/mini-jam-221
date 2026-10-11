extends Panel

class_name AugmentCard

@export var icon: TextureRect
@export var titleLabel: RichTextLabel
@export var descriptionLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	offset_transform_position.y += 100
	modulate = Color(1,1,1,0)

	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "offset_transform_position:y", 0, 1.0)
	tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)

func set_title(title: String) -> void:
	titleLabel.text = title

func set_description(description: String) -> void:
	descriptionLabel.text = description

func set_icon(texture: Texture) -> void:
	icon.texture = texture
