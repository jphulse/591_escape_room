class_name Laser extends Node2D

#@onready var ray = $LaserStart
@onready var line = $LaserLine
@onready var particles = $LaserParticle

@export var max_bounces := 50
@export var max_length  := 300.0
@export var cast_speed  := 100.0
@export var start_dir   := Vector2.UP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_dim = get_viewport_rect()
	global_position = Vector2(screen_dim.size[0] / 2, screen_dim.size[1] / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_cast_laser()

func _cast_laser() -> void:
	var space_state := get_world_2d().direct_space_state
	var origin := global_position
	var direction = get_global_mouse_position() - line.global_position
	var line_points := [to_local(origin)]

	# Limit the ray to a maximum number of bounces
	for i in range(max_bounces + 1):
		# Create a ray from the specified origin and vector
		var query := PhysicsRayQueryParameters2D.create(origin, origin + direction * max_length)
		# Get the result of the ray and check to see that it intersects with
		var result := space_state.intersect_ray(query)

		# If the ray does not intersect, break to cancel additional bounces
		if result.is_empty():
			line_points.append(to_local(origin + direction * max_length))
			break

		# Otherwise, add the collision point to the list of points
		line_points.append(to_local(result.position))

		# If the collision is not a mirror, then we stop the laser
		if not result.collider is Mirror:
			particles.global_position = result.position
			particles.emitting = true
			break

		# Assign the direction and origin of the next ray
		direction = direction.bounce(result.normal)
		origin = result.position + direction * 0.0001

	# Give the line the list of points
	line.points = line_points
