extends Control

@onready var panels = %Panels
var panels_array = []
var current = 0

func _ready():
	# place all the character sheets in an array for next/prev operation
	panels_array = panels.get_children()
	#var ps = panels.get_children()
	#for p in ps:
	#	panels_array.append(p)
	


func _on_button_pressed():
	get_parent().hide()


func _on_previous_button_pressed():
	# hide CURRent panel
	var curr : Panel =  panels_array[current]
	curr.hide()
	# calculate index of previous panel
	current = (panels_array.size() + current - 1) % panels_array.size()
	# show next panel
	curr = panels_array[current]
	curr.show()


func _on_next_button_pressed():
	# hide CURRent panel
	var curr : Panel =  panels_array[current]
	curr.hide()
	# calculate index of next  panel
	current = (current + 1) % panels_array.size()
	# show next panel
	curr = panels_array[current]
	curr.show()
	
