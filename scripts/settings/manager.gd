extends VBoxContainer
class_name Settings

enum Sections{DISPLAY}

const section_names={
	Sections.DISPLAY:"display"
}

var file = ConfigFile.new()
var file_path="user://settings.cfg"

var children={}

var prev_escape=false

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(on_visibility_changed)
	$Back.pressed.connect(on_back_button)
	Main.instance.on_exit.connect(func(): file.save(file_path))
	if file.load(file_path):
		file.save(file_path)
		file.load(file_path)
	
	for section in file.get_sections():
		if children.has(section):
			children[section].initialize(file)

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		if event.pressed:
			if prev_escape==false&&visible:
				hide()
				get_viewport().set_input_as_handled()
			prev_escape=true
		else:
			prev_escape=false


func register(section,child,signals):
	children[section]=child
	for s in signals:
		s.connect(file.set_value)
		
func show_or_hide():
	if visible:
		hide()
	else:
		show()
	
func on_back_button():
	hide()

func on_visibility_changed():
	get_tree().paused=visible
