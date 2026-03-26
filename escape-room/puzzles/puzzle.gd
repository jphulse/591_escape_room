class_name Puzzle extends Node

signal request_close
signal puzzle_solved



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		request_close.emit()
	

func solve() -> void:
	puzzle_solved.emit()
