extends Puzzle

@export var solved_image: Texture2D

@onready var texture_rect: TextureRect = $Control/Panel/MarginContainer/TextureRect

func _ready() -> void:
	super._ready()
	texture_rect.texture = solved_image
