extends TabContainer
class_name Settings

enum Sections{DISPLAY}

const section_names={
	Sections.DISPLAY:"display"
}

var file = ConfigFile.new()
var file_path="user://settings.cfg"

var children={}

# Called when the node enters the scene tree for the first time.
func _ready():
	Main.instance.on_exit.connect(func(): file.save(file_path))
	if file.load(file_path):
		file.save(file_path)
		file.load(file_path)
	
	for section in file.get_sections():
		if children.has(section):
			children[section].initialize(file)


func register(section,child,signals):
	children[section]=child
	for s in signals:
		s.connect(file.set_value)
