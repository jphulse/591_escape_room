extends Puzzle

@onready var display_wave : Wave = %WaveDisplay
@onready var interactive_wave : Wave = %InteractiveWave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_interactive_wave_draw() -> void:
	if interactive_wave.equivalent(display_wave):
		solve()
		print("Solved")
