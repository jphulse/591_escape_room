extends Interactable

signal critical_interactable_solved(caller : Interactable)



func on_puzzle_solved() -> void:
	super.on_puzzle_solved()
	critical_interactable_solved.emit(self)
