extends Control


func _on_button_play_button_up() -> void:
	get_tree().change_scene_to_file("res://maps/test_map.tscn")
	pass # Replace with function body.


func _on_button_quit_button_up() -> void:
	get_tree().quit()
	pass # Replace with function body.
