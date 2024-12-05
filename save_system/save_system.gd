extends Node

"""
Since we have many nodes as part of the game, and several people
developing those nodes, a common interface is needed to make sure
we save and restore the nodes needed during  game play.

1. We need to create group, called SaveGame, and add to it all
nodes used during game play that have data we need to save

2. Each one of those nodes, needs to implement the following three functions
   a. get_save_id() : returns a unique id for this node as a string.
	  Apparently, Godot does not have UUIDs, so we have to make our own.
   b. save(): this methods returns a dictionary with the data that node
	  needs to save/restore during gameplay.
	  Here is an example from an unrelated game
		  func save():
			var save_dict = {
				"filename" : get_scene_file_path(),
				"parent" : get_parent().get_path(),
				"pos_x" : position.x, # Vector2 is not supported by JSON
				"pos_y" : position.y,
				"attack" : attack,
				"defense" : defense,
				"current_health" : current_health,
				"max_health" : max_health,
				"damage" : damage,
				"regen" : regen,
				"experience" : experience,
				"tnl" : tnl,
				"level" : level,
				"attack_growth" : attack_growth,
				"defense_growth" : defense_growth,
				"health_growth" : health_growth,
				"is_alive" : is_alive,
				"last_attack" : last_attack
			}
			return save_dict
	c. restore(saved_data): this method gets a dictionary of previously saved data
	   and uses it to restore the state of the node. This is the same dictonary
	   structure returned by save().
	
"""

var game_saved = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("user://savegame.save"):
		game_saved = true
	pass # Replace with function body.


func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("SaveGame")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		if !node.has_method("get_save_id"):
			print("persistent node '%s' is missing a save_game_id() function, skipped" % node.name)
			continue

		# Call the node's save function. Get dictionary of data to save
		var node_data = node.call("save")
		
		# save node's id in save dictionary. For later knowing who owns what saved data
		node_data["save_id"] = node.call("get_save_id")
		
		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
		
	save_file.close()
	game_saved = true
	print("Game saved")

func restore_game():
	# under construction
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state. But first we need to map
	# save_ids to the current reference to the save nodes
	var save_nodes_dict = {}
	var save_nodes = get_tree().get_nodes_in_group("SaveGame")
	for node in save_nodes:
		if !node.has_method("get_save_id"):
			print("restore: persistent node '%s' is missing a save_game_id() function, skipped" % node.name)
			continue
		save_nodes_dict[node.call("get_save_id")] = node
		
	# Load the file line by line 
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		# get save_id from saved data
		var key = node_data['save_id']
		
		# get node with that id
		var restore_node = save_nodes_dict[key]
		
		# call restore() on that node to restore its saved data
		restore_node.call("restore", node_data)
		
	save_file.close()
	
	print("Game restored")
	
	# delete saved data
	#DirAccess.remove_absolute("user://savegame.save")
	#game_saved = false
