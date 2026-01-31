extends IDialogAction

@export var exit_code : int = 0
@export var destroy_current_tab_in_webgl: bool = true

func do_perform(_ctx: DialogContext, on_finished: Callable)->void:
	if destroy_current_tab_in_webgl:
		JavaScriptBridge.eval("window.top.close()")
	get_tree().quit(exit_code)
