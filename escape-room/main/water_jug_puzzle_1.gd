extends Interactable

var is_solved = false

func on_puzzle_solved() -> void:
	is_solved = true

func _physics_process(_delta: float) -> void:
	if is_solved:
		return
	super._physics_process(_delta)
