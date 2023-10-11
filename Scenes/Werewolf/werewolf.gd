extends CharacterBody3D

enum {
	IDLE,
	WANDER,
	CHASE,
	GROWL,
	BITE,
}
const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const TOLERANCE = 4.0

var state = IDLE

var _player = null
var target_vector: Vector3
var last_target_vector: Vector3 
var radius = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $WerewolfAnim/AnimationPlayer
@onready var test = $Marker3D

#Audio
@onready var chaseMusic = $chaseMusic
@onready var Growl = $Growl
@onready var Breathing_Sniffling = $Breathing_Sniffing
@onready var Scream = $Scream
var chasePlaying = false
var growlPlaying = false
var Breathing_SnifflingPLaying = false
var ScreamPlaying = false

func _ready():
	nav_agent.debug_enabled = true

	update_target_position()

func _physics_process(delta):
	velocity = Vector3.ZERO
	setGravity(delta)
	
	match state:
		IDLE:
			print("IDLE")
			if !Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = true
				Breathing_Sniffling.play()
			anim_player.play("Scratch")
			await anim_player.animation_finished
			update_target_position()
			state = WANDER

		WANDER:
			print("WANDER")
			if !Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = true
				Breathing_Sniffling.play()
			random_roaming_position()
			if nav_agent.is_navigation_finished():
				state = IDLE
		GROWL:
			if Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = false
				Breathing_Sniffling.stop()
			if !growlPlaying:
				growlPlaying = true
				Growl.play()
			print("GROWL")
			anim_player.play("Growl")
			await anim_player.animation_finished
			state = CHASE
		CHASE:
			if !chasePlaying:
				chasePlaying = true
				chaseMusic.play()
			print("CHASE")
			chase()
		BITE:
			if Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = false
				Breathing_Sniffling.stop()
			if !ScreamPlaying:
				ScreamPlaying = true
				Scream.play()
			print("BITE")
			anim_player.play("NeckBite")
			await anim_player.animation_finished
			state = IDLE
#	if _player == null: 
#		isWalking = true
#		anim_player.play("Walking")
#		random_roaming_position()
		
#	if _player and !_player.hiding:
#
#
#	if _player and _player.hiding:
#		anim_player.play("LookinAround")
#		await anim_player.animation_finished
#		anim_player.play("Walking")

#	look_at(global_transform.origin + velocity)
	
func setGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
func update_target_position():
	if target_vector == last_target_vector:
		target_vector = Vector3(randi_range(-radius, radius), randi_range(-radius, radius), 0)
		
func random_roaming_position():
	anim_player.play("Walking")
	last_target_vector = target_vector 
	print("new vector" + str(target_vector) + "" + "last vector"+str(last_target_vector))
	nav_agent.set_target_position(target_vector)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(global_transform.origin + velocity)
	move_and_slide()
	
func is_at_target_position(): 
	print("reached position")
	# Stop moving when at target +/- tolerance
	return (target_vector - global_position).length() < TOLERANCE

func chase():
	anim_player.play("Chase")
	nav_agent.set_target_position(_player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(global_transform.origin + velocity)
	move_and_slide()
	
func _on_detect_player_body_entered(body):
	if body.name == "Player" and _player == null:
		state = GROWL
		_player = body

func _on_detect_player_body_exited(body):
	if body.name == "Player":
		print("Player exited")
#		_player = null


func _on_bite_range_body_entered(body):
	if body.name == "Player":
		state = BITE
		print("Player got caught")
		await anim_player.animation_finished

func _on_bite_range_body_exited(body):
	pass # Replace with function body.
