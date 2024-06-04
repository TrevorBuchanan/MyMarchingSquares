extends Object

const ChunkObject = preload(("res://scripts/chunk_object.gd"))

# Define properties
var source_position : Vector2
var chunk_object : ChunkObject


# Constructor
func _init(source_pos : Vector2, new_chunk_object: ChunkObject = null):
	self.source_position = source_pos
	self.chunk_object = new_chunk_object
	create_content()


# Method to get the chunk content object
func get_chunk_object() -> ChunkObject:
	return chunk_object


# Method ot get source position
func get_source_position() -> Vector2:
	return source_position


func create_content():
	print("Creating content for")
	print(source_position)


func load_content():
	print("Loading content for")
	print(source_position)