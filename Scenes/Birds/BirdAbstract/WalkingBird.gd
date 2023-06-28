extends Bird
class_name WalkingBird


func walk(to: Vector2) -> void:
	$StateMachine.set_state("Walk")
	await _move_to(to)


func move_to_spot(spot: BirdSpot) -> void:
	spot.bird = self
	
	await walk(spot.global_position)
	started_moving.connect(spot.set.bind("bird", null), CONNECT_ONE_SHOT)
