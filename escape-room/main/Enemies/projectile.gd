extends CharacterBody2D


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_projectile_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hit()
		queue_free()
	elif !body.is_in_group("Enemies"):
		queue_free()
