extends CharacterBody2D

#movement stuff
const Friction = 500
const MAX_SPEED = 300
const ACCELERATIOB = 300


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	
func _physics_process(delta):
	move(delta)
	
	
func move(delta):
	var input_vector = Input.get_vector("Move_Left","Move_Right","Move_Up","Move_Down")
	if input_vector == Vector2.ZERO:
		apply_fric(Friction * delta)
	else:
		apply_movement(input_vector * ACCELERATIOB * delta)
	move_and_slide()
	
	
func apply_fric(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
	
func apply_movement(Accel):
	velocity += Accel
	velocity = velocity.limit_length(MAX_SPEED)
	
	
