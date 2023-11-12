extends Node3D

var werewolfscene = preload("res://Scenes/Werewolf/werewolf.tscn")
var werewolfspawned = false
var werewolfdespawned = false

func _on_spawnzone_body_entered(body):
	if body.is_in_group("Player") and ObjectiveManager.day_part_count == 11 and !werewolfspawned:
		print("Spawning wolf")
		werewolfspawned = true
		var instance = werewolfscene.instantiate()
		add_child(instance)

func _on_despawnzone_body_entered(body):
	if body.is_in_group("Player") and werewolfspawned and !werewolfdespawned:
		werewolfdespawned = true
		get_node("Werewolf").queue_free()
