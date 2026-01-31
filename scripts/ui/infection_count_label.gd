extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = var_to_str(InfectionSingleton.infected_points) + "/" + var_to_str(InfectionSingleton.infected_point_count)
	pass
