extends MeshInstance2D


func _ready():
	var array_mesh = ArrayMesh.new()
	var arrays = []
	
	# Define the vertices of the triangle (3 points)
	var vertices = PackedVector2Array()
	vertices.append(Vector2(0, 0))   # Point A
	vertices.append(Vector2(100, 0)) # Point B
	vertices.append(Vector2(50, 100))# Point C
	
	# Define the colors for each vertex (optional)
	var colors = PackedColorArray()
	colors.append(Color(1, 0, 0))  # Red for Point A
	colors.append(Color(0, 1, 0))  # Green for Point B
	colors.append(Color(0, 0, 1))  # Blue for Point C
	
	# Define the indices for the triangle (the order of the vertices)
	var indices = PackedInt32Array()
	indices.append(0)
	indices.append(1)
	indices.append(2)
	
	# Add the arrays to the main array
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	
	# Add the surface to the mesh
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	# Assign the mesh to the MeshInstance2D
	self.mesh = array_mesh
