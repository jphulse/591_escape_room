class_name Wave extends Control



@export var amplitude: float = 50.0
@export var frequency: float = 2.0
@export var speed: float = 1.0
@export var thickness: float = 3.0
@export var samples: int = 300
@export var grid_spacing: float = 40.0
@export var min_speed : float = .5
@export var max_speed : float = 3.0
@export var max_frequency := 20.0
@export var min_frequency := 1.0
@export var min_amplitude := 30.0
@export var max_amplitude := 100.0
@export var interactive : bool = false
@export var steps := 30
@export var equivalence_steps := 1

@export var color : Color = Color.DARK_CYAN

@onready var a_slider : HSlider = %AmplitudeSlider
@onready var f_slider : HSlider = %FreuqncySlider
@onready var s_slider : HSlider = %SpeedSlider

var time_passed: float = 0.0

func _ready() -> void:
	amplitude = randf_range(min_amplitude, max_amplitude)
	frequency = randf_range(min_frequency, max_frequency)
	#speed = randf_range(min_speed, max_speed)
	if interactive:
		a_slider.min_value = min_amplitude
		a_slider.max_value = max_amplitude
		a_slider.value = amplitude
		a_slider.step = (max_amplitude - min_amplitude) / steps
		s_slider.min_value = min_speed
		s_slider.max_value = max_speed
		s_slider.value = speed
		s_slider.step = (s_slider.max_value - s_slider.min_value) / steps
		f_slider.max_value = max_frequency
		f_slider.min_value = min_frequency
		f_slider.value = frequency
		f_slider.step = (f_slider.max_value - f_slider.min_value) / steps
	resize_wave()

func _process(delta: float) -> void:
	time_passed += delta
	queue_redraw()

func _size_changed() -> void:
	resize_wave()

func resize_wave() -> void:
	var vp_size = get_viewport_rect().size
	position = Vector2(0, 0)
	size = Vector2(vp_size.x, vp_size.y * 0.5)



func _draw() -> void:
	var points: PackedVector2Array = []
	var w := size.x
	var h := size.y
	var mid_y := h * 0.5
	if interactive:
		amplitude = a_slider.value
		frequency = f_slider.value
		speed = s_slider.value
	
	# chatgpt helped with grid
	var gx := 0.0
	while gx <= w:
		draw_line(Vector2(gx, 0), Vector2(gx, h), Color(0.2, 0.2, 0.2, 0.5), 1.0)
		gx += grid_spacing

	var gy := 0.0
	while gy <= h:
		draw_line(Vector2(0, gy), Vector2(w, gy), Color(0.2, 0.2, 0.2, 0.5), 1.0)
		gy += grid_spacing

	draw_line(Vector2(0, mid_y), Vector2(w, mid_y), Color(0.6, 0.6, 0.6, 0.8), 2.0)

	
	for i in range(samples):
		var t := float(i) / float(samples - 1)
		var x := t * w
		
		# Convert screen x into wave domain
		var angle := t * TAU * frequency + time_passed #* speed
		var y := mid_y + sin(angle) * amplitude
		
		points.append(Vector2(x, y))

	draw_polyline(points, color, thickness, true)


func _on_amplitude_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		amplitude = a_slider.value


func _on_freuqncy_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		frequency = f_slider.value


func _on_speed_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		speed = s_slider.value

func equivalent(other : Wave) -> bool:
	return (abs(a_slider.value - other.amplitude) <= equivalence_steps * a_slider.step and 
	abs(f_slider.value - other.frequency) <= equivalence_steps * f_slider.step)# and 
	#abs(s_slider.value - other.speed) <= equivalence_steps * s_slider.step)
