extends Puzzle

enum Direction {
	TOP, RIGHT, BOTTOM, LEFT
}
@export_group("Simon game info")
@export var cycles : int = 3
@export var first_cycle_length := 4
@export var cycle_delta := 1
@export var sequence_cooldown := 1.0
@export var cycle_cooldown := 3.0

@export_group("Shader info")
@export_range(0.0, 1.0) var darkness_mult : float = .5

@onready var top_sprite : SimonButton = $TopSprite
@onready var right_sprite : SimonButton = $RightSprite
@onready var bottom_sprite : SimonButton = $BottomSprite
@onready var left_sprite : SimonButton = $LeftSprite

@onready var cycle_timer : Timer = $CycleTimer
@onready var sequence_timer : Timer = $SequenceTimer
@onready var sprite_timer : Timer = $SpriteHighlightTimer


var sequence : Array[Direction] = []
var sprite_map : Dictionary[SimonButton, Direction]
var cycle := 0
var current_index := 0

func start_round() -> void:
	current_index = 0
	sequence.clear()
	for button : SimonButton in sprite_map.keys():
		button.selectable = false
	for i in range(first_cycle_length + cycle * cycle_delta):
		sequence.append(Direction.values().pick_random())
	print(sequence)
	sequence_timer.start(sequence_cooldown)



func _ready() -> void:
	top_sprite.darkness_mult = darkness_mult
	right_sprite.darkness_mult = darkness_mult
	left_sprite.darkness_mult = darkness_mult
	bottom_sprite.darkness_mult = darkness_mult
	top_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	right_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	bottom_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	left_sprite.set_instance_shader_value("darkness_mult", darkness_mult)
	sprite_map[top_sprite] = Direction.TOP
	sprite_map[right_sprite] = Direction.RIGHT
	sprite_map[bottom_sprite] = Direction.BOTTOM
	sprite_map[left_sprite] = Direction.LEFT
	start_round()
	
# Called when the node enters the scene tree for the first time.


func _on_cycle_timer_timeout() -> void:
	start_round()


func _on_sequence_timer_timeout() -> void:
	
	if current_index > 0:
		var old_sprite : SimonButton = sprite_map.find_key(sequence[current_index - 1])
		old_sprite.set_instance_shader_value("darkness_mult", old_sprite.darkness_mult)
	if current_index >= len(sequence):
		sequence_timer.stop()
		for sprite : SimonButton in sprite_map.keys():
			sprite.selectable = true
		cycle_timer.start(cycle_cooldown)
		return
	sprite_timer.start(sequence_cooldown / 2.0)
	

func _on_button_pressed(caller: SimonButton) -> void:
	if not sequence.is_empty() and sequence.front() == sprite_map[caller]:
		sequence.pop_front()
		if sequence.is_empty():
			cycle_timer.stop()
			cycle += 1
			if cycle >= cycles:
				puzzle_solved.emit()
				print("Solved")
			else:
				start_round()
	else:
		start_round()


func _on_sprite_highlight_timer_timeout() -> void:
	var sprite : SimonButton = sprite_map.find_key(sequence[current_index])
	sprite.set_instance_shader_value("darkness_mult", sprite.active_mult)
	current_index += 1
