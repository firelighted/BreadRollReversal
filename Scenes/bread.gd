extends Area2D

@export var is_dough = false
@export var is_held = false
@export var in_oven = false
@export var baker_can_interact = true


func _ready():
	if is_dough:
		turn_to_dough()
	else:
		turn_to_bread()


func _on_body_entered(body):
	if body.is_in_group("player"):
		if not is_dough: print("player unbaked")
		turn_to_dough()


func turn_to_dough():
	is_dough = true
	$Sprite2D.modulate = Color(0,0,1)
	if in_oven:
		$BakeUnbakeTimer.start()

func turn_to_bread():
	is_dough = false
	$Sprite2D.modulate = Color(1,1,0)


func put_on_counter():
	is_held = false
	baker_interact()

func pick_up_from_counter():
	is_held = true
	baker_interact()

func baker_interact():
	$InteractCooldownTimer.start()
	baker_can_interact = false

func put_in_oven():
	is_held = false
	in_oven = true
	turn_to_bread()
	baker_interact()


func take_from_oven():
	is_held = true
	in_oven = false
	turn_to_bread()
	baker_interact()


func _on_bake_unbake_timer_timeout():
	if in_oven: 
		turn_to_bread()


func _on_interact_cooldown_timer_timeout():
	# allow bakers to interact again, after preventing bakers
	# from rapidly interacting with the same object several times
	baker_can_interact = true
