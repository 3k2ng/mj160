extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D

@export var gravity_scale : float = 1

@export var SPEED = 600.0
@export var JUMP_VELOCITY = -500.0

var facing = 1

const COYOTE_TIME_MAX = 9
var coyote_time = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	handle_inputs(delta)
	move_and_slide()
	handle_animations()

func handle_inputs(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_scale

	# Handle jump.
	if coyote_time >= 0: coyote_time -= 1
	if Input.is_action_just_pressed("ui_accept"):
		coyote_time = COYOTE_TIME_MAX
		if (is_on_floor() or is_on_wall()) and coyote_time > 0:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/3.0)

func handle_animations():
	if velocity.x > 0.0: # right
		facing = 1
		sprite.flip_h = false
	elif velocity.x < 0.0: # left
		facing = -1
		sprite.flip_h = true
	
	if not is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0.0:
		sprite.play("run")
	else:
		sprite.play("idle")
