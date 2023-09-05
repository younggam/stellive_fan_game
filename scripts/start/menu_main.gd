extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Start.pressed.connect(on_start_button)
	$Settings.pressed.connect(on_settings_button)
	$Exit.pressed.connect(on_exit_button)


func on_start_button():
	get_parent().change_sub_menu("start")
	
func on_settings_button():
	Main.instance.toggle_settings()
	
func on_exit_button():
	Main.instance.request_exit()
