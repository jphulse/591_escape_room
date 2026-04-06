extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D

var destroyOnDeath := false

func open() -> void:
	if sprite.frame == 0:
		sprite.play()
		collider.disabled = true

func openAndDestroy() -> void:
	sprite.play()
	destroyOnDeath = true

func destroy() -> void:
	queue_free()

func close() -> void:
	if sprite.frame == 11:
		sprite.play_backwards()
		collider.disabled = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if destroyOnDeath:
		queue_free()
