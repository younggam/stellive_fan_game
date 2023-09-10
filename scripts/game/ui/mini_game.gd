extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Back.pressed.connect(on_back_button)

func on_back_button():
	hide()
