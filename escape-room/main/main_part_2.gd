extends Node2D

signal resetScene()

func _ready():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.vision_cone.connect(_on_vision_cone_enter)

func _on_vision_cone_enter():
	resetScene.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
