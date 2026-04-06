extends Area2D

var player_in_range := false

@export var doorGroup : Node2D
@export var index : int

func _on_body_entered(body : Node2D) -> void:
	if body is Player:
		player_in_range = true

func _on_body_exit(body : Node2D) -> void:
	if body is Player:
		player_in_range = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exit)

# TODO make interaction logic
func _physics_process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("interact"):
		doorGroup.openDoor(index)
		print("Interacted with %s" % name)
