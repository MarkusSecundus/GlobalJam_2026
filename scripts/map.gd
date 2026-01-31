extends Node2D

func _on_child_entered_tree(node: Node) -> void:
	if node == self:
		GameState.infected_point_count = 0
		GameState.infected_points = 0
		GameState.player_hp = Game.MAX_PLAYER_HP
		GameState.player_has_won = false
