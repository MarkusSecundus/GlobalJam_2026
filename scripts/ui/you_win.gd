extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameState.infected_point_count == GameState.infected_points) and (visible == false):
		show()
		GameState.player_has_won = true
		print("you win")
	pass
