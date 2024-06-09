extends Node

@export var maps : Array[PackedScene]

@export var map_index = 0

var map_node : Node2D

func _ready():
	load_map(map_index)

func load_map(index : int):
	if map_node != null:
		map_node.queue_free()
	map_node = maps[map_index].instantiate()
	add_child(map_node)
	map_node.connect("initialised", _on_map_initialised)
	map_node.connect("completed", _on_map_completed)

func _on_map_initialised(spawn_position):
	$Player.position = spawn_position

func _on_map_completed():
	if map_index == len(maps) - 1:
		print("you win") # TODO
	else:
		map_index += 1
		load_map(map_index)
	
