extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5

var _player = null
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D
@onready var anim_player = $NavigationAgent3D

func _physics_process(delta):
	velocity = Vector3.ZERO
#	if not is_on_floor():
#		velocity.y -= gravity * delta
	
	if _player:
		
		await anim_player
		if !_player.hiding:
			nav_agent.set_target_position(_player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
#			print(velocity)
			look_at(global_transform.origin + velocity)
#			look_at(Vector3(_player.global_position.x, global_position.y, _player.global_position.z), Vector3.UP)
		
	if _player and _player.hiding:
		pass
		
	move_and_slide()

func _on_detect_player_body_entered(body):
	if body.name == "Player":
		print("detected Player")
		_player = body

func _on_detect_player_body_exited(body):
#	if body.name == "Player":
#		print("Player exited")
#		_player = null
	pass
