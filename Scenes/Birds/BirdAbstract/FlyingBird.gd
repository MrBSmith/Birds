extends Bird
class_name FlyingBird


func move_to_spot(spot: BirdSpot) -> void:
	spot.bird = self
	
	await fly(spot.global_position)
	started_moving.connect(spot.set.bind("bird", null), CONNECT_ONE_SHOT)


func fly(to: Vector2) -> void:
	$StateMachine.set_state("Fly")
	await _move_to(to)
