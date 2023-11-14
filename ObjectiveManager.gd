extends Node

var current_objective: String
var general_objective : bool = true
@onready var ObjectiveLabel = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Objective/ObjectiveTexture/ObjectiveLabel")
var world_path : String = "/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/World/"

var objective_library = {
	"Talk to the baker": "NPC/Villagers/Baker",
	"Go fetch the bag of flour": "NavRegion/Objectives/Flour",
	"Return to the baker": "NPC/Villagers/Baker",
	"Go to bed": "NavRegion/Objectives/Bed",
	"Talk to the winery owner": "NPC/Villagers/WineDude",
	"Pick some grapes in the forest": "NavRegion/Objectives/Grapes",
	"Return to the winery owner": "NPC/Villagers/WineDude",
	"Return to bed": "NavRegion/Objectives/Bed",
	"Grab the basket and Lantern from table": "NavRegion/Objectives/Basket",
	"Get the bread from the baker": "NavRegion/Objectives/Bread",
	"Get the wine from the winery owner": "NavRegion/Objectives/Winebottle",
	"Walk to grandma's house at the end of the dark forest": "NavRegion/Objectives/GrandmaDoor",
	"Talk to mother": "NPC/Villagers/Mother"
}
var npc_list = [
	"NPC/Villagers/Man1",
	"NPC/Villagers/Man2",
	"NPC/Villagers/Man3",
	"NPC/Villagers/Man4",
	"NPC/Villagers/Man5",
	"NPC/Villagers/Woman1",
	"NPC/Villagers/Woman2",
	"NPC/Villagers/Woman3",
	"NPC/Villagers/Woman4",
	"NPC/Villagers/Woman5",
	"NPC/Villagers/Kid1",
	"NPC/Villagers/Kid2",
	"NPC/Villagers/Boy"
]
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
		#re-enabling all npcs
		for npc in npc_list:
			var npcitem = get_tree().root.get_node(world_path + npc)
			npcitem.show()
			npcitem.get_node("StaticBodyInteraction").set_collision_layer_value(4, true)
		SaveLoad.save_game()
		return
	
	if (day_part_count == 11):
		#no more objectives to complete
		set_Objective("You reached grandma with all the items!")
		return
		
	if (day_part_count == 8):
		get_tree().root.get_node(world_path + "Player/OmniLight3D").show()
	
	if (day_part_count == 2 or day_part_count == 6 or day_part_count == 10):
		for npc in npc_list:
			var npcitem = get_tree().root.get_node(world_path + npc)
			npcitem.hide()
			npcitem.get_node("StaticBodyInteraction").set_collision_layer_value(4, false)
			
	#disable objective on the current objective
	var old_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
	old_objective.remove_from_group("Objective")
	if (day_part_count == 1 or day_part_count == 5 or day_part_count == 8 or day_part_count == 9 or day_part_count == 10):
		get_tree().root.get_node(world_path + objective_library.values()[day_part_count]).queue_free()
	#increase day part by one
	day_part_count += 1
	#save
	SaveLoad.save_game()
	#set the new objective text
	set_Objective(objective_library.keys()[day_part_count])
	#for some objectives - in day 3 - we only now show them
	if (day_part_count == 9 or day_part_count == 10):
		get_tree().root.get_node(world_path + objective_library.values()[day_part_count]).show()
		get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction").set_collision_layer_value(4, true)
	#enable objective on the new objective -> currently disabled because not all objective models don't exist yet - would error
	var new_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
	new_objective.add_to_group("Objective")
#
#func _input(event):
##	pass
##	if event.is_action_pressed("ui_accept"):
##		lighting_strike = true;
#	if event.is_action_pressed("skiptime"):
#		day_part_count += 1

func load_Current_Objective():
	if (day_part_count > 1 and get_tree().root.get_node(world_path + objective_library.values()[1]) != null):
		get_tree().root.get_node(world_path + objective_library.values()[1]).queue_free()
	if (day_part_count > 5 and get_tree().root.get_node(world_path + objective_library.values()[5]) != null):
		get_tree().root.get_node(world_path + objective_library.values()[5]).queue_free()
	if (day_part_count > 8 and get_tree().root.get_node(world_path + objective_library.values()[8]) != null):
		get_tree().root.get_node(world_path + objective_library.values()[8]).queue_free()
		get_tree().root.get_node(world_path + "Player/OmniLight3D").show()
	if (day_part_count > 9 and get_tree().root.get_node(world_path + objective_library.values()[9]) != null):
		get_tree().root.get_node(world_path + objective_library.values()[9]).queue_free()
	if (day_part_count > 10 and get_tree().root.get_node(world_path + objective_library.values()[10]) != null):
		get_tree().root.get_node(world_path + objective_library.values()[10]).queue_free()
	
	var sky = get_tree().root.get_node(world_path + 'sky').get_environment()
	if (day_part_count > 2):
		sky.fog_enabled = true
		sky.fog_density = 0.0005
		sky.fog_sky_affect = 0.2
		sky.fog_light_color = Color(0.24, 0.23, 0.39, 1)
		
	if (day_part_count > 7):
		sky.volumetric_fog_enabled = true
		sky.volumetric_fog_sky_affect = 0.75
		sky.volumetric_fog_albedo = Color(0.76, 0.64, 0.70, 1)
	
	if (day_part_count == 0 or day_part_count == 4 or day_part_count == 8):
		general_objective = true
		return
	
	#if not 0 4 8 -> remove mother and load current objective
	#disable objective on the current objective
	var old_objective = get_tree().root.get_node(world_path + objective_library.values()[mother_objective] + "/StaticBodyInteraction")
	old_objective.remove_from_group("Objective")
	#set the new objective text
	set_Objective(objective_library.keys()[day_part_count])
	#for some objectives - in day 3 - we only now show them
	if (day_part_count == 9 or day_part_count == 10):
		get_tree().root.get_node(world_path + objective_library.values()[day_part_count]).show()
		get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction").set_collision_layer_value(4, true)
	#enable objective on the new objective -> currently disabled because not all objective models don't exist yet - would error
	var new_objective = get_tree().root.get_node(world_path + objective_library.values()[day_part_count] + "/StaticBodyInteraction")
	new_objective.add_to_group("Objective")
	
	if (day_part_count == 3 or day_part_count == 7 or day_part_count == 11):
		for npc in npc_list:
			var npcitem = get_tree().root.get_node(world_path + npc)
			npcitem.hide()
			npcitem.get_node("StaticBodyInteraction").set_collision_layer_value(4, false)
