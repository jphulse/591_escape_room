class_name DinoObstacle extends Area2D


@export var velocity := Vector2.LEFT * 200



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta

func get_shape() -> RectangleShape2D:
	return $CollisionShape2D.shape
