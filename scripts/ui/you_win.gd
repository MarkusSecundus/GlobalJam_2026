class_name WinEffect
extends Control


@export var do_win: bool:
	set(_val): do_play()

func do_play()->void:
	show()
	GameState.game_screen_type = GameState.GameScreenType.GAME_OVER
	$AnimationPlayer.play("win_effect")
	$Sounds/GameWon.play()
	
