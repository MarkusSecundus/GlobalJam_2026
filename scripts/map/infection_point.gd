extends Node2D

var TIME_TO_INFECT: float = 5
var is_player_inside: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProgressBar.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (is_player_inside):
		$ProgressBar.value += (100 * delta) / TIME_TO_INFECT
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = true
		$ProgressBar.value = 0
		$ProgressBar.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = false
		$ProgressBar.hide()
