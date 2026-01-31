class_name WinEffect
extends Control


@export var do_win: bool:
	set(_val): do_play()

func do_play()->void:
	show()
	$AnimationPlayer.play("win_effect")
	
