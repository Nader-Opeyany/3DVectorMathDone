extends CharacterBody3D
signal hit
signal deathMusic
#How fast the player moves in meters per second
@export var speed = 14
# The downward acceleration when in air
@export var fall_acceleration = 75

@export var jump_impulse = 20

@export var bounceImpulse = 16

#@onready var deathSound : AudioStreamPlayer3D = $dead
#https://www.youtube.com/watch?v=6e1AGG88Jxk
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction =Vector3.ZERO
	
	#Check for the 4 cardinal directions
	#XZ axis for cardinal plane
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z +=1
	if Input.is_action_pressed("ui_up"):
		direction.z -=1
		
	if direction != Vector3.ZERO: #if pressed
		direction = direction.normalized()
		#Setting the basis will affect the direction our char is facing
		$Pivot.basis = Basis.looking_at(direction)
	
	#controlling the speed if the character input is pressed

	if direction != Vector3.ZERO:
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
	#how to move your character
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor(): #Does this not turn negative? Possible absolute function?
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	#iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		#we get one of the collisions with the player
		var collision = get_slide_collision(index)
		
		#if the collision is with ground
		if collision.get_collider() == null:
			continue
		#if collider is with a mob
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			#We check that we are hitting it from aboce.
			if Vector3.UP.dot(collision.get_normal()) > .1:
				#if so, we squash it and bounce.
				mob.squash()
				target_velocity.y = bounceImpulse
				#prevent further duplicate calls
				break
			
		
		
	#Moving the Character
	velocity = target_velocity
	move_and_slide()
		



	
func die():
	hit.emit()
	queue_free()
	
func _on_mob_detector_body_entered(body):
	#$dead.play() https://www.youtube.com/watch?v=6e1AGG88Jxk
	print("This is playing now!")
	die()


