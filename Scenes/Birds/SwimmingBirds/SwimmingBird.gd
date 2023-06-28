extends FlyingBird
class_name FlyingSwimmingBird


func move_to_spot(spot: BirdSpot) -> void:
	spot.bird = self
	
	if current_spot and spot.type == current_spot.type and spot.type == BirdSpot.TYPE.WATER:
		await swim(spot.global_position)
	else:
		await fly(spot.global_position)
	
	started_moving.connect(spot.set.bind("bird", null), CONNECT_ONE_SHOT)


func swim(to: Vector2) -> void:
	$StateMachine.set_state("Swim")
	await _move_to(to)

