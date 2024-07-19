extends Node

#handle the mob's generated
@export var mobScene: PackedScene

#attempting to control musicProgress
var musicProgress = 0

# Called when the node enters the scene tree for the first time.
func _ready():

	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_timer_timeout():
	#create a new instance of the mob scene
	var mob = mobScene.instantiate()
	
	#Choose a random location on the spawnpath
	#We store the reference to the spawnlocation node
	var mobSpawnLocation = get_node("spawnpath/spawnlocation")
	#and give it a random offset
	mobSpawnLocation.progress_ratio = randf()
	
	var playerPosition = $Player.position
	mob.intialize(mobSpawnLocation.position,playerPosition)
	add_child(mob)
	
	#This is the mob score label here
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
	print("THE GAME HAS ENDED!!!!")
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		#This restarts the current scene
		get_tree().reload_current_scene()
		
