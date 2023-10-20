extends Node

func showDialogue(dialoguepath, player):
	Ui.get_node("CanvasLayer/Dialogue").dialoguePath = dialoguepath
	Ui.get_node("CanvasLayer/Dialogue").player = player
	Ui.get_node("CanvasLayer/Dialogue").start()
