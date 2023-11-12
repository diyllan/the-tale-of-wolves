extends Node

var lastVoice : AudioStreamPlayer
var lastSound : AudioStreamPlayer
var lastMusic : AudioStreamPlayer
var lastAmbience : AudioStreamPlayer

func playVoice(voice):
	var audioPlayer = $Voice.get_node(voice)
	if lastSound != null:
		if lastSound.playing:
			lastSound.stop()
			
	lastSound = audioPlayer
	audioPlayer.play()

func playSound(sound):
	var audioPlayer = $Sound.get_node(sound)
	lastSound = audioPlayer
	audioPlayer.play()

func stopLastSound(sound):
	var audioPlayer = $Sound.get_node(sound)
	audioPlayer.stop()

func playNextSound(sound):
	var audioPlayer = $Sound.get_node(sound)

	if lastSound != null:
		if lastSound.playing:
			await lastSound.finished
			lastSound = audioPlayer
			audioPlayer.play()

func playMusic(music):
	var audioPlayer = $Music.get_node(music)

	if lastMusic != null:
		if lastMusic.playing:
			var lastMusicFadeOut = create_tween()
			lastMusicFadeOut.tween_property(lastMusic, "volume_db", -80, 5)
			await lastMusicFadeOut.finished
			lastMusic.stop()
			
	lastMusic = audioPlayer
	audioPlayer.play()
	var audioPlayerFadeIn = create_tween()
	audioPlayerFadeIn.tween_property(audioPlayer, "volume_db", 0, 1)
	audioPlayer.play()

func lowerLastMusicVolume():
	if lastMusic != null:
		if lastMusic.playing:
			var lastMusicFadeOut = create_tween()
			lastMusicFadeOut.tween_property(lastMusic, "volume_db", -10, 3)
	

func playAmbience(ambience):
	var audioPlayer = $Ambience.get_node(ambience)

	if lastAmbience != null:
		if lastAmbience.playing:
			var lastAmbienceFadeOut = create_tween()
			lastAmbienceFadeOut.tween_property(lastAmbience, "volume_db", -80, 5)
			await lastAmbienceFadeOut.finished
			lastAmbience.stop()
			
	lastAmbience = audioPlayer
	audioPlayer.play()
	var audioPlayerFadeIn = create_tween()
	audioPlayerFadeIn.tween_property(audioPlayer, "volume_db", 0, 1)
	audioPlayer.play()

func stopAllSounds():
	if lastVoice != null:
		lastVoice.stop()
	if lastAmbience != null:
		lastAmbience.stop()
	if lastSound != null:
		lastSound.stop()
	if lastMusic != null:
		lastMusic.stop()
