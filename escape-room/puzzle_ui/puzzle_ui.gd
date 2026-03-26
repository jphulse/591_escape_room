class_name PuzzleUI extends Control

@onready var panel : Panel = $Panel
@onready var viewport_container : SubViewportContainer = $Panel/SubViewportContainer
@onready var viewport : SubViewport = $Panel/SubViewportContainer/SubViewport

var current_puzzle : Node = null
var current_source : Interactable = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	viewport.size = viewport_container.size


func open_puzzle(scene : PackedScene, source : Interactable = null) -> void:
	if current_puzzle != null:
		return
	current_source = source
	visible = true
	get_tree().paused = true
	current_puzzle = scene.instantiate()
	current_puzzle.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	viewport.add_child(current_puzzle)
	
	if current_puzzle.has_signal("request_close"):
		current_puzzle.request_close.connect(close_puzzle)
	
	if current_puzzle.has_signal("puzzle_solved"):
		current_puzzle.puzzle_solved.connect(_on_puzzle_solved)

func close_puzzle() -> void:
	if current_puzzle:
		current_puzzle.queue_free()
		current_puzzle = null
	
	current_source = null
	visible = false
	get_tree().paused = false

func _on_puzzle_solved() -> void:
	if current_source and current_source.has_method("on_puzzle_solved"):
		current_source.on_puzzle_solved()
	close_puzzle()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
