extends Button

@onready var pause_menu_singleplayer = %PauseMenuSingleplayer
@onready var pause_menu_button_singleplayer = %PauseMenuButtonSinglePlayer

func _ready():
	if GlobalScript.SinglePlay == true:
		pause_menu_button_singleplayer.show()
		print("Singleplayer Button visible")

func _on_pressed():
	pause_menu_singleplayer.show()
	print("Singleplayer Pause Menu open")
