class_name WaterJug extends StaticBody2D

@export var current_capacity : int = 0
@export var maximum_capacity : int = 5

@onready var sprite: Sprite2D = $Sprite2D
@onready var fill_rect: ColorRect = $ColorRect
@onready var current_volume_label: Label = $CurrentVolume
@onready var maximum_volume_label: Label = $MaxVolume
@onready var border_rect: ReferenceRect = $ReferenceRect

var id: int = 0
var base_y: float = 0.0
var max_fill_height: float = 0.0
signal jug_clicked(jug: WaterJug)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_volume_label.text = "%d" % current_capacity
	maximum_volume_label.text = "Max: %d" % maximum_capacity
	
	var sprite_rect: Rect2 = sprite.get_rect()
	var scaled_size := sprite_rect.size * sprite.scale
	var scaled_pos := sprite_rect.position * sprite.scale

	max_fill_height = scaled_size.y
	base_y = scaled_pos.y + scaled_size.y

	fill_rect.size.x = scaled_size.x
	fill_rect.position.x = scaled_pos.x
	
	update_fill()
	set_border(false)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			jug_clicked.emit(self)

func update_current_capacity_text(new_current: int) -> void:
	current_volume_label.text = "%d" % new_current
	update_fill()

func set_current_capacity(new_capacity: int) -> void:
	current_capacity = new_capacity
	update_current_capacity_text(current_capacity)
	update_fill()

func add_water(water_jug: WaterJug) -> void:
	var remaining_capacity := maximum_capacity - current_capacity
	var transfer_amount: int = min(water_jug.current_capacity, remaining_capacity)
	current_capacity = current_capacity + transfer_amount
	water_jug.current_capacity = water_jug.current_capacity - transfer_amount
	
	update_current_capacity_text(current_capacity)
	water_jug.update_current_capacity_text(water_jug.current_capacity)

func update_fill() -> void:
	var fill_ratio := float(current_capacity) / float(maximum_capacity)
	fill_rect.size.y = max_fill_height * fill_ratio
	fill_rect.position.y = base_y - fill_rect.size.y

func set_border(border_is_on: bool) -> void:
	if border_is_on:
		border_rect.editor_only = false
	else:
		border_rect.editor_only = true
