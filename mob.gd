extends CharacterBody3D
signal squashed

#minimum speed of the mob in meters per second
@export var min_speed = 10
#Maximum speed of the mob in meters per seond
@export var max_speed = 18

func _physics_process(delta):
	move_and_slide()
	
func intialize(start_position,player_position):
	#We rotate the mob by placing it at start
	#and rotate it towardsd player_position, so it looks at the player
	look_at_from_position(start_position,player_position,Vector3.UP)
	#we need some randomness so it doesnt automatically pounce you
	#so that it doesnt move directly towards the player
	rotate_y(randf_range(-PI/4,PI/4))
	
	#now we get a random speed in between min and max
	var randomSpeed = randf_range(min_speed,max_speed)
	#now we turn this speed into a velocity
	velocity = Vector3.FORWARD * randomSpeed
	#We then rotate the celocity vector based on the mob's Y rotatoin
	#in order to move in the direction the mob is looking
	velocity = velocity.rotated(Vector3.UP,rotation.y)
	
func squash():
	squashed.emit()
	queue_free()




func _on_visible_on_screen_enabler_3d_screen_exited():
	queue_free()
