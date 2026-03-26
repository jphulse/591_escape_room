class_name Interactable extends Area2D


@export var puzzle_scene : PackedScene
@export var interaction_text := "Press E to interact"

var player_in_range := false

#TODO Connect these two methods to the correct signals
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

# TODO make interaction logic
func _physics_process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("Interacted with %s" % name)
