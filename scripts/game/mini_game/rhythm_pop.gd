extends TextureRect

var note_scene=preload("res://scenes/game/note.tscn")

@export var easy_presets:Array[NotesPreset]
@export var normal_presets:Array[NotesPreset]
@export var hard_presets:Array[NotesPreset]

var wait=4

var current_presets
var preset_current_index=0
var current_preset=null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wait>0:
		wait-=delta
		return
	
	if current_preset==null:
		current_preset=easy_presets.pick_random()
		preset_current_index=0
		wait+=1
		return

	print("d")
	var note=note_scene.instantiate()
	get_node("VBoxContainer/GridContainer/%d"%randi_range(0,63)).add_child(note)
	note.initialize(current_preset.texts[preset_current_index],current_preset.keys[preset_current_index])
	
	if preset_current_index<current_preset.intervals.size():
		wait+=current_preset.intervals[preset_current_index]
	
	preset_current_index+=1
	
	if preset_current_index>=current_preset.texts.size():
		current_preset=null
	
