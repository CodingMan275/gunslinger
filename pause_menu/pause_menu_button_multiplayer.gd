extends Button

@onready var pause_menu_multiplayer = %PauseMenuMultiplayer
@onready var pause_menu_button_multiplayer = %PauseMenuButtonMultiplayer


func _ready():
	if GlobalScript.SinglePlay == false:
		pause_menu_button_multiplayer.show()
		print("Multiplayer Button visible")

func _on_pressed():
	pause_menu_multiplayer.show()
