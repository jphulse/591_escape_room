extends Interactable

@export var solved_picture_scene: PackedScene

var solved := false

func on_puzzle_solved() -> void:
	if solved:
		return
	
	solved = true
	puzzle_scene = solved_picture_scene
