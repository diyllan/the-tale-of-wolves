extends StaticBody3D

func _physics_process(_delta):
	if ObjectiveManager.day_part_count == 11:
		set_collision_layer_value(1, false)
