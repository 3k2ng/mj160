extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var u = get_parent().position - get_parent().C
	print(get_parent().position)
	print(get_parent().C)
	print("\n")
	
	if get_parent().length(u) < 4 * get_parent().R:
		if abs(u.x) >= abs(u.y):
			if u.x >= 0:
				animation = "left"
			else:
				animation = "right"
		else:
			if u.y >= 0:
				animation = "up"
			else:
				animation = "down"
	else:
		animation = "default"
