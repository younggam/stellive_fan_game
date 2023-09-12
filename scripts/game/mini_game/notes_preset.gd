extends Resource

class_name NotesPreset

enum Hand{LEFT=1,SPACE=2,RIGHT=4}

@export var texts:Array[String]
@export var keys:Array[Key]
@export var intervals:Array[float]
@export_flags("LEFT","SPACE","RIGHT") var Hands
