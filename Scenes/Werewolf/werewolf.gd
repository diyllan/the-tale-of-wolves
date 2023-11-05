extends CharacterBody3D

enum {
	IDLE,
	WANDER,
	CHASE,
	GROWL,
	BITE,
}
const SPEED = 6
const CHASE_SPEED = 8
const TOLERANCE = 4.0

var state = IDLE

var _player = null
var target_vector: Vector3
var last_target_vector: Vector3 
var radiusx1 = -546
var radiusx2 = -360
var radiusz1 = -275
var radiusz2 = -172


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $WerewolfAnim/AnimationPlayer
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
	update_target_position()

func _physics_process(delta):
	setGravity(delta)
	match state:
		IDLE:
			if !Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = true
				Breathing_Sniffling.play()
			if _player != null:
				if !_player.hiding and !playerTooClose and "Scratch" != anim_player.get_current_animation() and "LookinAround" != anim_player.get_current_animation():
					anim_player.play("Scratch")
					await anim_player.animation_finished
					update_target_position()
					state = WANDER


				elif _player.hiding and !playerTooClose and "LookinAround" != anim_player.get_current_animation() and "Scratch" != anim_player.get_current_animation():
					anim_player.play("LookinAround")
					await anim_player.animation_finished
					update_target_position()
					state = WANDER


			elif "Scratch" != anim_player.get_current_animation():
				anim_player.play("Scratch")
				await anim_player.animation_finished
				update_target_position()
				state = WANDER


		WANDER:
			if "Walking" != anim_player.get_current_animation():
				anim_player.play("Walking")
			
			random_roaming()
			
			if !Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = true
				Breathing_Sniffling.play()
			
			if nav_agent.is_navigation_finished():
				state = IDLE

				
		GROWL:
			if _player.hiding and !playerTooClose and "LookinAround" != anim_player.get_current_animation():
				anim_player.play("LookinAround")
				await anim_player.animation_finished
				state = IDLE
				
			elif !_player.hiding and state != CHASE and "Growl" != anim_player.get_current_animation():
				anim_player.play("Growl")
				await anim_player.animation_finished
				state = CHASE
			
			if Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = false
				Breathing_Sniffling.stop()
			if !growlPlaying:
				growlPlaying = true
				Growl.play()

		CHASE:
			if "Chase" != anim_player.get_current_animation():
				anim_player.play("Chase")
			if _player.hiding and chasePlaying and !playerTooClose:
				chasePlaying = false
				var chaseMusicFadeOut = create_tween()
				chaseMusicFadeOut.tween_property(chaseMusic, "volume_db", -80, 2)
				await chaseMusicFadeOut.finished
				chaseMusic.stop()
				state = IDLE
			elif _player.hiding and playerTooClose and chasePlaying:
				chasePlaying = false
				var chaseMusicFadeOut = create_tween()
				chaseMusicFadeOut.tween_property(chaseMusic, "volume_db", -80, 2)
				await chaseMusicFadeOut.finished
				chaseMusic.stop()
			elif !_player.hiding and !chasePlaying:
				chaseMusic.play()
				var chaseMusicFadeIn = create_tween()
				chaseMusicFadeIn.tween_property(chaseMusic, "volume_db", 0, 1)
				chasePlaying = true
			chase()
			
		BITE:
			if Breathing_SnifflingPLaying:
				Breathing_SnifflingPLaying = false
				Breathing_Sniffling.stop()
			if !ScreamPlaying:
				ScreamPlaying = true
				Scream.play()
			var chaseMusicFadeOut = create_tween()
			chaseMusicFadeOut.tween_property(chaseMusic, "volume_db", -80, 2)
			chaseMusic.stop()
			anim_player.play("NeckBite")
			camera.make_current()
			_player.hide()
			await anim_player.animation_finished
			_player.death = true
	
func setGravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
func update_target_position():
	if target_vector == last_target_vector:
		target_vector = Vector3(randi_range(radiusx1, radiusx2),  0, randi_range(radiusz1, radiusz2))
		
func random_roaming():
	last_target_vector = target_vector 
	nav_agent.set_target_position(target_vector)
	var next_nav_point = nav_agent.get_next_path_position()
#	print_debug(next_nav_point)
#	print_debug(global_transform.origin)
#	print_debug(next_nav_point - global_transform.origin)
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
#	print_debug(velocity)
	look_at(global_transform.origin + velocity)
	move_and_slide()
	
func is_at_target_position(): 
	# Stop moving when at target +/- tolerance
	return (target_vector - global_position).length() < TOLERANCE

func chase():
	nav_agent.set_target_position(_player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * CHASE_SPEED
	look_at(global_transform.origin + velocity)
	move_and_slide()
	
func _on_detect_player_body_entered(body):
	if body.name == "Player":
		_player = body
		if state != CHASE and !_player.hiding:
			state = GROWL
			growlPlaying = false

func _on_bite_range_body_entered(body):
	if body.name == "Player":
		if !_player.hiding or _player.hiding and playerTooClose:
			state = BITE

func _on_player_too_close_body_entered(body):
	if body.name == "Player":
		if !_player.hiding:
			playerTooClose = true
