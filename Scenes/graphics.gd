extends Control

var resolutions = {"1280x720":Vector2i(1280,720),
"1920x1080":Vector2i(1920,1080),
"2560x1440":Vector2i(2560,1440),
"3840x2160":Vector2i(3840,2160),
"5120x1440":Vector2i(5120,1440)
}
var screensize = DisplayServer.screen_get_size()

@onready var _resolutionOptions = $VBoxContainer/ResolutionButton
@onready var _fullscreen_checkbox = $"FullScreen Check"

func _ready():
	AddResolutions()
	## REMOVE COMMENT FOR FINAL BUILD
#	_fullscreen_checkbox.button_pressed = true

func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		AddResolutions()
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			_fullscreen_checkbox.button_pressed = true
		else:
			_fullscreen_checkbox.button_pressed = false
		
func AddResolutions():
	var index = 0
	for r in resolutions:
		_resolutionOptions.add_item(r)
		if resolutions[r] == screensize:
			_resolutionOptions.select(index)
		index +=1
		
func _on_resolution_button_item_selected(_index):
	var sizeRes = resolutions.get(_resolutionOptions.get_item_text(_resolutionOptions.get_selected_id()))
	DisplayServer.window_set_size(sizeRes)

func _on_full_screen_check_toggled(button_pressed):
	if button_pressed:
		_resolutionOptions.disabled = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if !button_pressed:
		_resolutionOptions.disabled = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
