extends AudioStreamPlayer


var light_in = preload("res://assets/music/light_draft_2_initial.ogg")
var light_loop = preload("res://assets/music/light_draft_2_loop.ogg")
var dark_in = preload("res://assets/music/dark_draft_2_buildup_cut.ogg")
var dark_loop = preload("res://assets/music/dark_draft_2_loop_ammended.ogg")

var this_cant_possibly_be_good_design_can_it = false

# Called when the node enters the scene tree for the first time.
func _ready():
	stop()
	stream = light_in
	play()


func play_dark():
	stop()
	stream = dark_in
	play()


func _on_finished():
	if this_cant_possibly_be_good_design_can_it:
		set_volume_db(1.0)
		stream = dark_loop
	else:
		stream = light_loop
	play()
