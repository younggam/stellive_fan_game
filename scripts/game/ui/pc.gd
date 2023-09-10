extends VBoxContainer

var current=null

# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(on_visibility_changed)
	$Panel/GridContainer/HiatusToggle.toggled.connect(on_hitaus_toggled)
	$Back.pressed.connect(on_back_button)


func initialize(pc):
	if pc==null:
		return
	current=pc
	$Panel/GridContainer/MemberOption.selected=current.member
	$Panel/GridContainer/CategoryOption.selected=current.category
	$Panel/GridContainer/HiatusToggle.button_pressed=current.hitaus

	show()

func on_back_button():
	hide()

func on_visibility_changed():
	if visible:
		return
	current.member=$Panel/GridContainer/MemberOption.selected
	current.category=$Panel/GridContainer/CategoryOption.selected
	current.hitaus=$Panel/GridContainer/HiatusToggle.button_pressed

	current=null

func on_hitaus_toggled(toggled):
	if toggled:
		$Panel/GridContainer/HiatusToggle.text="Yes"
	else:
		$Panel/GridContainer/HiatusToggle.text="No"
