extends Bird
class_name SwimmingBird

func swim(to: Vector2) -> void:
	$StateMachine.set_state("Swim")
	await _move_to(to)

