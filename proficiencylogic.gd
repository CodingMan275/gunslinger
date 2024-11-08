extends Node


@onready var rules = get_node("../Rules_Controller")
@onready var Weapon = get_node("res://CPU_and_Player/Character.gd")


var Target : Node2D
var proficiency
# Called when the node enters the scene tree for the first time.

func TownieProficiencyCalc(guy : String) -> int:
	Target = rules.Townie.get_node(guy)
	if(Weapon.Weapon1Name == "Knife"):
		proficiency = Target.KnifeProf
	elif(Weapon.Weapon1Name == "Rifle"):
		proficiency = Target.RifleProf
	elif(Weapon.Weapon1Name == "TwinPistol"):
		proficiency = Target.TwinPistolProf
	elif(Weapon.Weapon1Name == "Pistol"):
		proficiency == Target.PistolProf
	elif(Weapon.Weapon1Name == "Shotgun"):
		proficiency = Target.ShotgunProf
	else:
		proficiency = Target.BrawlProf
	return proficiency
	
func GunslingerProficiencyCalc(guy : int) -> int:
	Target = GlobalScript.PlayerNode[guy-1]
	if(Weapon.Weapon1Name == "Knife"):
		proficiency = Target.KnifeProf
	elif(Weapon.Weapon1Name == "Rifle"):
		proficiency = Target.RifleProf
	elif(Weapon.Weapon1Name == "TwinPistol"):
		proficiency = Target.TwinPistolProf
	elif(Weapon.Weapon1Name == "Pistol"):
		proficiency == Target.PistolProf
	elif(Weapon.Weapon1Name == "Shotgun"):
		proficiency = Target.ShotgunProf
	else:
		proficiency = Target.BrawlProf
	return proficiency
