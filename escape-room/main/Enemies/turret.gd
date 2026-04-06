extends CharacterBody2D

@export var lookPoints: Array[Vector2]
@export var waitTime: float = 5
@export var projectile_scene : PackedScene = preload("res://main/Enemies/Projectile.tscn")

@onready var timer = $WaitTimer
@onready var shootTimer = $WaitTimer2
@onready var sightedTimer = $WaitTimer3

signal vision_cone() 

var currentMarkerIndex = 0
var startPosition:Vector2
var waiting := false
var target : Player
var playerSighted := false
var firing := false
var leftBarrelShoot := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(lookPoints.size() > 0, "Turrets need directions to look at")
	startPosition = position
	print(startPosition)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if playerSighted:
		rotation = rotateTowardsPosition(target.position, rotation, 5, delta)
		
	elif !waiting:
		rotation = rotateTowardsDirection(lookPoints[currentMarkerIndex], rotation, 5, delta)
		checkRotation()

func checkRotation() -> void:
	if self.rotation == lookPoints[currentMarkerIndex].angle():
		timer.start(waitTime)
		waiting = true


func _on_wait_timer_timeout() -> void:
	waiting = false
	currentMarkerIndex += 1
	if currentMarkerIndex >= lookPoints.size():
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		playerSighted = true
		sightedTimer.start(1)
		print("Turret saw player")

func  _on_area_2d_body_exit(body: Node2D) -> void:
	if body is Player:
		playerSighted = false
		firing = false
		print("Turret saw player")



func _on_wait_timer_3_timeout() -> void:
	firing = true;
	shootTimer.start(0.05)


func _on_wait_timer_2_timeout() -> void:
	pass # Replace with function body.
