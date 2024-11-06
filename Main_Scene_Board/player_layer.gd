extends TileMapLayer

enum TerrainType{
	
	# 7 BUILDING
	STORE = 1,
	CHURCH= 2,
	DOCTOR = 3,
	BANK = 4,
	SHERRIF = 5,
	SCHOOL = 6,
	SALOON = 7,
	# 3 Extras
	JAIL = 8,
	PATH = 9,
	STABLE = 10,
	# 6 BaordWalks
	STOREB = 11,
	BOOTHILL = 12,
	DOCTORB = 13,
	BANKB = 14,
	SHERRIFB = 15,
	YARD = 16
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
