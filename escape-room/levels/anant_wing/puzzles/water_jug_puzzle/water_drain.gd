class_name WaterDrain extends Area2D

signal water_drain_clicked(tap: WaterDrain)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			water_drain_clicked.emit(self)
