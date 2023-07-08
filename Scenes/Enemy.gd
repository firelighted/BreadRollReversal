extends PathFollow2D

var speed = 200
var bread_offset = 20

var last_reparented_child : Node2D

func _process(delta : float):
	progress += delta * speed

func _on_enemy_area_entered(body: Area2D):
	if body.is_in_group("bread") and body.baker_can_interact:
		var bread = body
		if bread.is_dough and not bread.is_held:
			# off of table into hands
			#print("baker found dough")
			bread.pick_up_from_counter()
			reparent_x_to_y(bread, $Hands)
			return
	if body.is_in_group("oven"):
		var oven = body.get_child(0) # first child of the oven must be a container for bread
		if $Hands.get_child_count() > 0 and oven.get_child_count() < 1:
			# dough out of hands into empty oven
			#print("baker near oven")
			var dough = get_dough_from_hands()
			if dough and dough.baker_can_interact:
				dough.put_in_oven()
				reparent_x_to_y(dough, oven)
			return
		elif oven.get_child_count() > 0:
			# take bread from oven
			var bread = oven.get_child(0)
			if bread and bread.baker_can_interact and not bread.is_dough:
				bread.take_from_oven()
				reparent_x_to_y(bread, $Hands)
			return
	if body.is_in_group("counter"):
		var counter = body.get_child(0)
		if get_bread_from_hands() and counter.get_child_count() < 1:
			# move bread out of hands onto counter
			#print("baker near counter")
			var bread = get_bread_from_hands()
			if bread and bread.baker_can_interact:
				bread.put_on_counter()
				reparent_x_to_y(bread, counter)
			return

func reparent_x_to_y(child, new_parent):
	# change child's parent to new_parent
	child.get_parent().remove_child(child)
	new_parent.call_deferred("add_child", child)
	# stack children with an offset
	child.position = Vector2(0, -new_parent.get_child_count() * bread_offset)
	last_reparented_child = child
	#child.global_position = Vector2(new_parent.global_position.x, new_parent.global_position.y - new_parent.get_child_count() * bread_offset)

	
func get_dough_from_hands():
	# get the first unbaked dough being held
	for item in $Hands.get_children():
		if item.is_dough:
			return item
	return null


func get_bread_from_hands():
	# get the first baked dough being held
	for item in $Hands.get_children():
		if not item.is_dough:
			return item
	return null

func _on_view_area_2d_body_entered(_body):
	# react to seeing player
	print("saw player")
	$"../../UI/LoseText".visible = true
	get_tree().reload_current_scene()


func _on_reparent_timer_timeout():
	if last_reparented_child: 
		last_reparented_child.position = Vector2(0, -last_reparented_child.get_index() * bread_offset)
