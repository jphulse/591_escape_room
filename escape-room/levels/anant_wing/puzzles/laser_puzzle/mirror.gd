class_name Mirror extends StaticBody2D

enum RELECTION_DIRECTION {NE, SE, NW, SW}
var DIRECTIONS_LIST := [
	[Vector2.UP, Vector2.RIGHT], # 
	[Vector2.DOWN, Vector2.RIGHT], # 
	[Vector2.UP, Vector2.LEFT], # 
	[Vector2.DOWN, Vector2.LEFT]  #
]

@export var facing_direction := RELECTION_DIRECTION.NE

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	#
#func get_reflecting_direction(impactDirection: Vector2) -> void:
	#var dir_list = _get_facing_direction()
#
#func _get_facing_direction() -> Array[Vector2]:
	#return DIRECTIONS_LIST[facing_direction]
#
#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#pass # Replace with function body.
