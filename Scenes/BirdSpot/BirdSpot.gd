extends Marker2D
class_name BirdSpot

enum TYPE {
	BRANCH = 1,
	GROUND = 2,
	WATER = 4
}

@export var oneshot : bool = false
@export var type : TYPE = TYPE.BRANCH
var bird : Node2D:
	set(value):
		if value != bird:
			bird = value
			if value == null and oneshot:
				queue_free()

func is_free() -> bool: return bird == null
