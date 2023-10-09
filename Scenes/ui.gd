extends Control

@onready var _settings = $CanvasLayer/General
@onready var _sound_settings = $CanvasLayer/SoundSettings
@onready var _graphic_settings = $CanvasLayer/Graphics
@onready var _general_tab = $CanvasLayer/BookMenu/BookMenuTexture/MenuButtons/General
@onready var _sound_tab = $CanvasLayer/BookMenu/BookMenuTexture/MenuButtons/Sound
@onready var _graphics_tab = $CanvasLayer/BookMenu/BookMenuTexture/MenuButtons/Graphics
# Called when the node enters the scene tree for the first time.
func _ready():
	_general_tab.button_pressed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_start_pressed():
	print("start game")

func _on_general_pressed():
	_general_tab.button_pressed = true
	_sound_tab.button_pressed = false
	_graphics_tab.button_pressed = false
	_sound_settings.hide()
	_graphic_settings.hide()
	_settings.show()



func _on_sound_pressed():
	_general_tab.button_pressed = false
	_sound_tab.button_pressed = true
	_graphics_tab.button_pressed = false
	_sound_settings.show()
	_graphic_settings.hide()
	_settings.hide()


func _on_graphics_pressed():
	_general_tab.button_pressed = false
	_sound_tab.button_pressed = false
	_graphics_tab.button_pressed = true
	_sound_settings.hide()
	_graphic_settings.show()
	_settings.hide()


func _on_quit_pressed():
	get_tree().quit()
