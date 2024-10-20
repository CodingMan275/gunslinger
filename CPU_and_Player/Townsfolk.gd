extends "res://CPU_and_Player/Character.gd".Character
class_name Townsfolk

var is_hired_gun: bool = false
var claim_revealed: bool = false

func _init():
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hire_townsfolk(player: int) -> void:
	owning_player = player
	is_hired_gun = true

func reveal_hired_gun() -> void:
	claim_revealed = true

func can_shoot(player) -> bool:
	if claim_revealed and is_owning_player(player) and has_gun:
		return true
	return false
				
func can_brawl(player) -> bool:
	if claim_revealed and is_owning_player(player):
		return true
	return false
	
func can_move(player) -> bool:
	if not claim_revealed:
		return true
	elif is_owning_player(player):
		return true
	else:
		return false
	
