extends CharacterBody2D

@export var lookPoints: Array[Vector2]
@export var waitTime: float = 5

@onready var timer = $WaitTimer

signal vision_cone() 

var currentMarkerIndex = 0
var startPosition:Vector2
var waiting := false

var playerSighted := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(lookPoints.size() > 0, "Turrets need directions to look at")
	startPosition = position
	print(startPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !waiting:
		rotation = rotateTowardsDirection(lookPoints[currentMarkerIndex], rotation, 5, delta)
		checkRotation()

func checkRotation() -> void:
	if self.rotation == lookPoints[currentMarkerIndex].angle():
		timer.start()
		waiting = true


func _on_wait_timer_timeout() -> void:
	waiting = false
	currentMarkerIndex += 1
	if currentMarkerIndex >= lookPoints.size():
		currentMarkerIndex = 0

func rotateTowardsDirection(target_dir: Vector2, current_rotation: float, strength: float, delta: float) -> float:
	var target_angle = target_dir.angle()
	
	var difference = angle_difference(current_rotation, target_angle)
	
	var max_turn = strength * delta
	
	if abs(difference) <= max_turn:
		return target_angle
	
	return current_rotation + (sign(difference) * max_turn)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		playerSighted = true
		print("Turret saw player")

func  _on_area_2d_body_exit(body: Node2D) -> void:
	if body is Player:
		playerSighted = false
		print("Turret saw player")
