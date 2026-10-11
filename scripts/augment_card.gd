extends Panel

@export var icon: TextureRect
@export var titleLabel: RichTextLabel
@export var descriptionLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_title(title: String) -> void:
	titleLabel.text = title

func set_description(description: String) -> void:
	descriptionLabel.text = description

func set_icon(texture: Texture) -> void:
	icon.texture = texture
