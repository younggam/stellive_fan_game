extends ConfirmationDialog

func _ready():
	Main.instance.on_exit_requested.connect(show)
	Main.instance.on_exit_canceled.connect(hide)
	canceled.connect(on_canceled)
	confirmed.connect(on_confirmed)
	
func on_canceled():
	Main.instance.cancel_exit()

func on_confirmed():
	Main.instance.exit()
