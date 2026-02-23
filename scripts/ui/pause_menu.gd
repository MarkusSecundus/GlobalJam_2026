extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameState.player_has_won:
		return
	
	if GameState.is_player_dead:
		return
		
	if ! GameState.game_started:
		return
	
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused == true:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true


func _on_button_resume_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_button_return_pressed() -> void:
	pass
	#get_tree().paused = false
	#visible = false
	#get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_transition_the_signal() -> void:
	get_tree().paused = false
