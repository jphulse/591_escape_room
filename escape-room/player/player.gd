class_name Player extends CharacterBody2D


@export var speed  := 300.0
const JUMP_VELOCITY = -400.0

var input_enabled := true

func _physics_process(_delta: float) -> void:
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed if input_enabled else Vector2.ZERO
	move_and_slide()
	
