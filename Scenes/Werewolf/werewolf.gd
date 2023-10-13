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
@onready var camera = $"WerewolfAnim/Armature/Skeleton3D/Body Upper/Camera3D"

#Audio
@onready var chaseMusic = $chaseMusic
@onready var Growl = $Growl
@onready var Breathing_Sniffling = $Breathing_Sniffing
@onready var Scream = $Scream
var chasePlaying = false
var growlPlaying = false
var Breathing_SnifflingPLaying = false
var ScreamPlaying = false
var playerTooClose = false

func _ready():
	nav_agent.debug_enabled = true

	update_target_position()

func _physics_process(delta):
	velocity = Vector3.ZERO
	setGravity(delta)
	match state:
		IDLE:
			print("idle")
			if !Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = true
				Breathing_Sniffling.play()
			if _player != null:
				if !_player.hiding and !playerTooClose:
					anim_player.play("Scratch")
					await anim_player.animation_finished
					update_target_position()
					state = WANDER
				if _player.hiding and !playerTooClose:
					anim_player.play("LookinAround")
					await anim_player.animation_finished
					update_target_position()
					state = WANDER
			else:
				anim_player.play("Scratch")
				await anim_player.animation_finished
				update_target_position()
				state = WANDER
			

		WANDER:
			print("wander")
			if !Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = true
				Breathing_Sniffling.play()
			
			random_roaming_position()
			if nav_agent.is_navigation_finished():
				state = IDLE
		GROWL:
			print("growl")
			if _player.hiding and !playerTooClose:
				anim_player.play("LookinAround")
				await anim_player.animation_finished
				state = IDLE
				return
			if Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = false
				Breathing_Sniffling.stop()
			if !growlPlaying:
				growlPlaying = true
				Growl.play()
				await Growl.finished
				growlPlaying = false
			anim_player.play("Growl")
			await anim_player.animation_finished
			state = CHASE
		CHASE:
			print("chase")
			if _player.hiding and !playerTooClose:
				chaseMusic.stop()
				chasePlaying = false
				state = IDLE
				
			if !chasePlaying:
				if playerTooClose or _player.hiding:
					chaseMusic.stop()
					chasePlaying = false
					print("stopped chase music")
				else:
					print("stopped chase music")
					chasePlaying = true
					chaseMusic.play()
			chase()
		BITE:
			print("bite")
			if Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = false
				Breathing_Sniffling.stop()
			if !ScreamPlaying:
				ScreamPlaying = true
				Scream.play()
			chaseMusic.stop()
			anim_player.play("NeckBite")
			camera.make_current()
			_player.hide()
			await anim_player.animation_finished
			_player.death = true
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
	if body.name == "Player":
		_player = body
		if state != CHASE and !_player.hiding:
			state = GROWL

func _on_bite_range_body_entered(body):
	if body.name == "Player":
		if !_player.hiding or _player.hiding and playerTooClose:
			state = BITE

func _on_player_too_close_body_entered(body):
	if body.name == "Player":
		if !_player.hiding:
			print("player too close and not hiding")
			playerTooClose = true
