extends CharacterBody2D 

#Movement tutorial https://www.youtube.com/watch?v=uNReb-MHsbg
#The player character does drift but this is just for something to show
#we have multiplayer

#Constant variables for how fast and slow the player moves
const Friction = 500
const MAX_SPEED = 300
const ACCELERATIOB = 300


#When the player is spawned into the 'tree' or scene it is giving
#itself authority to itself multiplayer wise. Basically it gives you control
#over your character
func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
#Every tic or game update 'delta' the move function is being called
func _physics_process(delta):
	move(delta)
	
#Movement function
func move(delta):
	#Gets the current input from the custom input map which can be found in
	#project settings
	var input_vector = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	#If its not moving apply friction and slowdown
	if input_vector == Vector2.ZERO:
		apply_fric(Friction * delta)
	else:
		#Acctually move
		apply_movement(input_vector * ACCELERATIOB * delta)
		#this function lets the Character2dBody move
	move_and_slide()
	
	#Function to slow down the player
func apply_fric(amount):
	#apply friction to reduce velocity
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		#if its not moving it can not be slowed down anymore
		velocity = Vector2.ZERO
	
	#Accelerate and move
func apply_movement(Accel):
	#increase the players velocity to max speed
	velocity += Accel
	velocity = velocity.limit_length(MAX_SPEED)
	

#When the signal from the world turn order is actvated this function
#Receives this signal
func _on_tile_map_order(x) -> void:
	print("Player")
	print(x)
	pass # Replace with function body.
