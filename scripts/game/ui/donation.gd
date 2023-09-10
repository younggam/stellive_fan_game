extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	set_donation(124898)


func set_donation(donation):
	$Label.text="Donation %d"%donation
