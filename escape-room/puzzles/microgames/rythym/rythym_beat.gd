class_name RythymBeat extends Area2D

@export var score: int = 1
@export var velocity :Vector2 = Vector2(0, 100.0)


var can_be_hit := false

# Move over by velocity pixels every second
func _physics_process(delta: float) -> void:
	position += velocity * delta
