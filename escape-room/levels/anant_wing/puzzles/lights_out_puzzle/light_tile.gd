class_name LightTile extends StaticBody2D

@onready var color_rect: ColorRect = $ColorRect
@onready var border_rect: ReferenceRect = $ReferenceRect
var is_on: bool = false
var row: int = -1
var col: int = -1
var id: int = -1

signal tile_clicked(tile: LightTile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_color(is_on)
	border_rect.editor_only = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass

func set_state(state: bool) -> void:
	is_on = state
	update_color(is_on)

func update_state():
	is_on = !is_on
	update_color(is_on)

func update_color(state: bool) -> void:
	color_rect.color = Color.WHITE if state else Color(0.5, 0.5, 0.5, 1.0)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			tile_clicked.emit(self)
