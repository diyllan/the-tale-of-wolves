extends Control

@onready var _settings = $CanvasLayer/BookMenu/General
@onready var _sound_settings = $CanvasLayer/BookMenu/SoundSettings
@onready var _graphic_settings = $CanvasLayer/BookMenu/Graphics
@onready var _general_tab = $CanvasLayer/BookMenu/BookMenuTexture/MenuButtons/General
@onready var _sound_tab = $CanvasLayer/BookMenu/BookMenuTexture/MenuButtons/Sound
@onready var _graphics_tab = $CanvasLayer/BookMenu/BookMenuTexture/MenuButtons/Graphics
@onready var _continue_button = $CanvasLayer/BookMenu/General/VBoxContainer/Continue
@onready var _start_button = $CanvasLayer/BookMenu/General/VBoxContainer/Start
@onready var _bookmenu = $CanvasLayer/BookMenu
@onready var DayCycleIconAnim = $CanvasLayer/DayCycle/DayCycleIcons
@onready var _resolutionOptions = $CanvasLayer/BookMenu/Graphics/VBoxContainer/ResolutionButton
#@onready var _fullscreen_checkbox = $"CanvasLayer/BookMenu/Graphics/VBoxContainer/FullScreen Check"
@onready var crosshair = $CanvasLayer/Crosshair
@onready var _prompt = $CanvasLayer/Prompt

var isPaused = false

var resolutions = {"1280x720":Vector2i(1280,720),
"1920x1080":Vector2i(1920,1080),
"2560x1440":Vector2i(2560,1440),
"3840x2160":Vector2i(3840,2160),
"5120x1440":Vector2i(5120,1440)
}
var screensize = DisplayServer.screen_get_size()
# Called when the node enters the scene tree for the first time.
func _ready():
## REMOVE COMMENT FOR FINAL BUILD
#	_fullscreen_checkbox.button_pressed = true
	DayCycleIconAnim.play("FloatingIcons")
	AddResolutions()
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Pause") and !isPaused:
			isPaused = true
			_bookmenu.show()
			_continue_button.show()
			_start_button.hide()
			_general_tab.grab_focus()
			_sound_settings.hide()
			_graphic_settings.hide()
			_settings.show()
			crosshair.hide()
			_prompt.hide()
			_general_tab.button_pressed = true
			_sound_tab.button_pressed = false
			_graphics_tab.button_pressed = false
			$BookOpen_Close.play()
			get_tree().paused = true

	elif Input.is_action_just_pressed("Pause") and isPaused:
		isPaused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_bookmenu.hide()
		crosshair.show()
		_prompt.show()
		$BookOpen_Close.play()
		get_tree().paused = false

func _on_start_pressed():
	print("start game")

func _on_general_pressed():
	$PageTurn.play()
	_general_tab.button_pressed = true
	_sound_tab.button_pressed = false
	_graphics_tab.button_pressed = false
	_sound_settings.hide()
	_graphic_settings.hide()
	_settings.show()


func _on_sound_pressed():
	$PageTurn.play()
	_general_tab.button_pressed = false
	_sound_tab.button_pressed = true
	_graphics_tab.button_pressed = false
	_sound_settings.show()
	_graphic_settings.hide()
	_settings.hide()


func _on_graphics_pressed():
	$PageTurn.play()
	_general_tab.button_pressed = false
	_sound_tab.button_pressed = false
	_graphics_tab.button_pressed = true
	_sound_settings.hide()
	_graphic_settings.show()
	_settings.hide()


func _on_quit_pressed():
	$BookOpen_Close.play()
	await $BookOpen_Close.finished
	get_tree().quit()


func _on_continue_pressed():
	isPaused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_bookmenu.hide()
	crosshair.show()
	_prompt.show()
	$BookOpen_Close.play()
	get_tree().paused = false


func _on_full_screen_check_toggled(button_pressed):
	if button_pressed:
		_resolutionOptions.disabled = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if !button_pressed:
		_resolutionOptions.disabled = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
