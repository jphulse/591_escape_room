# I used ChatGPT to organize this code with the exports
extends Puzzle

@export var hint_text := "Use every shape"

@export var shape_1_type := "triangle"
@export var shape_2_type := "square"
@export var shape_3_type := "circle"
@export var shape_4_type := "star"

@onready var hint_label: Label = $Label

@onready var left_pan: Area2D = $LeftPan
@onready var right_pan: Area2D = $RightPan

@onready var left_pan_sprite: Sprite2D = $LeftPan/PanSprite
@onready var right_pan_sprite: Sprite2D = $RightPan/PanSprite

@onready var left_slots := [
	$LeftPan/PanSprite/Slot1,
	$LeftPan/PanSprite/Slot2,
	$LeftPan/PanSprite/Slot3
]

@onready var right_slots := [
	$RightPan/PanSprite/Slot1,
	$RightPan/PanSprite/Slot2,
	$RightPan/PanSprite/Slot3
]

@onready var shape_pool: Node2D = $ShapePool

@onready var shape_1: Area2D = $ShapePool/Shape1
@onready var shape_2: Area2D = $ShapePool/Shape2
@onready var shape_3: Area2D = $ShapePool/Shape3
@onready var shape_4: Area2D = $ShapePool/Shape4

var shape_weights: Dictionary = {}

var selected_shape: Area2D = null

var left_shapes: Array[Area2D] = []
var right_shapes: Array[Area2D] = []

var shape_types: Dictionary = {}
var pool_positions: Dictionary = {}

var left_rest_y: float
var right_rest_y: float

func _ready() -> void:
	super._ready()
	
	hint_label.text = hint_text
	
	left_rest_y = left_pan.position.y
	right_rest_y = right_pan.position.y
	
	shape_types[shape_1] = shape_1_type
	shape_types[shape_2] = shape_2_type
	shape_types[shape_3] = shape_3_type
	shape_types[shape_4] = shape_4_type
	
	_generate_solvable_weights()
	
	pool_positions[shape_1] = shape_1.position
	pool_positions[shape_2] = shape_2.position
	pool_positions[shape_3] = shape_3.position
	pool_positions[shape_4] = shape_4.position
	
	_connect_shape(shape_1)
	_connect_shape(shape_2)
	_connect_shape(shape_3)
	_connect_shape(shape_4)
	
	left_pan.input_event.connect(_on_pan_clicked.bind(left_pan))
	right_pan.input_event.connect(_on_pan_clicked.bind(right_pan))
	
	_update_pan_visuals()
	_update_shape_positions()

# Chat Gpt helped make this puzzle 'replayable'
func _generate_solvable_weights() -> void:
	var shape_names := [
		shape_1_type,
		shape_2_type,
		shape_3_type,
		shape_4_type
	]
	
	shape_names.shuffle()
	
	var a := randi_range(1, 6)
	var b := randi_range(1, 6)
	var c := randi_range(1, 6)
	var d := a + b - c
	
	while d < 1 or d > 9:
		a = randi_range(1, 6)
		b = randi_range(1, 6)
		c = randi_range(1, 6)
		d = a + b - c
	
	shape_weights.clear()
	shape_weights[shape_names[0]] = a
	shape_weights[shape_names[1]] = b
	shape_weights[shape_names[2]] = c
	shape_weights[shape_names[3]] = d


func _connect_shape(shape: Area2D) -> void:
	shape.input_event.connect(_on_shape_clicked.bind(shape))

# Used ChatGPT to help with shape clicking
func _on_shape_clicked(_viewport: Node, event: InputEvent, _shape_idx: int, shape: Area2D) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if _is_on_left(shape):
			left_shapes.erase(shape)
			_return_shape_to_pool(shape)
			_update_after_change()
			return
		
		if _is_on_right(shape):
			right_shapes.erase(shape)
			_return_shape_to_pool(shape)
			_update_after_change()
			return
		
		_select_shape(shape)

func _on_pan_clicked(_viewport: Node, event: InputEvent, _shape_idx: int, pan: Area2D) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	
	if selected_shape == null:
		return
	
	if pan == left_pan:
		if left_shapes.size() >= left_slots.size():
			return
		
		left_shapes.append(selected_shape)
		_place_shape_on_pan(selected_shape, left_pan_sprite)
	
	elif pan == right_pan:
		if right_shapes.size() >= right_slots.size():
			return
		
		right_shapes.append(selected_shape)
		_place_shape_on_pan(selected_shape, right_pan_sprite)
	
	_deselect_shape()
	_update_after_change()

func _place_shape_on_pan(shape: Area2D, pan_sprite: Sprite2D) -> void:
	shape.reparent(pan_sprite, false)

func _return_shape_to_pool(shape: Area2D) -> void:
	shape.reparent(shape_pool, false)
	shape.position = pool_positions[shape]
	_deselect_if_same(shape)

func _update_after_change() -> void:
	_update_shape_positions()
	_update_pan_visuals()
	_check_solved()

func _update_shape_positions() -> void:
	for i in range(left_shapes.size()):
		left_shapes[i].position = left_slots[i].position
	
	for i in range(right_shapes.size()):
		right_shapes[i].position = right_slots[i].position

func _update_pan_visuals() -> void:
	var diff := _left_weight() - _right_weight()
	var offset: float = clamp(diff * 10.0, -30.0, 30.0)
	
	left_pan.position.y = left_rest_y + offset
	right_pan.position.y = right_rest_y - offset

func _left_weight() -> int:
	var total := 0
	for shape in left_shapes:
		total += _weight_of(shape)
	return total

func _right_weight() -> int:
	var total := 0
	for shape in right_shapes:
		total += _weight_of(shape)
	return total

func _weight_of(shape: Area2D) -> int:
	var shape_type = shape_types.get(shape, "")
	return shape_weights.get(shape_type, 0)

func _check_solved() -> void:
	var total_used := left_shapes.size() + right_shapes.size()
	var total_shapes := shape_types.size()
	
	if total_used == total_shapes and _left_weight() == _right_weight():
		solve()

func _select_shape(shape: Area2D) -> void:
	if selected_shape != null:
		_set_shape_selected(selected_shape, false)
	
	selected_shape = shape
	_set_shape_selected(shape, true)

func _deselect_shape() -> void:
	if selected_shape != null:
		_set_shape_selected(selected_shape, false)
	selected_shape = null

func _deselect_if_same(shape: Area2D) -> void:
	if selected_shape == shape:
		_deselect_shape()

# Chat GPT did the modulation
func _set_shape_selected(shape: Area2D, is_selected: bool) -> void:
	var sprite := shape.get_node("Sprite2D") as Sprite2D
	if sprite == null:
		return
	
	if is_selected:
		sprite.modulate = Color(1.3, 1.3, 1.3, 1.0)
	else:
		sprite.modulate = Color(1, 1, 1, 1)

func _is_on_left(shape: Area2D) -> bool:
	return shape in left_shapes

func _is_on_right(shape: Area2D) -> bool:
	return shape in right_shapes
