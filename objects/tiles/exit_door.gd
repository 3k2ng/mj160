extends AnimatedSprite2D

@onready var close_sfx = $CloseSFX

@export var disabled = true

signal exited

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and not disabled:
		play("close")
		close_sfx.play()
		emit_signal("exited")
