extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	GameState.game_started = false
	$"../../layer_hud".visible = false # Yeah fuck you
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	GameState.game_started = true
	$"../../layer_hud".visible = true
	pass # Replace with function body.
