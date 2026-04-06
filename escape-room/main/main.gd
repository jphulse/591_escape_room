class_name Main extends Node2D

@export var total_time := 600
@export var critical_puzzles := 2

@onready var puzzle_manager : PuzzleUI = $CanvasLayer/PuzzleUi
@onready var time_label : Label = %TimeClock
@onready var always_active : Node = $AlwaysActive

var part_two_scene : PackedScene = preload("res://main/main-part2.tscn")
var part_two_inst : StealthWorld = null

func update_time_label() -> void:
	if total_time > 0:
		@warning_ignore("integer_division")
		time_label.text = "%02d:%02d" % [total_time / 60, total_time % 60]
	else:
		get_tree().reload_current_scene()
		get_tree().paused = true
		time_label.text = "00:00"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_time_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func win() -> void:
	for child in get_children():
		child.queue_free()

func _on_interaction(puzzle_scene: PackedScene, caller: Interactable) -> void:
	if critical_puzzles >= 0 or part_two_inst:
		puzzle_manager.open_puzzle(puzzle_scene, caller)
		if part_two_inst:
			part_two_inst.set_player_input(false)

# TODO add lose logic for hitting 0 on the timer
func _on_countdown_timer_timeout() -> void:
	total_time -= 1
	update_time_label()
	
func _free_part_one() -> void:
	$AlwaysActive/CountdownTimer.queue_free()
	$CanvasLayer/WorldUI.queue_free()
	$World.queue_free()

func _setup_stealth_interactables(inst : StealthWorld) -> void:
	always_active.add_child(inst)
	for i : Node in inst.get_interactables():
		if i is Interactable:
			i.interact.connect(_on_interaction)
		else :
			push_warning("Interactable from node [%s] with specific name [%s] is not the correct type
			 change this in the editor" % [inst.name, i.name])

func _start_part_2() -> void:
	puzzle_manager.close_puzzle()
	if part_two_inst:
		part_two_inst.queue_free.call_deferred()
	part_two_inst = part_two_scene.instantiate()
	if part_two_inst.has_signal("win"):
		part_two_inst.win.connect(win)
	if part_two_inst.has_signal("resetScene"):
		part_two_inst.resetScene.connect(_start_part_2)
	_setup_stealth_interactables.call_deferred(part_two_inst)

func _on_critical_puzzle_solved(_interactable : Interactable) -> void:
	critical_puzzles -= 1
	print("Critical puzzle solved: [%d] remain" % critical_puzzles)
	if critical_puzzles <= 0 :
		_free_part_one()
		_start_part_2()

func _on_enable_player() -> void:
	if part_two_inst:
		part_two_inst.set_player_input(true)
