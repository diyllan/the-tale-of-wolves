extends Node3D

var load_saved_game = false
var save_path = "user://savegame.json"

#func _ready():
#	var file = FileAccess.new()
#	var file = FileAccess.open(save_path, FileAccess.READ)
#	load_data()
	
func save():
	var data = {
		"player" : $"../Player".to_dictionary(),
	}
	
#	var file = FileAccess.new()
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var json = JSON.new()
	var json_string = json.stringify(data)
	file.store_line(json_string)
	
func load_data():
	load_saved_game = true
#	var file = FileAccess.new()
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	if file.file_exists(save_path):
		file = FileAccess.open(save_path, FileAccess.READ)
		var json = JSON.new()
		var data = JSON.parse_string(file.get_as_text())
		
		$"../Player".from_dictionary(data.player)
		
func _input(event):
	if event.is_action_pressed("save"):
		save()
		print("saved game")
	if event.is_action_pressed("load"):
		load_data()
		print("loaded game")
