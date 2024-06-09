extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const R = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var stage = 0
var acceleration = Vector2(0,0)

var k = 10.0
var x_0
var prev_C = Vector2(0,0)
var C_static

var epsilon = 10.0

var timer = 0.0
var last_launch = 0.0
func exponent(b, x):
	var result = 1
	while x > 0:
		result  *= b
		x = x - 1
	return result

func length(vector):
	return sqrt(vector.x*vector.x + vector.y*vector.y)
	
func dot (vec1, vec2):
	return vec1.x * vec2.x + vec1.y*vec2.y
	
func normalize(vec):
	return vec/length(vec)
	
func _physics_process(delta):
	
	var C = get_viewport().get_mouse_position()
	
	
	#C = Vector2(100,150)
	#position = Vector2(0,0)
		
	print(stage)
	#print("v:")
	#print(velocity)
	#print("a:")
	#print(acceleration)
	print("r:")
	if(stage < 2):
		print(length(position - C))
	else:
		print(length(position - C_static))
	
	# finding the circle
	if stage == 0:
		
		var u = C - position
		var d = sqrt(dot(u,u) + R*R)
		var alpha = atan2(u.y,u.x)
		var beta = atan2(R,length(u))
		var theta = alpha - beta
		if(C != prev_C):
			x_0 = Vector2(position.x + d * cos(theta), position.y + d * sin(theta))
	
		acceleration = (2*(C - position))/(5*5)
		#steering
		if length(position - C) < 4*R and length(position - C) > R + epsilon and dot(velocity, u) > 0:
			var n = normalize(C - position)
			var unit_v = normalize(velocity)
			var unit_a_c = normalize(n - dot(n,unit_v) * unit_v)
			
			var r = (dot(u,u) - exponent(R + epsilon, 2))/(2*(R + epsilon - dot(u,unit_a_c)))
			acceleration = dot(velocity, velocity)/r * unit_a_c
			acceleration = acceleration - dot(acceleration, unit_v)*unit_v
			
		elif length(position - C) > 5 * R && dot(u,velocity) < 0:
			acceleration += -(velocity + acceleration * delta)/5
			
		elif length(position - C) < R + 1.1* epsilon:
			stage = 1
			u = x_0 - C
			x_0 = C + normalize(u) * R
			velocity = velocity - dot(normalize(u), velocity)*normalize(u)
		
	
	elif(stage == 1):
		position = C + normalize(position - C) * R
		#acceleration = dot(velocity, velocity)/R * normalize(position - C)
		if timer - last_launch > 5.0:
			stage = 2
			C_static = C
			x_0 = position
			velocity = Vector2(0,0)
		
	elif stage == 2 or stage == 3:
		var T = normalize(Vector2((x_0 - C_static).y, (C_static - x_0).x))
		var N = normalize(x_0 - C_static)
		var a = C_static + R * T
		var b = C_static - R * T
		var s_a = position - a
		var s_b = position - b
		
		var r = sqrt(2*R*R)
		var F_sa = (-k * (length(s_a) - r)) * normalize(s_a)
		var F_sb = (-k * (length(s_b) - r)) * normalize(s_b)
		
		if(stage == 2):
			acceleration = Vector2(0,0)
			velocity = N * 1.0 *(2* R + epsilon - length(position - C_static))
			
			if length(position - C_static) > 2*R:
				stage = 3
		elif(stage == 3):
			acceleration = F_sa + F_sb
			acceleration = dot(acceleration, -N) * -N
			
			print(acceleration)
			print(velocity)
			if dot(-N, acceleration) <= 0 and length(position - C_static) < R:
				acceleration = Vector2(0,0)
				stage = 4
				last_launch = timer
				
	elif(stage == 4):
		print(timer)
		print(last_launch)
		if length(position - C) > 5 * R && dot(position - C,velocity) > 0:
			acceleration = -(velocity + acceleration * delta)
	
		if timer - last_launch > 1.0:
		
			stage = 0
			
	
	velocity += acceleration * delta
	position += velocity * delta
	timer += delta
	prev_C = C
	
	print("\n")
	move_and_slide()
