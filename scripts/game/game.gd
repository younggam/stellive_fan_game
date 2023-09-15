extends Node2D
class_name Game

static var _instance:Game
static var instance:Game:
	get: return _instance

var donation=0
var just_chatting=0.0
var singing=0.0
var game=0.0

@export var hour_unit=30
@export var mini_game_hour=3
var hour=0
var time=0
var playing_mini_game=false

func _enter_tree():
	_instance=self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing_mini_game:
		return

	time+=delta
	var new_hour=floori(time/hour_unit)
	if new_hour!=hour:
		hour=new_hour
		$CanvasLayer/OverlayUI/Clock.set_hour(hour)

func add_hour(to_add):
	time+=hour_unit*to_add
	hour+=to_add
	if hour%24==18:
		time=hour_unit*hour
	$CanvasLayer/OverlayUI/Clock.set_hour(hour)

func open_pc(pc):
	$CanvasLayer/MiniGameUI.hide()
	$CanvasLayer/PC.initialize(pc)

func open_mini_game(mini_game):
	if hour%24>18-mini_game_hour:
		return
	$CanvasLayer/PC.hide()
	playing_mini_game=true
	$CanvasLayer/MiniGameUI.initialize(mini_game)

func mini_game_end(mini_game):
	return func(earn):
		if mini_game==Enums.MiniGame.JUST_CHATTING_TOPIC_SEARCH:
			just_chatting+=earn
		elif mini_game==Enums.MiniGame.SINGING_PRACTICE:
			singing+=earn
		elif mini_game==Enums.MiniGame.GAME_SEARCH:
			game+=earn
		print("%f %f %f %f"%[just_chatting,singing,game,earn])
		add_hour(mini_game_hour)
