extends Node

var current_objective: String
var general_objective : bool = true
@onready var ObjectiveLabel = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Objective/ObjectiveTexture/ObjectiveLabel")
var world_path : String = "/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/"

var objective_library = {
	"Talk to the baker": "NPC/Villagers/Baker",
	"Go fetch the bag of flour": "Objectives/Flour",
	"Return to the baker": "NPC/Villagers/Baker",
	"Go to bed": "Objectives/Bed",
	"Talk to the winery owner": "NPC/Villagers/WineDude",
	"Pick some grapes in the forest": "Objectives/Grapes",
	"Return to the winery owner": "NPC/Villagers/WineDude",
	"Return to bed": "Objectives/Bed",
	"Fetch the basket and Latern from the cart": "Objectives/Basket",
	"Get the bread from the baker": "NPC/Villagers/Baker",
	"Get the wine from the winery owner": "NPC/Villagers/WineDude",
	"Walk to grandma's house at the end of the dark forest": "Objectives/GrandmaDoor",
	"Talk to mother": "NPC/Villagers/Mother"
}
var mother_objective : int = 12

#Dayparts
var day_part_count : int = 0;
# 0 = Day 1 Morning
# 1 = Day 1 Day
# 2 = Day 1 Evening
# 3 = Day 1 Night
# 4 = Day 2 Morning
# 5 = Day 2 Day
# 6 = Day 2 Evening
# 7 = Day 2 Night
# 8 = Day 3 Morning
# 9 = Day 3 Day
# 10 = Day 3 Evening
# 11 = Day 3 Night

signal objectiveCompleted

func set_Objective(objective:String):
	ObjectiveLabel.text = objective
	
func load_Next_Objective():
	if (day_part_count == 0 or day_part_count == 4 or day_part_count == 8) and general_objective:
		#disable objective on the current objective
		var old_objective = get_tree().root.get_node(world_path + objective_library.values()[mother_objective] + "/StaticBodyInteraction")
		old_objective.remove_from_group("Objective")
		#set the new objective text
		set_Objective(objective_library.keys()[day_part_count])
		#enable objective on the new objective
		var new_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
		new_objective.add_to_group("Objective")
		#next load = not mother
		general_objective = false
		return
	
	if (day_part_count == 3 or day_part_count == 7):
		#next load = mother
		general_objective = true
		#disable objective on the current objective
		var old_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
		old_objective.remove_from_group("Objective")
		#increase day part by one
		day_part_count += 1
		#set the new objective text
		set_Objective(objective_library.keys()[mother_objective])
		#enable objective on the new objective
		var new_objective = get_tree().root.get_node(world_path + objective_library.values()[mother_objective] + "/StaticBodyInteraction")
		new_objective.add_to_group("Objective")
		return
	
	if (day_part_count == 11):
		#no more objectives to complete
		set_Objective("You finished the game!")
		return
	
	#disable objective on the current objective
	var old_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
	old_objective.remove_from_group("Objective")
	#increase day part by one
	day_part_count += 1
	#set the new objective text
	set_Objective(objective_library.keys()[day_part_count])
	#enable objective on the new objective -> currently disabled because not all objective models don't exist yet - would error
	#var new_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
	#new_objective.add_to_group("Objective")
