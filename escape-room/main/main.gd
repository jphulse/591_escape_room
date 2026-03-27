class_name Main extends Node2D

@export var total_time := 600

@onready var puzzle_manager : PuzzleUI = $CanvasLayer/PuzzleUi
@onready var time_label : Label = %TimeClock


func update_time_label() -> void:
	@warning_ignore("integer_division")
	time_label.text = "%02d:%02d" % [total_time / 60, total_time % 60]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_time_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_interaction(puzzle_scene: PackedScene, caller: Interactable) -> void:
	puzzle_manager.open_puzzle(puzzle_scene, caller)


func _on_countdown_timer_timeout() -> void:
	total_time -= 1
	update_time_label()
	
