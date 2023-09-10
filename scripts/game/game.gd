extends Node2D
class_name Game

static var _instance:Game
static var instance:Game:
	get: return _instance

enum MiniGame{JUST_CHATTING_TOPIC_SEARCH,SINGING_PRACTICE,GAME_SEARCH}

var donation=0
var just_chatting=0
var singing=0
var game=0

@export var hour_unit=30
var hour=0
var time=0

func _enter_tree():
	_instance=self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	var new_hour=floori(time/hour_unit)
	if new_hour!=hour:
		hour=new_hour
		$CanvasLayer/OverlayUI/Clock.set_hour(hour)

func add_hour(to_add):
	time+=hour_unit*to_add
	hour+=to_add
	$CanvasLayer/OverlayUI/Clock.set_hour(hour)

func open_pc(pc):
	$CanvasLayer/MiniGame.hide()
	$CanvasLayer/PC.initialize(pc)

func open_mini_game(mini_game):
	$CanvasLayer/PC.hide()
	$CanvasLayer/MiniGame.show()
