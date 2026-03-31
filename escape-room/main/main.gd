class_name Main extends Node2D

@export var total_time := 600
@export var critical_puzzles := 2

@onready var puzzle_manager : PuzzleUI = $CanvasLayer/PuzzleUi
@onready var time_label : Label = %TimeClock
@onready var always_active : Node = $AlwaysActive

var part_two_scene : PackedScene = preload("res://main/main-part2.tscn")
var part_two_inst : Node2D = null

func update_time_label() -> void:
	if total_time > 0:
		@warning_ignore("integer_division")
		time_label.text = "%02d:%02d" % [total_time / 60, total_time % 60]
	else:
		time_label.text = "00:00"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_time_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_interaction(puzzle_scene: PackedScene, caller: Interactable) -> void:
	if critical_puzzles >= 0:
		puzzle_manager.open_puzzle(puzzle_scene, caller)

# TODO add lose logic for hitting 0 on the timer
func _on_countdown_timer_timeout() -> void:
	total_time -= 1
	update_time_label()
	
func _free_part_one() -> void:
	$AlwaysActive/CountdownTimer.queue_free()
	$CanvasLayer/WorldUI.queue_free()
	$World.queue_free()

func _start_part_2() -> void:
	if part_two_inst:
		part_two_inst.queue_free()
	part_two_inst = part_two_scene.instantiate()
	if part_two_inst.has_signal("resetScene"):
		part_two_inst.resetScene.connect(_start_part_2)
	always_active.add_child(part_two_inst)

func _on_critical_puzzle_solved(_interactable : Interactable) -> void:
	critical_puzzles -= 1
	print("Critical puzzle solved: [%d] remain" % critical_puzzles)
	if critical_puzzles <= 0 :
		_free_part_one()
		_start_part_2()
