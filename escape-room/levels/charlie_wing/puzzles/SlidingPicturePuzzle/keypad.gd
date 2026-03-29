extends Puzzle

@export var correct_code := "4312"
@export var max_length := 4

@onready var display_label: Label = $UI/Panel/MarginContainer/VBoxContainer/Label
@onready var grid: GridContainer = $UI/Panel/MarginContainer/VBoxContainer/GridContainer

var current_input := ""

func _ready() -> void:
	super._ready()
	_update_display()
	
	for child in grid.get_children():
		if child is Button:
			child.pressed.connect(_on_button_pressed.bind(child))

func _on_button_pressed(button: Button) -> void:
	var value := button.text
	match value:
		"CE":
			current_input = ""
			_update_display()
		
		"Enter":
			_check_code()
		# Little Trick to match all inputs
		_:
			if current_input.length() < max_length:
				current_input += value
				_update_display()

func _update_display() -> void:
	if current_input.is_empty():
		display_label.text = "----"
	else:
		display_label.text = current_input

func _check_code() -> void:
	if current_input == correct_code:
		solve()
	else:
		current_input = ""
		display_label.text = "Wrong Code"
