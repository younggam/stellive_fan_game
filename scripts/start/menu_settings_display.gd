extends GridContainer

const SECTION=Settings.section_names[Settings.Sections.DISPLAY]

const WINDOW_MODE="window_mode"
signal window_mode(section,key,value)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().register(SECTION,self,[window_mode])
	$WindowModeOption.get_popup().index_pressed.connect(on_window_mode_changed)

func initialize(file):
	for key in file.get_section_keys(SECTION):
		if key==WINDOW_MODE:
			var value=file.get_value(SECTION,key)
			set_window_mode(value)
			$WindowModeOption.select(value)
		
	
func on_window_mode_changed(index):
	set_window_mode(index)
	window_mode.emit(SECTION,WINDOW_MODE,index)
		
func set_window_mode(selected):
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if selected==0
		else DisplayServer.WINDOW_MODE_FULLSCREEN if selected==1
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
