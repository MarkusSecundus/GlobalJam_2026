extends IDialogAction

@export var exit_code : int = 0

func do_perform(_ctx: DialogContext, on_finished: Callable)->void:
	get_tree().quit(exit_code)
