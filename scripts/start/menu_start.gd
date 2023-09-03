extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Continue.pressed.connect(on_continue_button)
	$NewGame.pressed.connect(on_new_game_button)
	$Join.pressed.connect(on_join_button)
	$Back.pressed.connect(on_back_button)


func on_continue_button():
	pass
	
func on_new_game_button():
	Main.instance.change_state(Main.State.HOST)
	
func on_join_button():
	pass
	
func on_back_button():
	get_parent().change_sub_menu("main")
