extends Node2D

# Colors
@export var backgound_color : Color = Color.BLUE
@export var point_color1 : Color = Color.AQUA
@export var point_color2 : Color = Color.RED
@export var line_color : Color = Color.ANTIQUE_WHITE
@export var marching_square_color : Color = Color.AQUAMARINE

# Settings values
@export_range(0, 1, 0.01) var ground_threshold : float = 0.5
@export var grid_size : int = 50
@export var width : int = 1800
@export var height : int = 1200

# Noise texture
@export var noise : NoiseTexture2D

# Control switches
@export var use_lerp : bool = true
@export var show_grid : bool = true
@export var show_points = true

# Mesh and collision shapes container
@export var mesh_instance: MeshInstance2D
@export var collision_container: StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh = generate_mesh()
	mesh_instance.mesh = mesh

	# Generate collision shapes from the mesh
	generate_collision_shapes(mesh)

# Function to generate a box mesh with colors
func generate_mesh() -> ArrayMesh:
	var vertices = PackedVector2Array()
	# Box 1
	vertices.push_back(Vector2(0, 0))
	vertices.push_back(Vector2(-100, 0))
	vertices.push_back(Vector2(-100, -100))
	vertices.push_back(Vector2(0, -100))
	# Box 2
	vertices.push_back(Vector2(-200, -200))
	vertices.push_back(Vector2(-300, -200))
	vertices.push_back(Vector2(-300, -300))
	
	# Define the colors for each vertex
	var colors = PackedColorArray()
	# Box 1 Colors
	colors.push_back(Color(1, 0, 0))  # Red
	colors.push_back(Color(0, 1, 0))  # Green
	colors.push_back(Color(0, 0, 1))  # Blue
	colors.push_back(Color(1, 1, 0))  # Yellow
	# Box 2 Colors
	colors.push_back(Color(0, 1, 1))  # Cyan
	colors.push_back(Color(1, 0, 1))  # Magenta
	colors.push_back(Color(0.5, 0, 0.5)) # Purple
	
	# Define indices for the triangles
	var indices = PackedInt32Array()
	# Box 1
	indices.push_back(0)
	indices.push_back(1)
	indices.push_back(2)
	indices.push_back(2)
	indices.push_back(3)
	indices.push_back(0)
	# Box 2
	indices.push_back(4)
	indices.push_back(5)
	indices.push_back(6)
	
	# Initialize the ArrayMesh
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices

	# Create the Mesh
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	return arr_mesh

func add_triangle(vertices: PackedVector2Array, colors: PackedColorArray, 
				indices: PackedInt32Array, new_vertices: PackedVector2Array):
	
	pass

# Function to generate collision shapes from a mesh
func generate_collision_shapes(mesh: ArrayMesh):
	# Clear any existing collision shapes
	for child in collision_container.get_children():
		collision_container.remove_child(child)
		child.queue_free()

	# Extract the vertices and create collision shapes
	if mesh.get_surface_count() > 0:
		var arrays = mesh.surface_get_arrays(0)
		var vertices = arrays[Mesh.ARRAY_VERTEX]

		# Create collision shapes for each box
		create_collision_polygon(vertices.slice(0, 4)) # First box
		create_collision_polygon(vertices.slice(4, 8)) # Second box

# Helper function to create and add a collision polygon
func create_collision_polygon(vertices: PackedVector2Array):
	var collision_shape = CollisionPolygon2D.new()
	collision_shape.polygon = vertices
	collision_container.add_child(collision_shape)

# Function to print all children of the node
#func print_all_children(node: Node):
	#var children = node.get_children()
	#for child in children:
		#print(child.name)
		# Optionally, recursively print children of children
		# print_all_children(child)  # Uncomment this line if you want to print grandchildren too
		

func _draw():
	# Draw background
	draw_rect(Rect2(0, 0, width, height), backgound_color)
	# Draw reference lines
	if show_grid:
		draw_lines()
	# Draw marching squares
	draw_marching_squares()
	# Draw reference points
	if show_points:
		draw_points()


func draw_lines():
	var i = 0
	while i <= height:
		draw_line(Vector2(0, i), Vector2(width, i), line_color, 4)
		i += grid_size
	i = 0
	while i <= width:
		draw_line(Vector2(i, 0), Vector2(i, height), line_color, 4)
		i += grid_size


func draw_points():
	if noise and noise.noise:
		var i = 0
		var j = 0
		while i <= width:
			j = 0
			while j <= height:
				var value = (noise.noise.get_noise_2d(i, j) + 1.0) / 2.0
				var lerp_color = point_color1.lerp(point_color2, value)
				draw_circle(Vector2(i, j), 10, lerp_color)
				j += grid_size
			i += grid_size
	else:
		print("No noise resource found!")


func draw_marching_squares():
	# Triangle table that holds all of the triangle connections
	var triTable = [ [], 
					 [0, 4, 7], 
					 [4, 1, 5], 
					 [0, 1, 7, 7, 1, 5], 
					 [6, 5, 2], 
					 [0, 6, 7, 0, 2, 6, 0, 5, 2, 0, 4, 5],
					 [4, 2, 6, 4, 1, 2],
					 [0, 1, 7, 7, 1, 6, 6, 1, 2],
					 [7, 6, 3],
					 [0, 4, 3, 4, 6, 3],
					 [7, 4, 3, 3, 4, 1, 3, 1, 5, 3, 5, 6],
					 [0, 1, 5, 0, 5, 6, 0, 6, 3],
					 [7, 5, 3, 3, 5, 2],
					 [0, 4, 3, 3, 4, 5, 3, 5, 2],
					 [7, 2, 3, 7, 4, 2, 4, 1, 2],
					 [0, 1, 3, 1, 2, 3]]
	
	var pt_vals = [0, 0, 0, 0]
	var square_index = 0b0000
	var i = 0
	var j = 0
	while j < height:
		i = 0
		while i < width:
			pt_vals = [0, 0, 0, 0]
			square_index = 0b0000
			pt_vals[0] = (noise.noise.get_noise_2d(i, j) + 1.0) / 2.0
			pt_vals[1] = (noise.noise.get_noise_2d(i + grid_size, j) + 1.0) / 2.0
			pt_vals[2] = (noise.noise.get_noise_2d(i + grid_size, j + grid_size) + 1.0) / 2.0
			pt_vals[3] = (noise.noise.get_noise_2d(i, j + grid_size) + 1.0) / 2.0
			
			if pt_vals[0] > ground_threshold: 
				square_index |= 0b0001
			if pt_vals[1] > ground_threshold:
				square_index |= 0b0010
			if pt_vals[2] > ground_threshold: 
				square_index |= 0b0100
			if pt_vals[3] > ground_threshold: 
				square_index |= 0b1000
			
			var offsets = get_offsets(pt_vals, square_index)
			
			var tris = triTable[square_index]
			var k = 0
			while k < len(tris): # Draw a triangle
				var points = PackedVector2Array([Vector2(i + offsets[tris[k]][0], j + offsets[tris[k]][1]), 
									Vector2(i + offsets[tris[k + 1]][0], j + offsets[tris[k + 1]][1]), 
									Vector2(i + offsets[tris[k + 2]][0], j + offsets[tris[k + 2]][1])])
				draw_polygon(points, [marching_square_color])  
				
				k += 3
			i += grid_size
		j += grid_size

func has_duplicate_points(points: PackedVector2Array) -> bool:
	var i = 0
	var j = 0
	while i < len(points):
		j = i + 1
		while j < len(points): 
			if points[i] == points[j]:
				return true
			j += 1
		i += 1
	return false

func has_negative(points: PackedVector2Array) -> bool:
	for point in points:
		if point[0] < 0 or point[1] < 0:
			return true
	return false

func get_offsets(points_values, square_index):
	# Edge table to aid in linear interpolation to create smoothing
	var edgeTable = [ 0x0, 0x9, 0xc, 0x5, 0x6, 0xf, 0xa, 0x3, 
					  0x3, 0xa, 0xf, 0x6, 0x5, 0xc, 0x9, 0x0 ]
	# Offsets for points on each "marching" square
	var offsets = [ [0, 0], 
					[grid_size, 0], 
					[grid_size, grid_size], 
					[0, grid_size],
					[grid_size / 2.0, 0],
					[grid_size, grid_size / 2.0],
					[grid_size / 2.0, grid_size],
					[0, grid_size / 2.0]]
	
	var edges = edgeTable[square_index]
	
	if use_lerp:
		if edges & 0b1000 > 0: 
			offsets[4][0] = marching_squares_lerp(points_values[0], points_values[1])
		if edges & 0b0100 > 0:
			offsets[5][1] = marching_squares_lerp(points_values[1], points_values[2]) 
		if edges & 0b0010 > 0: 
			offsets[6][0] = marching_squares_lerp(points_values[3], points_values[2]) 
		if edges & 0b0001 > 0: 
			offsets[7][1] = marching_squares_lerp(points_values[0], points_values[3])
	return offsets


func marching_squares_lerp(val1, val2):
	var amt
	if val2 == val1:
		amt = 0.0
	else:
		amt = (ground_threshold - val1) / (val2 - val1)
		if amt < 0 or amt > 1:
			pass
	return lerp(0, grid_size, amt)


func _process(_delta):
	#queue_redraw()
	pass