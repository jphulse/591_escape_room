class_name Interactable extends Area2D

@warning_ignore("unused_signal")
signal interact(puzzle_scene : PackedScene, caller : Interactable)

@export var puzzle_scene : PackedScene
@export var interaction_text := "Press E to interact"

var player_in_range := false

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		player_in_range = true

func _on_body_exit(body : Node2D) -> void:
	if body is Player:
		player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(puzzle_scene != null, 
			"Puzzle scene in node with name [%s] was null, this should not happen set this value 
			in the editor" % name
	)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exit)

# TODO make interaction logic
func _physics_process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Interacted with %s" % name)
		interact.emit(puzzle_scene, self)


func on_puzzle_solved() -> void:
	print("Puzzle solved")
