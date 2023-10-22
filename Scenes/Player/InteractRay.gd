extends RayCast3D
#@onready var player = $"../../.."
func _physics_process(_delta):
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Prompt").text = ""
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Crosshair").self_modulate = Color("#ffffff")
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Prompt").text = detected.get_prompt()
			get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Crosshair").self_modulate = Color("#770000")
			if Input.is_action_just_pressed(detected.prompt_action) and !get_parent().get_parent().get_parent().dialogueActive:
				detected.player = get_parent().get_parent().get_parent()
				detected.interact(owner)
				print_debug(detected.player)
