extends CharacterBody2D


var velo = 0.0
var acc = 0.0

const ACC = 25.0
const MAX_VELO = 400.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Handle left right moves
	if Input.is_action_pressed("right"):
		velocity.x += ACC
		if velocity.x > MAX_VELO:
			velocity.x = MAX_VELO
	elif Input.is_action_pressed("left"):
		velocity.x -= ACC
		if velocity.x < -MAX_VELO:
				velocity.x = -MAX_VELO
	
	move_and_slide()
