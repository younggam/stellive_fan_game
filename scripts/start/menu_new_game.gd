extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/GridContainer/DifficultyOption.get_popup().index_pressed.connect(on_difficulty_changed)
	$Panel/GridContainer/MemberOption.get_popup().index_pressed.connect(on_member_changed)
	$Ok.pressed.connect(on_ok_button)
	$Back.pressed.connect(on_back_button)


func on_difficulty_changed():
	pass
	
func on_member_changed():
	pass

func on_ok_button():
	Main.instance.change_state(Main.State.HOST)
	
func on_back_button():
	get_parent().change_sub_menu("start")
