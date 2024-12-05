extends Node


@onready var rules = get_node("../Rules_Controller")



var Target : Node2D
var proficiency
# Called when the node enters the scene tree for the first time.

func TownieProficiencyCalc(guy : String) -> int:
	Target = rules.Townie.get_node(guy)
	if(Target.Weapon1Name == "Knife"):
		proficiency = Target.KnifeProf
	elif(Target.Weapon1Name == "Rifle"):
		proficiency = Target.RifleProf
	elif(Target.Weapon1Name == "TwinPistol"):
		proficiency = Target.TwinPistolProf
	elif(Target.Weapon1Name == "Pistol"):
		proficiency == Target.PistolProf
	elif(Target.Weapon1Name == "Shotgun"):
		proficiency = Target.ShotgunProf
	else:
		proficiency = Target.BrawlProf
	return proficiency
	
func GunslingerProficiencyCalc(guy : int) -> int:
	Target = GlobalScript.PlayerNode[guy]
	if(Target.Weapon1Name == "Knife"):
		proficiency = Target.KnifeProf
	elif(Target.Weapon1Name == "Rifle"):
		proficiency = Target.RifleProf
	elif(Target.Weapon1Name == "TwinPistol"):
		proficiency = Target.TwinPistolProf
	elif(Target.Weapon1Name == "Pistol"):
		proficiency == Target.PistolProf
	elif(Target.Weapon1Name == "Shotgun"):
		proficiency = Target.ShotgunProf
	else:
		proficiency = Target.BrawlProf
	return proficiency
