extends AnimatedSprite2D

@export var disabled = true

signal exited

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and not disabled:
		play("close")
		emit_signal("exited")
