extends Node2D

signal initialised

signal completed

var spawn_position : Vector2

var switched = false

var exit_door : AnimatedSprite2D

@export var music : AudioStream

func _on_tile_map_child_entered_tree(node):
	if node.is_in_group("enter_door"):
		spawn_position = node.global_position
		emit_signal("initialised", spawn_position)
	if node.is_in_group("exit_door"):
		exit_door = node
		node.connect("exited", signal_completed)
	if node.is_in_group("light_switch"):
		node.connect("switched", switch_light)

func switch_light():
	if not switched:
		$TileMap.modulate = Color(0.1, 0.1, 0.1)
		exit_door.disabled = false
	else:
		$TileMap.modulate = Color(1, 1, 1)
		exit_door.disabled = true
	switched = not switched

func signal_completed():
	emit_signal("completed")
