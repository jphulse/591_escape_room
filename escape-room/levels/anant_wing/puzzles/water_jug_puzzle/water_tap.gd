class_name WaterTap extends Area2D

signal water_tap_clicked(tap: WaterTap)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			water_tap_clicked.emit(self)
