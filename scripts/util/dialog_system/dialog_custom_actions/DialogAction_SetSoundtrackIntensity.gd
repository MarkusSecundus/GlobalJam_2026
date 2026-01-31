extends IDialogAction


@export var intensity : float = 0.0


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	SoundManager.SetSoundtrackIntensity(intensity)
	_default_perform(ctx, on_finished)
