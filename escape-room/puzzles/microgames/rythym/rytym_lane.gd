class_name RythymLane extends Node2D

signal give_score(score : int)

@export var beat_scene : PackedScene = preload("res://puzzles/microgames/rythym/rythym_beat.tscn")
@export var input_action : String
@export var miss_cooldown : float = 1.0

@onready var miss_timer : Timer = $MissTimer

var can_hit : bool = true

func spawn_beat(score : int, velocity : Vector2) -> void:
	var beat = beat_scene.instantiate()
	beat.score = score
	beat.velocity = velocity
	add_child(beat)
	

func _physics_process(_delta: float) -> void:

	if can_hit and Input.is_action_just_pressed(input_action):
		var hit : bool = false
		for c in get_children():
			if c is RythymBeat:
				if c.can_be_hit:
					hit = true
					give_score.emit(c.score)
					c.queue_free()
		if not hit:
			can_hit = false
			miss_timer.start(miss_cooldown)
					
		

func _on_miss_timer_timeout() -> void:
	can_hit = true
