extends Object

# Define properties
var source_position : Vector2
var chunk_object : Node2D
var loaded : bool = false
var saved_data

# Constructor
func _init(source_pos : Vector2, chunk_scene : PackedScene, size : int, step_size : int):
	self.source_position = source_pos
	self.chunk_object = chunk_scene.instantiate()
	chunk_object.source_position = source_pos
	chunk_object.width = size
	chunk_object.height = size
	chunk_object.grid_size = step_size
	loaded = true


# Method to get the chunk content object
func get_chunk_object() -> Node2D:
	return chunk_object


# Method ot get source position
func get_source_position() -> Vector2:
	return source_position


func load_content(chunk_scene : PackedScene, size : int, step_size : int):
	loaded = true
	self.chunk_object = chunk_scene.instantiate()
	chunk_object.source_position = source_position
	chunk_object.width = size
	chunk_object.height = size
	chunk_object.grid_size = step_size


func unload_content():
	chunk_object.queue_free()
	chunk_object = null
	loaded = false
	

func save_object_content():
	var saved_data = chunk_object.compact_data_to_list()
