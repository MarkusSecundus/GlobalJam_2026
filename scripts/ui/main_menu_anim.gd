extends AnimatedSprite2D

@export var animation_player: AnimationPlayer

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	var point: Vector2 = $"..".size / 2
	var start_position: Vector2 = point + (position - point).rotated(randf_range(0, TAU))
	animation_player.get_animation(anim_name).track_set_key_value(0, 0, start_position)
	var end_position: Vector2 = point + (start_position - point).rotated(PI)
	rotation = (end_position - start_position).angle() + PI / 2
	animation_player.get_animation(anim_name).track_set_key_value(0, 1, end_position)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.play(anim_name)
