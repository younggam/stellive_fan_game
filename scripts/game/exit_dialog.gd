extends ConfirmationDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	confirmed.connect(on_confirmed)


func on_confirmed():
	Main.instance.change_state(Main.State.START_SCREEN)
