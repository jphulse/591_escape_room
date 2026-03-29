class_name LaserPuzzle extends Puzzle

@onready var laser_target = $LaserTarget
@export var puzzle_completed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	laser_target.target_hit.connect(_on_laser_target_hit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_laser_target_hit():
	if puzzle_completed:
		return
	print("Laser Puzzle Completed!")
	puzzle_completed = true
	emit_signal("puzzle_solved")
