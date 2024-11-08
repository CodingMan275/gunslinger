extends Node

@onready var rules = get_node("../Rules_Controller")

#var interactable = false
var giving = false
var taking = false

var id
var curPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rules.guyClicked.connect(Action)
	rules.order.connect(hideme)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func Action():
	print(giving)
	if giving:
		var WepStats
	#	var curPlayer
		#Does the selected target have weapon 1 equiped?
		if rules.Target.Weapon1Equiped:
			if rules.Target.Weapon2Equiped:
				print("Cant take any more weapons")
				openGTWindow()
				giving = false
				taking = false
			else:
				curPlayer = rules.get_node(str(multiplayer.get_unique_id()))
				WepStats = WeaponStats(curPlayer.MidCard)
				if WepStats[0] != "No":
					rpcWeapon2.rpc(WepStats)
					giving = false
					if(curPlayer.get_node("CanvasLayer").Middle >4):
						curPlayer.PlayerHand.pop_at(curPlayer.get_node("CanvasLayer").Middle)
						curPlayer.get_node("CanvasLayer").MaxBound -= 1
						curPlayer.get_node("CanvasLayer").Middle -= 1
						curPlayer.get_node("CanvasLayer").MinBound -= 1
						curPlayer.get_node("CanvasLayer").refresh()
					elif(curPlayer.get_node("CanvasLayer").Middle == 4)	:
						
						curPlayer.PlayerHand.pop_at(curPlayer.get_node("CanvasLayer").Middle)
						curPlayer.get_node("CanvasLayer").MaxBound += 1
						curPlayer.get_node("CanvasLayer").Middle += 1
						curPlayer.get_node("CanvasLayer").MinBound += 1
						curPlayer.get_node("CanvasLayer").refresh()
				else:
					openGTWindow()
					giving = false
					taking = false
		else:
			curPlayer = rules.get_node(str(multiplayer.get_unique_id()))
			WepStats = WeaponStats(curPlayer.MidCard)
			if WepStats[0] != "No":
				rpcWeapon1.rpc(WepStats)
				print("Give wepaon 1")
				giving = false
				if(curPlayer.get_node("CanvasLayer").Middle > 4):
					curPlayer.PlayerHand.pop_at(curPlayer.get_node("CanvasLayer").Middle)
					curPlayer.get_node("CanvasLayer").MaxBound -= 1
					curPlayer.get_node("CanvasLayer").Middle -= 1
					curPlayer.get_node("CanvasLayer").MinBound -= 1
					curPlayer.get_node("CanvasLayer").refresh()
				elif(curPlayer.get_node("CanvasLayer").Middle == 4)	:
					curPlayer.PlayerHand.pop_at(curPlayer.get_node("CanvasLayer").Middle)
					curPlayer.get_node("CanvasLayer").MaxBound += 1
					curPlayer.get_node("CanvasLayer").Middle += 1
					curPlayer.get_node("CanvasLayer").MinBound += 1
					curPlayer.get_node("CanvasLayer").refresh()
				#curPlayer.PlayerHand.pop_at(curPlayer.get_node("CanvasLayer").Middle)
			else:
				openGTWindow()
				giving = false
				taking = false
	elif taking:
		print("TAKE")
		#var curPlayer
		if rules.Target.Weapon2Equiped:
			#Im so sorry im coding this while and high
			#fucked numbers man
			#jnwnjwnjnjfewikjgebgnrgjgnjWREWB;R RICE KRISPIUES
			$"../CanvasLayer/Weapon2".text = rules.Target.Weapon2Name
			$"../CanvasLayer/Weapon1".text = rules.Target.Weapon1Name
			$"../CanvasLayer/Weapon1".show()
			$"../CanvasLayer/Weapon2".show()
		else:
			$"../CanvasLayer/Weapon1".text = rules.Target.Weapon1Name
			$"../CanvasLayer/Weapon1".show()
	else:
		print(giving)
		
		
#@rpc("any_peer","call_local")
func takeWeapon1():
	#the room is spinning and the screen is blurry
	#and I can read a god dman thing but i press on
	curPlayer = rules.get_node(str(multiplayer.get_unique_id()))

	rpcWeapon1TAKESIES.rpc(str(multiplayer.get_unique_id()), 1)
	rules.Target.Weapon1Name = "nope"
	rules.Target.Weapon1Dmg = 0
	rules.Target.Weapon1Stun = 0
	rules.Target.Weapon1Range = 0
	rules.Target.Weapon1Equiped = false
#curPlayer.PlayerHand.append(rules.Target.Weapon1Name)
	$"../CanvasLayer/Weapon1".hide()
	$"../CanvasLayer/Weapon2".hide()
	
func takeWeapon2():
	curPlayer = rules.get_node(str(multiplayer.get_unique_id()))
	rpcWeapon1TAKESIES.rpc(str(multiplayer.get_unique_id()), 2)
	$"../CanvasLayer/Weapon2".hide()
	$"../CanvasLayer/Weapon1".hide()
	
	
func hideme(x):
	print("HIDING")
	$"../CanvasLayer/Weapon1".hide()
	$"../CanvasLayer/Weapon2".hide()
	$"../CanvasLayer/Take".hide()
	$"../CanvasLayer/GIve".hide()
	
@rpc("any_peer","call_local")
func rpcWeapon1TAKESIES(X, y):
	if y == 1:
		rules.get_node(X).PlayerHand.append(rules.Target.Weapon1Name)
	else:
		rules.get_node(X).PlayerHand.append(rules.Target.Weapon2Name)
	
	
		
@rpc("call_local","any_peer")
func rpcWeapon1(WepStats):
	rules.Target.Weapon1Name = WepStats[0]
	rules.Target.Weapon1Dmg = WepStats[1]
	rules.Target.Weapon1Stun = WepStats[2]
	rules.Target.Weapon1Range = WepStats[3]
	rules.Target.Weapon1Equiped = true
	
@rpc("call_local","any_peer")
func rpcWeapon2(WepStats):
	rules.Target.Weapon2Name = WepStats[0]
	rules.Target.Weapon2Dmg = WepStats[1]
	rules.Target.Weapon2Stun = WepStats[2]
	rules.Target.Weapon2Range = WepStats[3]
	rules.Target.Weapon2Equiped = true
	print("Give weapon 2")
pass
	
func openGTWindow():
	$"../CanvasLayer/Take".show()
	$"../CanvasLayer/GIve".show()
	$"../CanvasLayer/Give_Take".hide()
	pass
	
func giveWeapon():
	$"../CanvasLayer/Take".hide()
	$"../CanvasLayer/GIve".hide()
	giving = true
	id = multiplayer.get_unique_id()
	#test.rpc()
	print(giving)
	pass
	
@rpc("any_peer")
func test():
	giving = true
	
func takeWeapon():
	$"../CanvasLayer/Take".hide()
	$"../CanvasLayer/GIve".hide()
	taking = true
	pass


func WeaponStats(X):
	if X == "Knife":
		#Name, Damage, Stun, Range
		return ["Knife",1,0,0]
	elif X =="Bowie_Knife":
		return ["Bowie_Knife",2,1,0]
	elif X == "Pistol":
		return ["Pistol",2,1,1]
	elif X == "Derringer_Pistol":
		return ["Derringer_Pistol",1,1,1]
	elif X == "TwinPistol":
		return ["TwinPistol",2,1,1]
	elif X == "Rifle":
		return ["Rifle",3,2,2]
	elif X == "Shotgun":
		return ["Shotgun", 4,2,0]
	else:
		print(X)
		return ["No"]
	
	pass
