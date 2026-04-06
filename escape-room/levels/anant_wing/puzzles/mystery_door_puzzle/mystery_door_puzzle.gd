class_name MysteryDoorPuzzle extends Puzzle

@onready var level_label: Label = $LevelLabel
@onready var doors: Node = $Doors
@onready var timer: Timer = $Timer
@export var sequence_count: int = 5
@export var admire_time: float = 3.0
var correct_sequence: Array = []
var current_level: int = 0
var is_solved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	create_door_sequence()
	update_level_label()
	print("Correct Door Sequence: ", correct_sequence)

func create_door_sequence() -> void:
	var count: int = 0
	for door in doors.get_children():
		door.id = count
		door.door_clicked.connect(_on_door_clicked)
		count = count + 1
	
	for i in range(sequence_count):
		var correct_door_id = randi_range(0, 2)
		correct_sequence.append(correct_door_id)
		
func update_level_label():
	if current_level < sequence_count:
		level_label.text = "Level: %d of %d"  % [current_level + 1, sequence_count]
	else:
		level_label.text = "Complete!"

func _on_door_clicked(door: MysteryDoor) -> void:
	#print("Clicked on door: %d" % door.id)
	if is_solved:
		return
	if door.id == correct_sequence[current_level]:
		current_level = current_level + 1
	else:
		current_level = 0
	update_level_label()
	check_win_condition()

func check_win_condition():
	if current_level == sequence_count:
		#print("Mystery Doors Puzzle Solved!")
		is_solved = true
		timer.start(admire_time)

func _on_timer_timeout() -> void:
	solve()
