extends "res://CPU_and_Player/Character.gd".Character
class_name Townsfolk

var is_hired_gun: bool = false
var townsfolk_list: Array = []
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
	if claim_revealed and is_owning_player(player) and has_gun and not get_is_stunned():
		return true
	return false
				
func can_brawl(player) -> bool:
	if claim_revealed and is_owning_player(player) and not get_is_stunned():
		return true
	return false
	
func can_move(player) -> bool:
	if not claim_revealed:
		return true
	elif is_owning_player(player):
		return true
	else:
		return false

func _on_specialAbilitiesButton_pressed()-> void:
	for townssfolk in townsfolk_list:
		activate_special_abilities(townsfolk)

func activate_special_abilities(townsfolk: Townsfolk) -> void:
	if townsfolk.is_hired_gun and not townsfolk.claim_revealed:
		townsfolk.reveal_hired_gun()
		print("Revealed hired gun ability for: ", townsfolk)
		if townsfolk.can_shoot(owning_player):
			print("Townsfolk can shoot!")
			if townsfolk.can_brawl(owning_player):
				print("Townsfolk can brawl!")
				if townsfolk.can_move(owning_player):
					print("Townsfolk can move!")


		
	
