extends Puzzle

@export var symbol_1: Texture2D
@export var symbol_2: Texture2D
@export var symbol_3: Texture2D
@export var riddle: String

@onready var label: Label = $UI/Panel/MarginContainer/VBoxContainer/Label
@onready var tex1: TextureRect = $UI/Panel/MarginContainer/VBoxContainer/Symbols/Symbol1
@onready var tex2: TextureRect = $UI/Panel/MarginContainer/VBoxContainer/Symbols/Symbol2
@onready var tex3: TextureRect = $UI/Panel/MarginContainer/VBoxContainer/Symbols/Symbol3

func _ready() -> void:
	super._ready()
	label.text = riddle
	tex1.texture = symbol_1
	tex2.texture = symbol_2
	tex3.texture = symbol_3
