extends Node

var lastAudio : AudioStreamPlayer

func playVoice(voice):
	var audioPlayer = get_node(voice)
	if lastAudio != null:
		if lastAudio.playing:
			lastAudio.stop()
			
	lastAudio = audioPlayer
	audioPlayer.play()
		
		

func playSound(sound):
	var audioPlayer = get_node(sound)
	audioPlayer.play()
	if lastAudio != null:
		if lastAudio.playing:
			lastAudio.stop()
			
	lastAudio = audioPlayer
	audioPlayer.play()
