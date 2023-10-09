extends Node

func showDialogue(dialoguepath):
	Ui.get_node("CanvasLayer/Dialogue").dialoguePath = dialoguepath
	Ui.get_node("CanvasLayer/Dialogue").start()
