extends ReferenceRect
class_name BirdLine

@export var bird_spot_type : BirdSpot.TYPE

func get_land_bird_spot() -> BirdSpot:
	var rdm_weight = randf() 
	var rdm_point = lerp(global_position, global_position + size, rdm_weight)
	
	var spot = BirdSpot.new()
	add_child.call_deferred(spot)
	
	spot.type = bird_spot_type
	spot.global_position = rdm_point
	spot.oneshot = true
	
	return spot
