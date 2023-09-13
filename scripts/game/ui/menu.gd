extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(on_visibility_changed)
	$Panel/VBoxContainer/Save.pressed.connect(on_save_button)
	$Panel/VBoxContainer/Settings.pressed.connect(on_settings_button)
	$Panel/VBoxContainer/BackToTitle.pressed.connect(on_back_to_title_button)
	$Panel/VBoxContainer/Exit.pressed.connect(on_exit_button)
	$Back.pressed.connect(on_back_button)
	
func _shortcut_input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		if event.pressed and !event.is_echo():
			show_or_hide()

func on_save_button():
	pass
	
func on_settings_button():
	hide()
	Main.instance.toggle_settings()
	
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

func on_visibility_changed():
	get_tree().paused=visible
