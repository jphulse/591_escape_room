class_name Player extends CharacterBody2D

@export var speed  := 300.0
@export var rotation_speed := 10.0
const JUMP_VELOCITY = -400.0
var input_enabled := true

signal vision_cone() 

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	velocity = direction * speed if input_enabled else Vector2.ZERO
	move_and_slide()
	_update_player_rotation(direction, delta)
	
func hit():
	vision_cone.emit()

func _update_player_rotation(direction: Vector2, delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	rotation = rotate_toward(rotation, direction.angle() + PI / 2, rotation_speed * delta)
