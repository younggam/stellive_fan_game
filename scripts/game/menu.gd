extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/VBoxContainer/Save.pressed.connect(on_save_button)
	$Panel/VBoxContainer/Settings.pressed.connect(on_settings_button)
	$Panel/VBoxContainer/BackToTitle.pressed.connect(on_back_to_title_button)
	$Panel/VBoxContainer/Exit.pressed.connect(on_exit_button)
	$Back.pressed.connect(on_back_button)
	
func _shortcut_input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		if event.pressed and !event.is_echo():
			show_or_hide()
			get_viewport().set_input_as_handled()

func on_save_button():
	pass
	
func on_settings_button():
	Main.instance.toggle_settings()
	hide()
	
func on_back_to_title_button():
	$"../../BackToTitleDialog".show()
	
func on_exit_button():
	Main.instance.request_exit()

func on_back_button():
	hide()

func show_or_hide():
	if visible:
		hide()
	else:
		show()
