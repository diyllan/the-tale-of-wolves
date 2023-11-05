extends Node

var current_objective: String
@onready var ObjectiveLabel = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Objective/ObjectiveTexture/ObjectiveLabel")

var objectiveLibrary = {
	"Talk to the baker": "Baker",
	"Go fetch the bag of flour": "Flour",
	"Return to the baker": "Baker",
	"Go to bed": "Bed",
	"Talk to the winery owner": "WineDude",
	"Pick some grapes in the forest": "Grapes",
	"Return to the winery owner": "WineDude",
	"Return to bed": "Bed",
	"Fetch the basket and Latern from the cart": "Basket",
	"Get the bread from the baker": "Baker",
	"Get the wine from the winery owner": "WineDude",
	"Walk to grandma's house at the end of the dark forest": "GrandmaDoor",
	"Talk to mother": "Mother"
}

#Dayparts
var day_part_count = 0;
var day_count = 1;

signal objectiveCompleted

func set_Objective(objective:String):
	ObjectiveLabel.text = objective
	
func load_Next_Objective():
	pass
