extends Interactable

@export var solved_picture_scene: PackedScene

@export var linkedDoor : Node2D

var solved := false

func on_puzzle_solved() -> void:
	if solved:
		return
	
	solved = true
	linkedDoor.openAndDestroy()
	puzzle_scene = solved_picture_scene
