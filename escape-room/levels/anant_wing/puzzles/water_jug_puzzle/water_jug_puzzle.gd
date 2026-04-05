extends Puzzle

@onready var water_jug_list: Node = $WaterJugs
@onready var water_tap: Area2D = $WaterTap
@onready var water_drain: Area2D = $WaterDrain
@onready var timer: Timer = $Timer
@export var admire_time: float = 3.0
var selected_jug: WaterJug = null
var is_solved: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	var id: int = 0
	for jug in water_jug_list.get_children():
		if jug is WaterJug:
			jug.jug_clicked.connect(_on_jug_clicked)
			jug.id = id
			id = id + 1

func _on_jug_clicked(jug: WaterJug) -> void:
	if is_solved:
		return
	if not selected_jug:
		#print("Selected Jug: %d" % jug.id)
		selected_jug = jug
	elif selected_jug == jug:
		#print("Deselected Jug: %d" % jug.id)
		selected_jug = null
	else:
		#print("Pouring from %d to %d" % [selected_jug.id, jug.id])
		jug.add_water(selected_jug)
		selected_jug = null
		check_win_condition()

func check_win_condition() -> void:
	var count: int = 0
	for jug in water_jug_list.get_children():
		if jug is WaterJug:
			if (jug.current_capacity == 4):
				count = count + 1
	if (count == 2):
		#print("DEBUG: Jug puzzle solved!")
		is_solved = true
		timer.start(admire_time)

func _on_timer_timeout() -> void:
	solve()
