extends Object

# Define properties
var source_position : Vector2
var chunk_object : Node2D


# Constructor
func _init(source_pos : Vector2, chunk_scene : PackedScene, size : int, step_size : int):
	self.source_position = source_pos
	self.chunk_object = chunk_scene.instantiate()
	chunk_object.source_position = source_pos
	chunk_object.width = size
	chunk_object.height = size
	chunk_object.grid_size = step_size


# Method to get the chunk content object
func get_chunk_object() -> Node2D:
	return chunk_object


# Method ot get source position
func get_source_position() -> Vector2:
	return source_position


func create_content(content_type : Node2D) -> Node2D:
	print("Creating content for")
	print(source_position)
	return chunk_object


func load_content():
	print("Loading content for")
	print(source_position)

