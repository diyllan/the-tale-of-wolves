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

var isPaused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	DayCycleIconAnim.play("FloatingIcons")


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
			_general_tab.button_pressed = true
			_sound_tab.button_pressed = false
			_graphics_tab.button_pressed = false
			get_tree().paused = true

	elif Input.is_action_just_pressed("Pause") and isPaused:
		isPaused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_bookmenu.hide()
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
	get_tree().quit()


func _on_continue_pressed():
	isPaused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_bookmenu.hide()
	get_tree().paused = false
