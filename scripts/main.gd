extends Node
class_name Main

static var _instance:Main
static var instance:Main:
	get: return _instance

enum State{START_SCREEN,HOST,CLIENT}

const _states={
	State.START_SCREEN:"res://scenes/start/screen.tscn",
	State.HOST:"res://scenes/game/game.tscn",
	State.CLIENT:"res://scenes/player.tscn"
}

var _current_state=State.START_SCREEN
@onready var _current_scene=$StartScreen
var _scene_loading=false

@onready var _loading_screen=$LoadingScreen

signal scene_loaded(result)


var _exit_requested=false

signal on_exit_requested()
signal on_exit_canceled()
signal on_exit()

@onready var _settings=$CanvasLayer/Settings

func _enter_tree():
	_instance=self

func _notification(what):
	if what==NOTIFICATION_WM_CLOSE_REQUEST:
		if _exit_requested:
			exit()
		else:
			request_exit()

func _process(_delta):
	if _scene_loading:
		var load_status=ResourceLoader.load_threaded_get_status(_states[_current_state])
		if load_status==ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			scene_loaded.emit(true)
		elif load_status!=ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			scene_loaded.emit(false)
	
func change_state(what):
	if _scene_loading or what==_current_state or !_states.has(what):
		return
	
	if ResourceLoader.load_threaded_request(_states[what],"PackedScene"):
		printerr("Scene load failed!")
		return

	var temp_state=_current_state
	
	_scene_loading=true
	_current_state=what
	_loading_screen.show()
	
	if await scene_loaded:
		_current_scene.queue_free()
		_current_scene=ResourceLoader.load_threaded_get(_states[_current_state]).instantiate()
		add_child(_current_scene)
	else:
		_current_state=temp_state
		printerr("Scene load failed!")

	_loading_screen.hide()
	_scene_loading=false


func request_exit():
	_exit_requested=true
	on_exit_requested.emit()
	
func cancel_exit():
	_exit_requested=false
	on_exit_canceled.emit()

func exit():
	on_exit.emit()
	get_tree().quit()
	
func toggle_settings():
	_settings.show_or_hide()
