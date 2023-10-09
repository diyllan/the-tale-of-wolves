extends Control

@export var dialoguePath = ""
@export var textSpeed = 0.05
@onready var player = get_tree().root.get_node("/root/World/Player")

var dialog
var phraseNum = 0
var finished = false
var skipping = false

func _ready():
	self.hide()
#	start()
	
func start():
	$Timer.wait_time = textSpeed
	player.dialogueActive = true
	phraseNum = 0
	self.show()
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()
	$Indicator/AnimationPlayer.play("Indicator")
	
func track_time_button():
	var button_time = 5
	if Input.is_action_just_pressed("Skip"):
		$SkipTimer.start(button_time)
		$Indicator.hide()
		$TextureProgressBar.show()
		skipping = true
	if Input.is_action_just_released("Skip"):
		skipping = false
		$Indicator.show()
		$SkipTimer.stop()
		$TextureProgressBar.hide()
		print("fail")

func _on_skip_timer_timeout():
	dialog = []
	nextPhrase()
	print("success")
	
func _process(delta):	
	if Input.is_action_just_pressed("interact"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)
	track_time_button()
	
	if skipping:
		$TextureProgressBar.value = 5 - $SkipTimer.time_left
	else:
		$Indicator.visible = finished
		$TextureProgressBar.value = 0
	


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
	
	finished = false
	
#	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$Text.visible_characters = 0
	
	var f = FileAccess.open(dialoguePath,FileAccess.READ)
#	var img = "res://Sprites/Portraits/" + dialog[phraseNum]["Name"] + dialog[phraseNum]["Emotion"] + ".png"
#	if f.file_exists(img):
#		$Portrait.texture = load(img)
#	else: $Portrait.texture = null
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		await get_tree().create_timer(textSpeed).timeout
		
	finished = true
	phraseNum += 1
	return


