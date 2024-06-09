extends Node2D

signal initialised

signal completed

var spawn_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tile_map_child_entered_tree(node):
	if node.is_in_group("enter_door"):
		spawn_position = node.global_position
		emit_signal("initialised", spawn_position)
	if node.is_in_group("exit_door"):
		node.connect("exited", signal_completed)

func signal_completed():
	emit_signal("completed")
