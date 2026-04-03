extends Puzzle


@export_group("Shader info")
@export_range(0.0, 1.0) var darkness_mult : float = .5

@onready var top_sprite : SimonButton = $TopSprite
@onready var right_sprite : SimonButton = $RightSprite
@onready var bottom_sprite : SimonButton = $BottomSprite
@onready var left_sprite : SimonButton = $LeftSprite

func _ready() -> void:
	top_sprite.darkness_mult = darkness_mult
	right_sprite.darkness_mult = darkness_mult
	left_sprite.darkness_mult = darkness_mult
	bottom_sprite.darkness_mult = darkness_mult
	top_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	right_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	bottom_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	left_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	
# Called when the node enters the scene tree for the first time.
