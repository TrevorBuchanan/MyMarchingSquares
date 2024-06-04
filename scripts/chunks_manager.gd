extends Node2D

@export var viewer : Node2D

const Chunk = preload("res://scripts/chunk.gd")
var visible_chucks : Array[Chunk] = []
var cached_chunks: Dictionary = {}



# Called when the node enters the scene tree for the first time.
func _ready():
	if viewer: 
		print(viewer.position)
		# load surrounding chunks
		pass
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


func load_chunk():
	# Check if chunk data has been saved in cache
	# if so then reload it
	# otherwise go to load new chunk
	pass


func load_new_chuck():
	# Load new chunk 
	# Save chunk
	pass


func save_chunk():
	# Add chunk to cache of explored chunks
	pass


func unload_chunk():
	# Remove chunk from list of chunks in view
	pass
