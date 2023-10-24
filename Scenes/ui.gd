extends Control

@onready var _settings = $BookMenu/General
@onready var _sound_settings = $BookMenu/SoundSettings
@onready var _graphic_settings = $BookMenu/Graphics
@onready var _general_tab = $BookMenu/BookMenuTexture/MenuButtons/General
@onready var _sound_tab = $BookMenu/BookMenuTexture/MenuButtons/Sound
@onready var _graphics_tab = $BookMenu/BookMenuTexture/MenuButtons/Graphics
@onready var _continue_button = $BookMenu/General/VBoxContainer/Continue
@onready var _start_button = $BookMenu/General/VBoxContainer/Start
@onready var _bookmenu = $BookMenu
@onready var DayCycleIconAnim = $DayCycle/DayCycleIcons
@onready var dialogueAnim = $Dialogue/Indicator/AnimationPlayer
@onready var crosshair = $Crosshair
@onready var _prompt = $Prompt
@onready var _HiddenPrompt = $HiddenPrompt
@onready var objective = $Objective
@onready var daycycle = $DayCycle
@onready var LogoAnimPlayer = $Bootup/AnimationPlayer
@onready var bootup = $Bootup
@onready var titlescreenUi = $TitleScreen

var isPaused = false
var bootupPlaying = true
var titleScreen = true
var showOnce = false
var cutScene = false
var blacBarsAllowed = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$PS1Start.play()
	LogoAnimPlayer.play("Logo")
	DayCycleIconAnim.play("FloatingIcons")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_just_pressed("debug"):
		SceneManager.changeScene(SceneManager.world)
	
	if bootupPlaying and Input.is_action_just_pressed("Skip"):
		bootup.hide()
		$PS1Start.stop()
		titlescreenUi.show()
		bootupPlaying = false
		SoundManager.playMusic("Titlescreen")
		
	if !titleScreen and !showOnce:
		showOnce = true
		crosshair.show()
		_prompt.show()
		objective.show()
		daycycle.show()
		titlescreenUi.hide()
		
	if Input.is_action_just_pressed("Pause") and !isPaused and !titleScreen:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
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
			_HiddenPrompt.hide()
			_general_tab.button_pressed = true
			_sound_tab.button_pressed = false
			_graphics_tab.button_pressed = false
			$BookOpen_Close.play()
			get_tree().paused = true

	elif Input.is_action_just_pressed("Pause") and isPaused and !titleScreen:
		isPaused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_bookmenu.hide()
		crosshair.show()
		_prompt.show()
		_HiddenPrompt.show()
		$BookOpen_Close.play()
		get_tree().paused = false

	if cutScene and blacBarsAllowed:
		dialogueAnim.play("BlackBarsFadeIn")
		blacBarsAllowed = false
	elif !cutScene and !blacBarsAllowed:
		dialogueAnim.play("BlackBarsFadeOut")
		blacBarsAllowed = true
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
	crosshair.show()
	_prompt.show()
	_HiddenPrompt.show()
	$BookOpen_Close.play()
	get_tree().paused = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Logo" and bootupPlaying:
		bootupPlaying = false
		titlescreenUi.show()
		bootup.hide()
		SoundManager.playMusic("Titlescreen")
