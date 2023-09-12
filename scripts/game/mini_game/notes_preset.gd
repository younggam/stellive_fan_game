extends Resource

class_name NotesPreset

enum Hand{LEFT=1,SPACE=2,RIGHT=4}

@export var texts:Array[String]
@export var key:Array[Key]
@export var intervals:Array[float]
@export_flags("LEFT","SPACE","RIGHT") var Hands

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
