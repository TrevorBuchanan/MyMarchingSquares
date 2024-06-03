extends CharacterBody2D

signal hit

@export var acc := 300.0
@export var max_velocity := 400.0
@export var jump_velocity := -400.0
@export var damping := 0.99

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	# Handle left-right movement
	if Input.is_action_pressed("right"):
		velocity.x += acc * delta
	elif Input.is_action_pressed("left"):
		velocity.x -= acc * delta
	else:
		velocity.x *= damping

	# Clamp the velocity to ensure it doesn't exceed maximum velocity
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)

	# Move the character and handle collisions
	move_and_slide()

	# Emit hit signal if a collision occurs
	if is_on_wall():
		emit_signal("hit")
		velocity.x = 0

# Optional: Use this function to reset velocity upon hit signal
func _on_hit():
	velocity = Vector2.ZERO
