extends Node2D

const Chunk = preload("res://scripts/chunk.gd")

@export var viewer : Node2D
@export var chunk_size : int = 1024
@export var step_size : int = 64
@export var render_distance : int = 2  # In number of chunks
@export var chunk_type : PackedScene

var visible_chucks : Array[Chunk] = []
var cached_chunks: Dictionary = {}
var current_chunk_pos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	if viewer: 
		# load surrounding chunks
		current_chunk_pos = get_chunk_pos(viewer.position)
		load_surrounding_chunks()
	else: 
		print("No active viewer found")
		return
		# load no chunks


func load_surrounding_chunks() -> void:
	load_chunk(current_chunk_pos)
	# first load viwers chunks
	var layer: int = 1
	var edge_dist : int = 2
	while layer <= render_distance:
		var offset_chunk : Vector2 = Vector2(current_chunk_pos.x + (layer * chunk_size), current_chunk_pos.y + (layer * chunk_size))
		load_chunk(offset_chunk)
		for i in range(edge_dist):
			offset_chunk.y -= chunk_size
			load_chunk(offset_chunk)
		
		for i in range(edge_dist):
			offset_chunk.x -= chunk_size
			load_chunk(offset_chunk)
		
		for i in range(edge_dist):
			offset_chunk.y += chunk_size
			load_chunk(offset_chunk)
		
		for i in range(edge_dist - 1):
			offset_chunk.x += chunk_size
			load_chunk(offset_chunk)
		
		edge_dist += 2
		layer += 1


func load_chunk(source_pos : Vector2) -> void:
	# Check if chunk data has been saved in cache
	if cached_chunks.has(source_pos):
		# if so then reload it
		#cached_chunks[source_pos].load_content()
		#add_child(cached_chunks[source_pos].get_chunk_object())
		pass
	# otherwise go to load new chunk
	else:
		load_new_chuck(source_pos)


func load_new_chuck(source_pos : Vector2) -> void:
	# Load new chunk and save chunk
	print(source_pos)
	cached_chunks[source_pos] = Chunk.new(source_pos, chunk_type, chunk_size, step_size)
	add_child(cached_chunks[source_pos].get_chunk_object())


#func save_chunk():
	## Add chunk to cache of explored chunks
	#pass

func unload_out_of_range_chunks():
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


func _process(delta):
	if get_chunk_pos(viewer.position) != current_chunk_pos:
		print("Update chunks")
		load_surrounding_chunks()
		unload_out_of_range_chunks()
