extends CharacterBody2D

const R = 130.0
const k = 10.0
const epsilon = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var stage = 0
var acceleration = Vector2(0,0)

var x_0
var C
var C_static = Vector2(0,0)
var timer = 0.0
var last_launch = -15.0

var speed_modifier

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
	if(visible):
		C = get_tree().get_first_node_in_group("player").position
		
		speed_modifier = 1 + timer/15.0
		var monster_speed = 5.0 + speed_modifier
			
		#print(stage)
		#print("v:")
		#print(velocity)
		#print("a:")
		#print(acceleration)
		#print("r:")
		#if(stage < 2):
			#print(length(position - C))
		#else:
			#print(length(position - C_static))
		
		# finding the circle
		if stage == 0:
			
			var u = position - C
			var d = sqrt(dot(u,u) + R*R)
			var alpha = atan2(-u.y,-u.x)
			var beta = atan2(R,length(u))
			var theta = alpha - beta
		
			acceleration = -2*(position - C - velocity * 8.0)/(8.0*8.0)

			#steering
			if length(u) < 3.5*R and length(u) > R + epsilon and dot(velocity, u) < 0:
				if(length(u) > 2*R):
					velocity += acceleration * delta
				
				var unit_v = normalize(velocity)
				var n = normalize(position - C)
				
				var b = dot(2*unit_v, n)
				var c = dot(n,n) - exponent(R, 2)
				
				if b*b - 4*c > 0:
					acceleration = Vector2(0,0)
					var unit_a_c = normalize(n - dot(n,unit_v) * unit_v)
					unit_a_c = normalize(unit_a_c - dot(unit_a_c, unit_v)*unit_v)
					
					var r = (dot(u,u) - exponent(R + epsilon, 2))/(2.0*(R + epsilon - dot(u,unit_a_c)))
					acceleration += dot(velocity, velocity)/r * unit_a_c

				
				else:
					if(length(u) > 2*R):
						velocity -= acceleration * delta
				
				
			elif length(position - C) > 2 * R && dot(u,velocity) > 0:
				acceleration -= 5.0 * (velocity + acceleration * delta)
				
			elif length(position - C) <= R + 2*epsilon:
				stage = 1
				position = C + normalize(position - C) * R
				velocity = velocity - length(velocity)*dot(normalize(-u), normalize(velocity))*normalize(-u)
				acceleration = length(velocity)*length(velocity)/R * normalize(-u)
			
		
		elif(stage == 1):
			var N = normalize(position - C)
			var T = normalize(velocity)
			position = C + N * R
			acceleration = -4*N
			velocity = velocity - length(velocity)*dot(N, normalize(velocity))*N
			if timer - last_launch > min(15.0 - speed_modifier, 3.0):
				stage = 2
				x_0 = position
				velocity = Vector2(0,0)
			
		elif stage == 2 or stage == 3:
			if stage == 2:
				C_static = C
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
				velocity = N * 1.0 *(2 * R + epsilon - length(position - C_static))
				
				if length(position - C_static) > 2*R:
					stage = 3
			elif(stage == 3):
				acceleration = F_sa + F_sb
				acceleration = dot(acceleration, -N) * -N
				
				if dot(-N, acceleration) <= 0 and length(position - C_static) < R:
					acceleration = Vector2(0,0)
					stage = 4
					last_launch = timer
					
		elif(stage == 4):
			if length(position - C_static) > 5 * R && dot(position - C_static,velocity) > 0:
				acceleration = -5.0*(velocity + acceleration * delta)
		
			if timer - last_launch > 1.7:
				stage = 0
				
		
		velocity += acceleration * delta
		position += velocity * delta
		timer += delta
		
		#print("\n")
		move_and_slide()
