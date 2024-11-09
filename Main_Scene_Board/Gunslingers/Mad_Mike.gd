extends Node


var KnifeProf = 1
var PistolProf = 0
var RifleProf = -1
var ShotgunProf = 0
var TwinPistolProf = 0
var BrawlProf = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	get_parent().Weapon1Name = "Shotgun"
	get_parent().Weapon1Dmg = 4
	get_parent().Weapon1Stun = 2
	get_parent().Weapon1Range = 0
	
	get_parent().Weapon2Name = "Bowie_Knife"
	get_parent().Weapon2Dmg = 2
	get_parent().Weapon2Stun = 1
	get_parent().Weapon2Range = 0
	
	get_parent().KnifeProf = KnifeProf
	get_parent().PistolProf = PistolProf
	get_parent().RifleProf = RifleProf
	get_parent().ShotgunProf = ShotgunProf
	get_parent().TwinPistolProf = TwinPistolProf
	get_parent().BrawlProf = BrawlProf

	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func Special():
	pass
	
func Weapon():
	pass
