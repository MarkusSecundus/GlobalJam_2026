extends Node2D

func _on_child_entered_tree(node: Node) -> void:
	if node == $load_bearing_node:
		GameState.infected_points = 0
		GameState.infected_point_count = 0
		GameState.game_screen_type = GameState.GameScreenType.IN_GAME
		GameState.player_hp = Game.MAX_PLAYER_HP
		GameState.player_mask = 0
