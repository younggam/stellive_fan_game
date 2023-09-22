extends TextureRect

var note_texture=preload("res://textures/empty.png")

@export var presets:Array[NotesPreset]
@export var easy_count:int
@export var normal_count:int
@export var hard_count:int

@export var easy_spawn_count:int
@export var normal_spawn_count:int
@export var hard_spawn_count:int

@export var easy_mul:float
@export var hard_mul:float

@export var base_interval:float
@export var base_earn:float=2

@export var note_speed=256
@export var life_time=0.125

var mul=1.0
var successed=0
var failed=0
var wait=4

var count=0
var max_count
var max_spawn_count
var notes=[]

var preset_current_index=0
var current_preset=null
var play=false
var countdown

signal end(score:float)

func start(difficulty):
	end.connect(Game.instance.mini_game_end(Enums.MiniGame.SINGING_PRACTICE))
	$GiveUp.pressed.connect(on_give_up)
	if difficulty==Enums.Difficulty.EASY:
		mul=easy_mul
		max_count=easy_count
		max_spawn_count=easy_spawn_count
	elif difficulty==Enums.Difficulty.HARD:
		mul=hard_mul
		max_count=hard_count
		max_spawn_count=normal_spawn_count
	else:
		max_count=normal_count
		max_spawn_count=hard_spawn_count
	successed=0
	failed=0
	wait=4
	preset_current_index=0
	play=true
	$Label.text="3"
	countdown=3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var in_time
	for note in notes:
		note.position.y+=note_speed*delta
#		note.get_rect().get_center()
#		$Panel/TextureRect.get_rect().get_center()
#	if Input.is_action_just_pressed("right"):
#		velocity.x+=1
#	if Input.is_action_just_pressed("down"):
#		velocity.y+=1
#	if Input.is_action_just_pressed("left"):
#		velocity.x-=1
#	if Input.is_action_just_pressed("up"):
#		velocity.y-=1

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
	
	if current_preset==null:
		current_preset=presets.pick_random()
		preset_current_index=0
		return

	var note=TextureRect.new()
	note.texture=note_texture
	note.size=Vector2(64,8)
	count+=1
	notes.push_back(note)
	$Panel.add_child(note)
	
	if preset_current_index<current_preset.intervals.size():
		wait+=current_preset.intervals[preset_current_index]*mul
	
	preset_current_index+=1
	
	if preset_current_index>=current_preset.texts.size()||count>=max_count:
		current_preset=null
		if count>=max_count:
			stop(false)
		else:
			wait+=base_interval

func on_hit(result):
	$VBoxContainer/Label.text="Score: %.1f%%(%d/%d)"%[100*get_score(),successed-failed,max_spawn_count]

func stop(give_up):
	play=false
	if !give_up:
		while notes.size()>0:
			await get_tree().create_timer(0.5).timeout
		await get_tree().create_timer(2.5).timeout
	end.emit(base_earn*get_score()/mul)
	queue_free()

func on_give_up():
	stop(true)

func get_score():
	return (successed-failed)/float(max_spawn_count)
