extends "res://CPU_and_Player/Character.gd".Character
class_name Sheriff

@onready var TownieLogic = get_parent()

@export var is_hired_gun: bool = false
var OwningPlayer

# Weapon proficiency
var KnifeProf = 0
var PistolProf = 1
var RifleProf = 1
var ShotgunProf = 0
var TwinPistolProf = 0
var BrawlProf = 1



# Jail state variables
var is_in_jail: bool = false
var jail_turns_remaining: int = 0
var shuffle_count: int = 0

func _init():
	pass

func _ready() -> void:
	Name = get_name()
	get_node("../../Cards").DrawnCard.connect(hire_townsfolk)
	rules = get_parent().get_parent().get_node("Rules_Controller")
	cards = get_parent().get_parent().get_node("Cards")

func hire_townsfolk(card, FirstDraw, player):
	hire_rpc.rpc(card, FirstDraw, player)

@rpc("call_local", "any_peer")
func hire_rpc(x, y, z):
	if (y and (x == "Sheriff")):
		OwningPlayer = z + 1
		is_hired_gun = true
		print("Hired Player")

func reveal_hired_gun() -> void:
	reveal_rpc.rpc()

@rpc("call_local", "any_peer")
func reveal_rpc():
	claim_revealed = true

# Special ability function to move character to jail
func activate_special_ability(target_character):
	if target_character.position == self.position and not target_character.is_in_jail:
		target_character.move_to_jail()
		print("Target moved to jail")

func move_to_jail():
	is_in_jail = true
	jail_turns_remaining = 3  # Target cannot act for 3 turns
	print(Name + " has been jailed.")

# Check if the character can act
func can_act() -> bool:
	return not is_in_jail

# Handle turn logic
func end_turn():
	if is_in_jail:
		jail_turns_remaining -= 1
		if jail_turns_remaining <= 0:
			is_in_jail = false
			print(Name + " can now act again.")
	
	if shuffle_count >= 3:
		print(Name + " can leave jail after the deck has been shuffled 3 times.")
		# Allow leaving jail logic here


func shuffle_deck():
	shuffle_count += 1
	print("Deck shuffled. Shuffle count: " + str(shuffle_count))
