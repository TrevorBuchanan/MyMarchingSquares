extends Node2D

const Chunk = preload("res://scripts/chunk.gd")

@export var viewer : Node2D
@export var chunk_size : int = 1024
@export var render_distance : int = 2  # In number of chunks
@export var chunk_type : Node2D

var visible_chucks : Array[Chunk] = []
var cached_chunks: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	if viewer: 
		# load surrounding chunks
		load_surrounding_chunks(viewer.position)
	else: 
		print("No active viewer found")
		# load no chunks
	
	# Generate a random color
	var random_color = Color(
		randf(),  # Random value between 0 and 1 for red
		randf(),  # Random value between 0 and 1 for green
		randf(),  # Random value between 0 and 1 for blue
		1.0       # Alpha (opacity) value set to 1 for full opacity
	)

	# Set the modulate property of the Sprite2D to the random color
	modulate = random_color


func load_surrounding_chunks(viewer_position : Vector2) -> void:
	# first load viwers chunks
	var current_chunk_pos : Vector2 = get_chunk_pos(viewer_position)
	load_chunk(current_chunk_pos)
	for i in range(1, render_distance + 1):
		for j in range(1, render_distance + 1):
			load_chunk(Vector2(current_chunk_pos.x - (i * chunk_size),
								current_chunk_pos.y - (i * chunk_size)))
			load_chunk(Vector2(current_chunk_pos.x + (i * chunk_size),
								current_chunk_pos.y + (i * chunk_size)))

func load_chunk(source_pos : Vector2) -> void:
	# Check if chunk data has been saved in cache
	if cached_chunks.has(source_pos):
		# if so then reload it
		cached_chunks[source_pos].load_content()
	# otherwise go to load new chunk
	else:
		load_new_chuck(source_pos)


func load_new_chuck(source_pos : Vector2) -> void:
	# Load new chunk and save chunk
	cached_chunks[source_pos] = Chunk.new(source_pos)


func save_chunk():
	# Add chunk to cache of explored chunks
	pass


func unload_chunk():
	# Remove chunk from list of chunks in view
	pass


func get_chunk_pos(pos : Vector2) -> Vector2:
	var x : int = floor(pos.x)
	var y : int = floor(pos.y)
	x = x - (x % chunk_size)
	y = y - (y % chunk_size)
	return Vector2(x, y)
