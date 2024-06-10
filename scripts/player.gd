extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D

@export var gravity_scale : float = 1

@export var SPEED = 600.0
@export var JUMP_VELOCITY = -500.0
@export var WALL_JUMP_VELOCITY = -500.0
@export var ACCEL = 500.0

var facing = 1
var prefix = ""

@export var COYOTE_TIME_MAX = 4
var coyote_time = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func reset():
	prefix = ""
	sprite.play("idle")


func _physics_process(delta):
	handle_inputs(delta)
	move_and_slide()
	handle_animations()

func handle_inputs(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_scale

	# Handle jump.
	if coyote_time >= 0:
		coyote_time -= 1
	if is_on_floor():
		coyote_time = COYOTE_TIME_MAX
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or coyote_time > 0):
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_accept") and is_on_wall():
		velocity.y = JUMP_VELOCITY
		velocity.x = -facing * WALL_JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)

func handle_animations():
	if velocity.x > 0.0: # right
		facing = 1
		sprite.scale.x = 1
	elif velocity.x < 0.0: # left
		facing = -1
		sprite.scale.x = -1
	
	if not is_on_floor():
		sprite.play(prefix + "jump")
	elif velocity.x != 0.0:
		sprite.play(prefix + "run")
	else:
		sprite.play(prefix + "idle")


func light_switched_off():
	prefix = "dark_"

func light_switched_on():
	prefix = ""
