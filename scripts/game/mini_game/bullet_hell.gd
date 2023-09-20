extends TextureRect

#var note_scene=preload("res://scenes/game/mini_game/note.tscn")

#@export var presets:Array[NotesPreset]
@export var easy_count:int
@export var normal_count:int
@export var hard_count:int

@export var easy_mul:float
@export var hard_mul:float

@export var base_interval:float
@export var base_earn:float=2

var mul=1.0
#var successed=0
#var failed=0
var wait=4

var count=0
var max_count

#var preset_current_index=0
#var current_preset=null
var play=false
var countdown

signal end(score:float)

func start(difficulty):
	end.connect(Game.instance.mini_game_end(Enums.MiniGame.GAME_SEARCH))
	$GiveUp.pressed.connect(on_give_up)
	if difficulty==Enums.Difficulty.EASY:
		mul=easy_mul
		max_count=easy_count
	elif difficulty==Enums.Difficulty.HARD:
		mul=hard_mul
		max_count=hard_count
	else:
		max_count=normal_count
#	successed=0
#	failed=0
	wait=4
#	preset_current_index=0
	play=true
	$Label.text="3"
	countdown=3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !play:
		return

	if wait>0:
		wait-=delta
		if countdown>=0:
			if countdown==3&&wait<=3:
				countdown=2
				$Label.text="2"
			elif countdown==2&&wait<=2:
				countdown=1
				$Label.text="1"
			elif countdown==1&&wait<=1:
				countdown=0
				$Label.text="Start!"
			elif countdown==0&&wait<=0:
				countdown=-1
				$Label.visible=false

			var scale=clampf(2*(wait-int(wait)),1,2)
			$Label.scale=Vector2(scale,scale)
		return
	
#	if current_preset==null:
#		current_preset=presets.pick_random()
#		preset_current_index=0
#		return
#
#	var note=note_scene.instantiate()
#	note.initialize(current_preset.texts[preset_current_index],current_preset.keys[preset_current_index])
#	note.pop.connect(on_pop)
	count+=1
	
#	if preset_current_index<current_preset.intervals.size():
#		wait+=current_preset.intervals[preset_current_index]*mul
#
#	preset_current_index+=1
#
#	if preset_current_index>=current_preset.texts.size()||count>=max_count:
#		current_preset=null
#		if count>=max_count:
#			stop(false)
#		else:
#			wait+=base_interval

#func on_pop(result):
#	if result:
#		successed+=1
#	else:
#		failed+=1
#
#	$VBoxContainer/Label.text="Score: %.1f%%(%.1f%%)"%[100*get_score(),100*successed/float(successed+failed)]

func stop(give_up):
	play=false
	await get_tree().create_timer(0 if give_up else 3).timeout
	end.emit(base_earn*get_score()/mul)
	queue_free()

func on_give_up():
	$VBoxContainer/Panel.add_child(preload("res://scenes/game/mini_game/laser.tscn").instantiate())
	$VBoxContainer/Panel/Laser.initialize(Vector2(120,120),deg_to_rad(45),Vector2.ZERO)
	stop(false)

func get_score():
#	return successed/float(max_count)
	return 0
