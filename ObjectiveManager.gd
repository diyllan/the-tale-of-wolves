extends Node

var current_objective: String
@onready var ObjectiveLabel = get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Objective/ObjectiveTexture/ObjectiveLabel")

func set_Objective(objective:String):
	ObjectiveLabel.text = objective
