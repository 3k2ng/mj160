extends Node2D

signal initialised

signal completed

var spawn_position : Vector2

var switched = false

var exit_door : AnimatedSprite2D

func _on_tile_map_child_entered_tree(node):
	if node.is_in_group("enter_door"):
		spawn_position = node.global_position
		emit_signal("initialised", spawn_position)
	if node.is_in_group("exit_door"):
		exit_door = node
		node.connect("exited", signal_completed)
	if node.is_in_group("light_switch"):
		node.connect("switched", switch_light)

# TODO Make everything go dark
func switch_light():
	switched = true
	exit_door.disabled = false

func signal_completed():
	emit_signal("completed")
