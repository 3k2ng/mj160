extends CharacterBody2D


@onready var sprite = $AnimatedSprite2D

@export var gravity_scale : float = 1

@export var SPEED = 600.0
@export var JUMP_VELOCITY = -5000.0

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
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_wall()):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_animations():
	if not is_on_floor():
		sprite.play("jump")
	elif velocity.x != 0.0:
		sprite.play("run")
	else:
		sprite.play("idle")
