extends Node2D

@export var max_bounces := 100.0
@export var max_length  := 1000.0
@export var cast_speed  := 100.0
@export var start_dir   := Vector2.UP

@onready var ray = $LaserStart
@onready var line = $Line2D
var max_cast_to
var starting_rotation = 0.0 # Laser should point upwards in one direction
var lasers := [] # list of the bouncing lasers

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var screen_dim = get_viewport_rect()
	global_position = Vector2(screen_dim.size[0] / 2, screen_dim.size[1] / 2)
	
	#lasers.append($LaserStart)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	line.clear_points()
	
	line.add_point(Vector2.ZERO)
	ray.global_position = line.global_position
	var line_to_mouse = get_global_mouse_position() - line.global_position
	#ray.target_position = (get_global_mouse_position() - line.global_position).normalized() * max_length
	ray.target_position = (line_to_mouse).normalized() * line_to_mouse.length()
	ray.force_raycast_update()
	
	while true:
		if not ray.is_colliding():
			var end_point = ray.global_position + ray.target_position
			line.add_point(line.to_local(end_point))
			break
