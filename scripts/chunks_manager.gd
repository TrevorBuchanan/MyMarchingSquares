extends Node2D

const Chunk = preload("res://scripts/chunk.gd")

@export var viewer : Node2D
@export var chunk_size : int = 1024
@export var step_size : int = 64
@export var render_distance : int = 2  # In number of chunks
@export var chunk_type : PackedScene

var current_chunk_pos: Vector2
var visible_chunks: Array[Chunk] = []
var layer: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if viewer: 
		load_surrounding_chunks()
	else: 
		print("No active viewer found")


func load_surrounding_chunks() -> void:
	current_chunk_pos = get_chunk_pos(viewer.position)
	load_chunk(current_chunk_pos)
	# first load viwers chunks
	var layer: int = 1
	var edge_dist : int = 2
	while layer <= render_distance:
		var offset_chunk : Vector2 = Vector2(current_chunk_pos.x + (layer * chunk_size), current_chunk_pos.y + (layer * chunk_size))
		if current_chunk_pos.distance_to(offset_chunk) <= render_distance * chunk_size:
			load_chunk(offset_chunk)
		
		for i in range(edge_dist):
			offset_chunk.y -= chunk_size
			if current_chunk_pos.distance_to(offset_chunk) <= render_distance * chunk_size:
				load_chunk(offset_chunk)
		
		for i in range(edge_dist):
			offset_chunk.x -= chunk_size
			if current_chunk_pos.distance_to(offset_chunk) <= render_distance * chunk_size:
				load_chunk(offset_chunk)
		
		for i in range(edge_dist):
			offset_chunk.y += chunk_size
			if current_chunk_pos.distance_to(offset_chunk) <= render_distance * chunk_size:
				load_chunk(offset_chunk)
		
		for i in range(edge_dist - 1):
			offset_chunk.x += chunk_size
			if current_chunk_pos.distance_to(offset_chunk) <= render_distance * chunk_size:
				load_chunk(offset_chunk)
		
		edge_dist += 2
		layer += 1


func load_chunk(source_pos : Vector2) -> void:
	# Check if chunk data has been saved in cache
	# otherwise go to load new chunk
	# For now just load new chunk
	load_new_chuck(source_pos)


func load_new_chuck(source_pos : Vector2) -> void:
	# Load new chunk and save chunk
	var new_chunk = Chunk.new(source_pos, chunk_type, chunk_size, step_size)
	visible_chunks.append(new_chunk)
	add_child(new_chunk.get_chunk_object())


func unload_out_of_range_chunks():
	for chunk in visible_chunks:
		if chunk.source_position.distance_to(current_chunk_pos) > render_distance * chunk_size:
			chunk.unload_content()
			visible_chunks.erase(chunk)


func get_chunk_pos(pos : Vector2) -> Vector2:
	var x : int = floor(pos.x)
	var y : int = floor(pos.y)
	x = x - (x % chunk_size)
	y = y - (y % chunk_size)
	return Vector2(x, y)


func _process(delta):
	if viewer:
		if get_chunk_pos(viewer.position) != current_chunk_pos:
			load_surrounding_chunks()
			unload_out_of_range_chunks()
			print("New chunk")
