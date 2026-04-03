class_name SimonButton extends Sprite2D

signal pressed(caller : SimonButton)



@export var active_mult : float = 2.0
@export var cooldown_tint : float = .5
@export var cooldown_time := .25


var darkness_mult : float = 1.0
var active : bool = false
var selectable : bool = true
var released : bool = false
var on_cooldown : bool = false


@onready var cooldown_timer : Timer = $CooldownTimer

func click() -> void:
	cooldown_timer.start(cooldown_time)
	on_cooldown = true
	released = false
	pressed.emit(self)
	set_instance_shader_value("darkness_mult", active_mult * cooldown_tint)

func release() -> void:
	released = true
	if not on_cooldown:
		set_instance_shader_value("darkness_mult", active_mult)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and active and selectable:
			if event.pressed:
				click()
			else:
				release()
				

func set_instance_shader_value(param_name : String, value : Variant) -> void:
	set_instance_shader_parameter(param_name, value)


func _on_area_mouse_entered() -> void:
	if selectable and not active:
		active = true
		set_instance_shader_value("darkness_mult", active_mult)




func _on_area_mouse_exited() -> void:
	cooldown_timer.stop()
	if active:
		active = false
		set_instance_shader_value("darkness_mult", darkness_mult)


func _on_cooldown_timer_timeout() -> void:
	on_cooldown = false
	if released and active and selectable:
		set_instance_shader_value("darkness_mult", active_mult)
