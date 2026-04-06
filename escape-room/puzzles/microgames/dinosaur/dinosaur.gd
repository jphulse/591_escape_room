extends Puzzle

@export var obstacle_velocity := Vector2.LEFT * 200
@export var obstacle_cooldown_timer := 2.0
@export var obstacle_time_range := .5

@export var required_score := 10
@export var dino_jump_speed := 300.0
@export var dino_gravity := 450.0
@export var position_offset := 10.0

@onready var obstacle_timer : Timer = $ObstacleSpawnTimer
@onready var dino : Node2D = $Dino
@onready var dino_shape : RectangleShape2D = $Dino/CollisionShape2D.shape
@onready var score_label : Label = $CanvasLayer/Control/Label

const score_label_format : String = "%02d / %02d"

var score : int = 0
var obstacle : PackedScene = preload("res://puzzles/microgames/dinosaur/obstacle.tscn")
var dino_resting_position := Vector2.ZERO
var dino_velocity := Vector2.ZERO

func update_score_label() -> void:
	score_label.text = score_label_format % [score, required_score]
	if score >= required_score:
		solve()
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score_label()
	obstacle_timer.start(obstacle_cooldown_timer)
	
	dino_resting_position.x = dino.position.x
	dino_resting_position.y = SubviewportInfo.viewport_dimensions.y / 2  - (dino_shape.size.y * dino.scale.y) / (2.0)
	dino_resting_position.y -= position_offset
	dino.position = dino_resting_position
	
	

func _physics_process(delta: float) -> void:
	if dino.position.is_equal_approx(dino_resting_position) and Input.is_action_just_pressed("jump"):
		dino_velocity = Vector2.UP * dino_jump_speed
	print("Dino position is %d" % dino.position.y)
	dino.position.y = clampf(dino.position.y + dino_velocity.y * delta, 0,  dino_resting_position.y)
	dino_velocity += Vector2.DOWN * dino_gravity * delta
	

func _on_dino_area_entered(_area: Area2D) -> void:
	score = 0
	update_score_label()
	for child in get_children():
		if child is DinoObstacle:
			child.queue_free()


func _on_obstacle_spawn_timer_timeout() -> void:
	var inst : DinoObstacle = obstacle.instantiate()
	inst.position.x = SubviewportInfo.viewport_dimensions.x
	inst.position.y = SubviewportInfo.viewport_dimensions.y / 2 - (inst.get_shape().size.y * inst.scale.y) / 2.0 - position_offset
	
	inst.velocity = obstacle_velocity
	add_child(inst)
	obstacle_timer.start(randf_range(obstacle_cooldown_timer - obstacle_time_range, obstacle_cooldown_timer + obstacle_time_range))


func _on_death_area_area_entered(area: Area2D) -> void:
	score += 1
	update_score_label()
	area.queue_free()
