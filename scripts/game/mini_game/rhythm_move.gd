extends TextureRect

enum TileType{EMPTY,CERAMIC,NOTE}
static var tile_type_atlas_map={
	TileType.EMPTY:Vector2i(0,0),
	TileType.CERAMIC:Vector2i(1,0),
	TileType.NOTE:Vector2i(2,0)
}

var note_texture=preload("res://textures/empty.png")

@export var presets:Array[NotesPreset]
@export var easy_count:int
@export var normal_count:int
@export var hard_count:int

@export var easy_spawn_count:int
@export var normal_spawn_count:int
@export var hard_spawn_count:int

@export var easy_map_size:int
@export var normal_map_size:int
@export var hard_map_size:int

@export var easy_mul:float
@export var hard_mul:float

@export var base_interval:float
@export var base_earn:float=2

@export var note_speed=256

var mul=1.0
var successed=0
var failed=0
var wait=4

var count=0
var max_count
var max_spawn_count
var map_size
var notes=[]
var notes_left

var preset_current_index=0
var current_preset=null
var play=false
var countdown

@onready var tile_map=$VBoxContainer/Control/TileMap
@onready var player=$VBoxContainer/Control/Player
var player_coord=Vector2i(0,0)

signal note_free()
signal end(score:float)

func start(difficulty):
	end.connect(Game.instance.mini_game_end(Enums.MiniGame.SINGING_PRACTICE))
	$GiveUp.pressed.connect(on_give_up)
	if difficulty==Enums.Difficulty.EASY:
		mul=easy_mul
		max_count=easy_count
		max_spawn_count=easy_spawn_count
		map_size=easy_map_size
	elif difficulty==Enums.Difficulty.HARD:
		mul=hard_mul
		max_count=hard_count
		max_spawn_count=normal_spawn_count
		map_size=hard_map_size
	else:
		max_count=normal_count
		max_spawn_count=hard_spawn_count
		map_size=normal_map_size
	successed=0
	failed=0
	wait=4
	preset_current_index=0
	play=true
	$Label.text="3"
	countdown=3
	notes_left=max_count
	update_display_score()
	update_display_count()

	var square=map_size*map_size
	var pivot=map_size*0.5
	var generated=[]
	generated.resize(square)
	generated.fill(TileType.EMPTY)
	for i in max_spawn_count:
		var index=randi()%square
		while generated[index]!=TileType.EMPTY or index==square*0.5+pivot:
			index=randi()%square
		generated[index]=TileType.NOTE
	for i in max_spawn_count*2:
		var index=randi()%square
		while generated[index]!=TileType.EMPTY or index==square*0.5+pivot:
			index=randi()%square
		generated[index]=TileType.CERAMIC

	for i in square:
		tile_map.set_cell(0,Vector2i(i/map_size-pivot,i%map_size-pivot),0,tile_type_atlas_map[generated[i]])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_notes(delta)

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
	note.position=Vector2(0,-4)
	note.size=Vector2(64,8)
	count+=1
	notes.push_back(note)
	$Panel.add_child(note)
	
	if preset_current_index<current_preset.intervals.size():
		wait+=current_preset.intervals[preset_current_index]/mul
	
	preset_current_index+=1
	
	if preset_current_index>=current_preset.texts.size()||count>=max_count or successed==max_spawn_count:
		current_preset=null
		if count>=max_count:
			stop(false)
		else:
			wait+=base_interval

func move(motion):
	player_coord+=motion
	var pivot=map_size*0.5
	var origin=$VBoxContainer/Control.size*0.5
	var tile_size=Vector2(tile_map.tile_set.tile_size)
	clamp(player_coord,Vector2i(-pivot,-pivot),Vector2i(pivot-1,pivot-1))
	player.position=origin+Vector2(player_coord)*tile_size+tile_size*0.5-player.size*0.5
	var atlas=tile_map.get_cell_atlas_coords(0,player_coord)
	if atlas.x==TileType.CERAMIC:
		tile_map.set_cell(0,player_coord,0,tile_type_atlas_map[TileType.EMPTY])
		failed+=1
	elif atlas.x==TileType.NOTE:
		tile_map.set_cell(0,player_coord,0,tile_type_atlas_map[TileType.EMPTY])
		successed+=1
	update_display_score()

func stop(give_up):
	play=false
	if !give_up:
		while notes.size()>0:
			await note_free
		await get_tree().create_timer(3,false).timeout
	end.emit(base_earn*get_score()/mul)
	queue_free()

func on_give_up():
	stop(true)

func get_score():
	return max(successed-failed,0)/float(max_spawn_count)

func update_display_score():
	$VBoxContainer/Label.text="Score: %.1f%%(%d/%d)"%[100*get_score(),successed-failed,max_spawn_count]

func update_display_count():
	$Panel/Label.text="%d"%notes_left

func process_notes(delta):
	var in_time
	var i=0
	while i<notes.size():
		var note=notes[i]
		note.position.y+=note_speed*mul*delta
		var y=note.get_rect().get_center().y
		var dequeue=y>=828

		if absf(y-$Panel/TextureRect.get_rect().get_center().y)<note_speed*0.1:
			var motion=Vector2i.ZERO
			if Input.is_action_just_pressed("right"):
				motion.x+=1
			elif Input.is_action_just_pressed("down"):
				motion.y+=1
			elif Input.is_action_just_pressed("left"):
				motion.x-=1
			elif Input.is_action_just_pressed("up"):
				motion.y-=1

			if motion.length_squared()>0:
				$Panel/GPUParticles2D.restart()
				dequeue=true
				move(motion)

		if dequeue:
			notes_left-=1
			update_display_count()
			notes.remove_at(i)
			i-=1
			note.queue_free()
			note_free.emit()
		i+=1
