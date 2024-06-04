extends Object

# Define properties
var color : Color
var source_position : Vector2


# Constructor
func _init(color : Color = Color.BLACK):
	self.color = color 


# Define a method to get information
func get_color() -> Color:
	return color


# Method ot get source position
func get_source_position() -> Vector2:
	return source_position
