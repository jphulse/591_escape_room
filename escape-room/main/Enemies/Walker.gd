extends CharacterBody2D

@export var markers: Array[Marker2D]
@export var waypoint: Array[bool]
@export var speed: float = 200
@export var waitTime: float = 5

@onready var timer = $WaitTimer

signal vision_cone() 

var currentMarkerIndex = 0
var startPosition:Vector2
var waiting = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(markers.size() == waypoint.size(), "Markers and waypoint lists must be the same size")
	assert(markers.size() > 0, "Enemies need markerpoints to patrol")
	startPosition = position
	print(startPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if waiting:
		rotation = rotateTowardsDirection(markers[currentMarkerIndex].direction, rotation, 5, delta)
	else:
		checkProximityToPoint()
		move_and_slide()
		rotation = rotateTowardsPosition(markers[currentMarkerIndex].position, rotation, 4, delta)
		velocity = velocityAdjust(
			Vector2.from_angle(rotation) * speed,
			markers[currentMarkerIndex].position
		)

func checkProximityToPoint() -> void:
	if (position - markers[currentMarkerIndex].position).length() < 30:

		if (!waypoint[currentMarkerIndex]):
			waiting = true
			timer.start()
		else:
			currentMarkerIndex += 1
			if currentMarkerIndex >= markers.size():
				currentMarkerIndex = 0

func _on_wait_timer_timeout() -> void:
	waiting = false
	currentMarkerIndex += 1
	if currentMarkerIndex >= markers.size():
		currentMarkerIndex = 0

func rotateTowardsPosition(location: Vector2, current_rotation: float, strength: float, delta: float) -> float:
	var direction = location - global_position
	var target_angle = direction.angle()
	
	var difference = angle_difference(current_rotation, target_angle)
	
	var max_turn = strength * delta
	
	if abs(difference) <= max_turn:
		return target_angle
	
	return current_rotation + (sign(difference) * max_turn)

func rotateTowardsDirection(target_dir: Vector2, current_rotation: float, strength: float, delta: float) -> float:
	var target_angle = target_dir.angle()
	
	var difference = angle_difference(current_rotation, target_angle)
	
	var max_turn = strength * delta
	
	if abs(difference) <= max_turn:
		return target_angle
	
	return current_rotation + (sign(difference) * max_turn)

func velocityAdjust(currentVelocity:Vector2, location:Vector2) -> Vector2:
	var direction = location - position
	var angleDifference = abs(angle_difference(rotation, direction.angle()))
	if angleDifference > .5:
		var reduction = clamp(1.0 - (angleDifference / PI), 0.1, 1.0)
		return currentVelocity * (reduction * reduction)
	return currentVelocity


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		vision_cone.emit()
		print("Walker saw player")
