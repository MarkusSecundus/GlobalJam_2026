extends Control


func _on_button_play_pressed() -> void:
	GameState.infected_point_count = 0
	GameState.infected_points = 0
	GameState.player_hp = Game.MAX_PLAYER_HP
