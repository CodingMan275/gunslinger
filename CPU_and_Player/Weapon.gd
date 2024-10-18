enum WEAPON_TYPE {KNIFE, BOWIE, PISTOL, DERRINGER, TWIN, RIFLE, BUFFALO, SHOTGUN}
	
class Weapon:
	
	var weapon_type : WEAPON_TYPE
	const is_gun : bool = false
	
	var damage: int
	
	func get_is_gun() -> bool:
		return is_gun
		
	func get_damage() -> int:
		return damage
	
	# Called when the node enters the scene tree for the first time.
	func _ready() -> void:
		pass # Replace with function body.


	# Called every frame. 'delta' is the elapsed time since the previous frame.
	func _process(delta: float) -> void:
		pass
