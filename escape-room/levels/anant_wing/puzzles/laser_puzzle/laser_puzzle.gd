class_name LaserPuzzle extends Puzzle

@onready var laser_target = $LaserTarget
@onready var timer = $AdmirePuzzleTimer
@export var puzzle_completed = false
var admiration_time : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	laser_target.target_hit.connect(_on_laser_target_hit)

func _on_laser_target_hit():
	if puzzle_completed:
		return
	puzzle_completed = true
	timer.start(admiration_time)

func _on_admire_puzzle_timer_timeout() -> void:
	solve()
