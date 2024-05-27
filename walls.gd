extends StaticBody2D

@export var mesh_instance : MeshInstance2D
@export var collision_container: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var mesh = generate_mesh()
	mesh_instance.mesh = mesh

	# Generate collision shape from the mesh
	generate_collision_shapes(mesh)

# Function to generate a mesh
# Function to generate a box mesh
func generate_mesh() -> ArrayMesh:
	var vertices = PackedVector2Array()
	# Box 1
	vertices.push_back(Vector2(0, 0))
	vertices.push_back(Vector2(100, 0))
	vertices.push_back(Vector2(100, 100))
	vertices.push_back(Vector2(0, 100))
	# Box 2
	vertices.push_back(Vector2(200, 200))
	vertices.push_back(Vector2(300, 200))
	vertices.push_back(Vector2(300, 300))
	vertices.push_back(Vector2(200, 300))
	
	# Initialize the ArrayMesh
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

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
	indices.push_back(6)
	indices.push_back(7)
	indices.push_back(4)
	arrays[Mesh.ARRAY_INDEX] = indices

	# Create the Mesh
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	return arr_mesh

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
