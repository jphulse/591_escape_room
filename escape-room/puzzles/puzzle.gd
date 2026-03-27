class_name Puzzle extends Node

signal request_close
signal puzzle_solved

@export var two_dimensional : bool = true

var closing : bool = false

func _ready() -> void:
	if two_dimensional:
		PhysicsServer2D.set_active(true)
	else:
		PhysicsServer3D.set_active(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_puzzle()

func _exit_tree() -> void:
	if not two_dimensional:
		PhysicsServer3D.set_active(false)

func solve() -> void:
	if not closing:
		closing = true
		puzzle_solved.emit()

func close_puzzle() -> void:
	if not closing:
		closing = true
		request_close.emit()
		
