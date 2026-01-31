extends IDialogAction

@export var destination : PackedScene
@export var destination_string : String

func do_perform(_ctx: DialogContext, on_finished: Callable)->void:
	if destination: get_tree().change_scene_to_packed(destination)
	else: get_tree().change_scene_to_file(destination_string)
	
