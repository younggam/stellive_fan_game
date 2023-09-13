extends VBoxContainer

class_name MiniGame

enum Difficulty{EASY,NORMAL,HARD}

static var mini_game_scene_map={
	Game.MiniGame.JUST_CHATTING_TOPIC_SEARCH:preload("res://scenes/game/rhythm_pop.tscn"),
	Game.MiniGame.SINGING_PRACTICE:preload("res://scenes/game/rhythm_pop.tscn"),
	Game.MiniGame.GAME_SEARCH:preload("res://scenes/game/rhythm_pop.tscn")
}

static var mini_game_title_map={
	Game.MiniGame.JUST_CHATTING_TOPIC_SEARCH:"Search just chatting topic",
	Game.MiniGame.SINGING_PRACTICE:"Practice singing",
	Game.MiniGame.GAME_SEARCH:"Search Game"
}

var mini_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/GridContainer/Easy.pressed.connect(difficulty_button(Difficulty.EASY))
	$Panel/GridContainer/Normal.pressed.connect(difficulty_button(Difficulty.NORMAL))
	$Panel/GridContainer/Hard.pressed.connect(difficulty_button(Difficulty.HARD))
	$Back.pressed.connect(on_back_button)

func _shortcut_input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		if event.pressed and !event.is_echo():
			hide()

func initialize(mini_game):
	self.mini_game=mini_game
	$Panel/GridContainer/Label.text=mini_game_title_map[mini_game]

	show()

func difficulty_button(difficulty):
	return func():
		var scene=mini_game_scene_map[mini_game].instantiate()
		get_node("../MiniGame").add_child(scene)
		scene.start(difficulty)
		hide()

func on_back_button():
	hide()
