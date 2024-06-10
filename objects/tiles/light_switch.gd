extends AnimatedSprite2D

@onready var switch_sfx = $SwitchSFX

signal switched

var on = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and $Timer.time_left == 0:
		if on:
			play("switch")
		else:
			play_backwards("switch")
		emit_signal("switched")
		on = not on
		$Timer.start()
