extends Node

@export var maps : Array[PackedScene]

@export var map_index = 0

var map_node : Node2D

func _ready():
	load_map(map_index)

func load_map(index : int):
	if map_node != null:
		map_node.queue_free()
	map_node = maps[index].instantiate()
	add_child(map_node)
	map_node.connect("initialised", _on_map_initialised)
	map_node.connect("completed", _on_map_completed)
	map_node.connect("light_switched", _on_map_light_switched)
	# music
	if map_node.music != $Music.stream:
		$Music.stop()
		$Music.stream = map_node.music
		$Music.play()

func _on_map_initialised(spawn_position):
	$Player.position = spawn_position

func _on_map_completed():
	if map_index == len(maps) - 1:
		print("you win") # TODO
	else:
		map_index += 1
		load_map(map_index)

func _on_map_light_switched(status):
	print(status)
	if status:
		$Player.light_switched_on()
	else:
		$Player.light_switched_off()
