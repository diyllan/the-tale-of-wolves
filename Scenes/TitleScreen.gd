extends Control

@onready var continueBtn = $VBoxContainer/Continue
var file = FileAccess.open(SaveLoad.save_path, FileAccess.READ)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if file.file_exists(SaveLoad.save_path):
#		continueBtn.disabled = false
	pass
func _on_start_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"..".titleScreen = false
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/Prologue/Camera3D/AnimationPlayer").play("CameraMovement1")
	$VBoxContainer.hide()
	var tween = create_tween()
	tween.tween_property($Title, "modulate:a", 0, 1)
	

func _on_continue_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
