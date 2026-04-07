extends Interactable

var is_solved = false
signal critical_interactable_solved(caller : Interactable)

func on_puzzle_solved() -> void:
	super.on_puzzle_solved()
	critical_interactable_solved.emit(self)
	is_solved = true

func _physics_process(_delta: float) -> void:
	if is_solved:
		return
	super._physics_process(_delta)
