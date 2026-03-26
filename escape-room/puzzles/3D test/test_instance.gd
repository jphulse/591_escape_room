extends MeshInstance3D
@export var speed := 25.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var move_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed * delta
	global_position.x += move_vector.x
	global_position.z += move_vector.y


func _on_static_body_3d_mouse_entered() -> void:
	print("MOUSE ENTERED ")
