extends Puzzle

@export var required_score: int = 30
@export var bpm : float = 30
@export var health : int = 99999
@export var lane_scene : PackedScene = preload("res://puzzles/microgames/rythym/rytym_lane.tscn")
@export var input_actions : Array[String] = []
@export var beat_velocity : Vector2 = Vector2(0, 100)
@export var beat_value : int = 1

@onready var spawn_timer : Timer = $SpawnTimer
@onready var left_ednpoint : Marker2D = $Markers/LeftMarker
@onready var right_endpoint : Marker2D = $Markers/RightMarker

var score : int = 0
var lanes : Array[RythymLane] = []
var seconds_per_beat : float

func give_score(amount : int)-> void:
	score += amount
	print("SCORE is %d" % score)
	if score >= required_score:
		solve()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	assert(len(input_actions) >= 1, "Did not set any input actions for this scene, set these in inspector")
	var delta := (right_endpoint.position.x - left_ednpoint.position.x) / (len(input_actions) + 1)
	var delta_mult := 1
	for i in input_actions:
		var lane = lane_scene.instantiate()
		assert(lane.has_signal("give_score"))
		lane.give_score.connect(give_score)
		lane.input_action = i
		add_child(lane)
		lanes.append(lane)
		lane.position.x = left_ednpoint.position.x + delta * delta_mult
		delta_mult += 1
	seconds_per_beat = 60.0 / bpm
	spawn_timer.start(seconds_per_beat)
	



func _on_death_barrier_area_entered(area: Area2D) -> void:
	if area is RythymBeat:
		area.queue_free() 
		health -= 1
		if health <= 0 :
			close_puzzle()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is RythymBeat:
		area.can_be_hit = true
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is RythymBeat:
		area.can_be_hit = false


func _on_spawn_timer_timeout() -> void:
	lanes.pick_random().spawn_beat(beat_value, beat_velocity)
