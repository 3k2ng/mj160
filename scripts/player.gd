extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D

@onready var footsteps_sfx = $FootstepsSFX
@onready var footsteps_timer = $FootstepsTimer

@onready var jump_sfx = $JumpSFX

@onready var wall_sfx = $WallSFX
var was_touching_wall = false

@export var gravity_scale : float = 1

@export var SPEED: float = 600.0
@export var JUMP_VELOCITY: float = -500.0
@export var WALL_JUMP_VELOCITY: float = -500.0
@export var ACCEL: float = 500.0

var facing = 1
var prefix = ""

@export var COYOTE_TIME_MAX: float = 4
var coyote_time = 0
@export var JUMP_BUFFER_MAX: float = 8
var jump_buffer = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func reset():
	light_switched_on()


func _physics_process(delta):
	handle_inputs(delta)
	move_and_slide()
	handle_animations()

func handle_inputs(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_scale

	# Coyote time.
	if coyote_time >= 0:
		coyote_time -= 1
	if is_on_floor():
		coyote_time = COYOTE_TIME_MAX
	# Jump buffering.
	if jump_buffer >= 0:
		jump_buffer -= 1
	# Jumping.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or coyote_time > 0):
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()
	elif Input.is_action_just_pressed("ui_accept") and is_on_wall():
		velocity.y = JUMP_VELOCITY
		velocity.x = -facing * WALL_JUMP_VELOCITY
		jump_sfx.play()
	elif Input.is_action_just_pressed("ui_accept"):
		jump_buffer = JUMP_BUFFER_MAX
	elif jump_buffer > 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()

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
		footsteps_timer.stop()
	elif velocity.x != 0.0:
		sprite.play(prefix + "run")
		if footsteps_timer.is_stopped(): footsteps_timer.start()
	else:
		sprite.play(prefix + "idle")
		footsteps_timer.stop()
	
	if is_on_wall():
		if was_touching_wall == false:
			wall_sfx.play()
		was_touching_wall = true
	else:
		was_touching_wall = false


func light_switched_off():
	prefix = "dark_"
	handle_animations()

func light_switched_on():
	prefix = ""
	handle_animations()


func _on_footsteps_timer_timeout():
	footsteps_sfx.play()
