extends Control

@export var dialoguePath = ""
@export var textSpeed = 0.05
@onready var player = get_tree().root.get_node("/root/World/Player")

var dialog
var phraseNum = 0
var finished = false
var skipping = false
var interactDelay = true
func _ready():
	self.hide()
#	start()
	
func start():
	skipping = false
	interactDelay = true
	$InteractDelay.start()
	$Timer.wait_time = textSpeed
	$TextureProgressBar.value = 0
	player.dialogueActive = true
	phraseNum = 0
	self.show()
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	$Indicator/AnimationPlayer.play("Indicator")
	
func track_time_button():
	var button_time = 3
	if Input.is_action_just_pressed("Skip") and dialog:
		$SkipTimer.start(button_time)
		
		
		skipping = true
	if Input.is_action_just_released("Skip") and dialog:
		skipping = false
		
		$SkipTimer.stop()
		$TextureProgressBar.hide()

func _on_skip_timer_timeout():
	dialog = []
	nextPhrase()
	
func _process(_delta):

	if Input.is_action_just_pressed("interact") and finished:
		nextPhrase()
	elif Input.is_action_just_pressed("interact") and !finished and !interactDelay:
		$Text.visible_characters = len($Text.text)
		
	track_time_button()
	
	if skipping:
		$TextureProgressBar.show()
		$TextureProgressBar.value = 20 - $SkipTimer.time_left*6
		if finished:
			$Indicator.hide()
	else:
		$TextureProgressBar.hide()
		$TextureProgressBar.value = 0
		if finished:
			$Indicator.show()
		

	
func _on_interact_delay_timeout():
	interactDelay = false

func getDialog() -> Array:
	var f = FileAccess.open(dialoguePath,FileAccess.READ)
	assert(FileAccess.file_exists(dialoguePath), "File path does not exist")
	
	var json_object = JSON.new()
	json_object.parse(f.get_as_text())
	var output = json_object.get_data()
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
 
func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		self.hide()
		player.dialogueActive = false
		return
	
	$Indicator.hide()
	
	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
#	var f = FileAccess.open(dialoguePath,FileAccess.READ)
#	var img = "res://Sprites/Portraits/" + dialog[phraseNum]["Name"] + dialog[phraseNum]["Emotion"] + ".png"
#	if f.file_exists(img):
#		$Portrait.texture = load(img)
#	else: $Portrait.texture = null
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	var text_without_tags = regex.sub($Text.text, "", true)
	
	while $Text.visible_characters < len(text_without_tags):
		finished = false
		$Text.visible_characters += 1
		
		$Timer.start()
		await get_tree().create_timer(textSpeed).timeout
		finished = true
		
	phraseNum += 1
	return


