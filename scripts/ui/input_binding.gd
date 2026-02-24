class_name InputBinding
extends RichTextLabel

@export var keyboard_text : String
@export var controller_text : String 


func _do_update(mode: Player.InputMode)->void:
	if mode == Player.InputMode.MOUSE: self.text = keyboard_text
	elif mode == Player.InputMode.CONTROLLER: self.text = controller_text
