extends TextureRect

var bullet_preset_map={
	Enums.BulletType.LASER:preload("res://scenes/game/mini_game/laser.tscn"),
	Enums.BulletType.SMALL_BULLET:preload("res://scenes/game/mini_game/small_bullet.tscn"),
	Enums.BulletType.MEDIUM_BULLET:preload("res://scenes/game/mini_game/medium_bullet.tscn"),
	Enums.BulletType.BIG_BULLET:preload("res://scenes/game/mini_game/big_bullet.tscn"),
	Enums.BulletType.SHORT_RECTANGLE_AREA:preload("res://scenes/game/mini_game/short_rectangle_area.tscn"),
	Enums.BulletType.MEDIUM_RECTANGLE_AREA:preload("res://scenes/game/mini_game/medium_rectangle_area.tscn"),
	Enums.BulletType.LONG_RECTANGLE_AREA:preload("res://scenes/game/mini_game/long_rectangle_area.tscn"),
	Enums.BulletType.SMALL_CIRCLE_AREA:preload("res://scenes/game/mini_game/small_circle_area.tscn"),
	Enums.BulletType.MEDIUM_CIRCLE_AREA:preload("res://scenes/game/mini_game/medium_circle_area.tscn"),
	Enums.BulletType.BIG_CIRCLE_AREA:preload("res://scenes/game/mini_game/big_circle_area.tscn"),
}

@export var presets:Array[BulletsPreset]
@export var time_cap:float
@export var time_penalty:float

@export var easy_mul:float
@export var hard_mul:float

@export var base_interval:float
@export var base_earn:float=2

var mul=1.0
var time=0.0
var failed=0
var wait=4

var count=0
var max_count

var preset_current_index=0
var current_preset=null
var play=false
var countdown

signal end(score:float)

func start(difficulty):
	end.connect(Game.instance.mini_game_end(Enums.MiniGame.GAME_SEARCH))
	$Player.collided.connect(on_collided)
	$GiveUp.pressed.connect(on_give_up)
	if difficulty==Enums.Difficulty.EASY:
		mul=easy_mul
	elif difficulty==Enums.Difficulty.HARD:
		mul=hard_mul
	time=0.0
	failed=0
	wait=4
	preset_current_index=0
	play=true
	$Label.text="3"
	countdown=3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !play:
		return
	
	if countdown<0:
		time+=delta
		$VBoxContainer/Label.text="Score: %.1f%%(%.1fs/%.0fs)"%[100*get_score(),time+failed*time_penalty,time_cap]

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
		count+=1
		return

	var bullet=bullet_preset_map[current_preset.type].instantiate()
	var pos=current_preset.positions[preset_current_index]
	var randomness=current_preset.randomnesses[preset_current_index]*0.5
	var rot=current_preset.rotations[preset_current_index]
	pos+=$Player.global_position-$VBoxContainer/Panel.global_position if current_preset.relative else $VBoxContainer/Panel.size*0.5
	bullet.initialize(pos,randf_range(rot-360*randomness,rot+360*randomness),current_preset.velocitys[preset_current_index],mul)
	$VBoxContainer/Panel.add_child(bullet)
	
	if preset_current_index<current_preset.intervals.size():
		wait+=current_preset.intervals[preset_current_index]*mul

	preset_current_index+=1

	if preset_current_index>=current_preset.positions.size():
		current_preset=null
		wait+=base_interval/mul

	if time+failed*time_penalty>time_cap:
		stop(false)

func on_collided():
	failed+=1

func stop(give_up):
	play=false
	for child in $VBoxContainer/Panel.get_children():
		child.queue_free()
	await get_tree().create_timer(0 if give_up else 3).timeout
	end.emit(base_earn*get_score()/mul)
	queue_free()

func on_give_up():
	stop(true)

func get_score():
	return time/time_cap
