extends Control

@onready var continueBtn = $VBoxContainer/Continue
@onready var BookSettings = $BookSettings
var file = FileAccess.open(SaveLoad.save_path, FileAccess.READ)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	if file.file_exists(SaveLoad.save_path):
#		continueBtn.disabled = false
	pass
func _on_start_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().root.get_node("/root/ViewportShaders/PSXLayer/BlurPostProcess/SubViewport/LCDOverlay/SubViewport/DitherBanding/SubViewport/Prologue/Camera3D/AnimationPlayer").play("CameraMovement1")
	$VBoxContainer.hide()
	var tween = create_tween()
	tween.tween_property($Title, "modulate:a", 0, 1)
	SoundManager.playAmbience("Prologue_forest_ambience")
	SoundManager.lowerLastMusicVolume()
	

func _on_continue_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	BookSettings.show()


func _on_close_pressed():
	BookSettings.hide()
