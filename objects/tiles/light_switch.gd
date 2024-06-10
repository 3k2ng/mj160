extends AnimatedSprite2D

signal switched

var on = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if on:
			play("switch")
		else:
			play_backwards("switch")
		emit_signal("switched")
		on = not on
