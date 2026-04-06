class_name StealthWorld extends Node2D

signal resetScene()
signal win

@onready var interactables : Node2D = $Interactables
@onready var player : Player = $Player

func _ready():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.vision_cone.connect(_on_vision_cone_enter)
	player.vision_cone.connect(_on_vision_cone_enter)

func _on_vision_cone_enter():
	resetScene.emit()

func set_player_input(enable : bool = true) -> void:
	$Player.input_enabled = enable

func get_interactables() -> Array[Node]:
	return interactables.get_children() as Array[Node]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_escape_area_body_entered(body: Node2D) -> void:
	if body is Player:
		win.emit()
