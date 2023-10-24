extends RayCast3D
#@onready var player = $"../../.."
var dialogue = false

func _ready():
	DialogueManager.connect("dialogue_started", dialogue_active)
	DialogueManager.connect("dialogue_ended", dialogue_inactive)

func _physics_process(_delta):
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Prompt").text = ""
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Crosshair").self_modulate = Color("#ffffff")
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Prompt").text = detected.get_prompt()
			get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/UI/Crosshair").self_modulate = Color("#770000")
			if Input.is_action_just_pressed(detected.prompt_action) and !dialogue:
				detected.interact(owner)
				
func dialogue_active():
	dialogue = true

func dialogue_inactive():
	dialogue = false
