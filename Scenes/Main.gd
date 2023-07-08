extends Node2D

@export var required_dough : int = 9

var breads : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	breads = get_tree().get_nodes_in_group("bread")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dough_count = 0
	for bread in breads:
		if bread.is_dough:
			dough_count += 1
	if dough_count >= required_dough:
		$UI/WinText.text = str(required_dough) + " Dough Achieved!"
		$UI/WinText.visible = true
		$UI/LoseText.visible = false
	$UI/DoughCountText.text = str(dough_count) + "/" + str(required_dough) + " Dough"
