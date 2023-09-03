extends Control

const sub_menus={
	main=preload("res://scenes/start/menu_main.tscn"),
	start=preload("res://scenes/start/menu_start.tscn")
}

@onready var _current_sub_menu=$Main

func change_sub_menu(to):
	_current_sub_menu.queue_free()
	_current_sub_menu=sub_menus[to].instantiate()
	add_child(_current_sub_menu)
