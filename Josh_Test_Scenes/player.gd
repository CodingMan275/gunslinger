extends CharacterBody2D 








"""
All just nonsense, ignore and make proper player class here

#Movement tutorial https://www.youtube.com/watch?v=uNReb-MHsbg
#The player character does drift but this is just for something to show
#we have multiplayer

#Constant variables for how fast and slow the player moves
const Friction = 500
const MAX_SPEED = 300
const ACCELERATIOB = 300

#Player ID which will be determined on creation
#Based on number of current connected peers
#@onready var Player_ID = 1 + multiplayer.get_peers().size()
@export var Player_ID = 1

signal Get_Order



#When Host instantitates the play it is given special player 1 priviliges
#Also giving it an ID based on number of peers messed it up

	
#When the player is spawned into the 'tree' or scene it is giving
#itself authority to itself multiplayer wise. Basically it gives you control
#over your character

func _enter_tree():
	set_multiplayer_authority(name.to_int())
#	print(Player_ID)
#	print(multiplayer.get_peers().size())


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
#Receives this signal#

#Signal from world controller on what turn it is
#@rpc("call_local")
func _on_tile_map_send_turn(Turn_Order) -> void:
	if(Player_ID == Turn_Order):
		$CanvasLayer/TextEdit.show()
	else:
		#$CanvasLayer/Button.hide()
		$CanvasLayer/TextEdit.hide()
	pass # Replace with function body.
@rpc("call_local")
func _on_button_2_pressed() -> void:
	Player_ID = multiplayer.get_unique_id()
	print(Player_ID)
	pass # Replace with function body.
	
"""
