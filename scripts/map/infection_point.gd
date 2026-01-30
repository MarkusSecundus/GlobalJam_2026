extends Node2D

@export var time_to_infect_sec: float = 5
@export var progress_loss_sec: float = 2
var is_player_inside: bool = false

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (is_player_inside):
		progress_bar.value += (100 * delta) / time_to_infect_sec
	else:
		progress_bar.value -= (100 * delta) / progress_loss_sec
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == "Player"):
		is_player_inside = false
