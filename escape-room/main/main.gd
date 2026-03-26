class_name Main extends Node2D

@onready var puzzle_manager : PuzzleUI = $CanvasLayer/PuzzleUi

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_interaction(puzzle_scene: PackedScene, caller: Interactable) -> void:
	puzzle_manager.open_puzzle(puzzle_scene, caller)
