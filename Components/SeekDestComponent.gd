extends Node
class_name SeekLandSpotComponent

@export_flags("branch", "ground", "water") var land_spots : int = BirdSpot.TYPE.BRANCH
@export var holder : Node2D

func seek_spot() -> BirdSpot:
	var nb_land_type = _get_nb_land_type()
	
	if land_spots & BirdSpot.TYPE.WATER and nb_land_type > 0 and randi() % nb_land_type == 0:
		return _get_bird_line_spot("SwimLine")
	
	elif land_spots & BirdSpot.TYPE.GROUND and nb_land_type > 0 and randi() % nb_land_type == 0:
		return _get_bird_line_spot("WalkLine")
	
	var spots_array = get_tree().get_nodes_in_group("BirdSpot") as Array[BirdSpot]
	spots_array.shuffle()
	
	for spot in spots_array:
		if !(land_spots & spot.type) or !spot.is_free():
			continue
		return spot
	
	return null


func _get_nb_land_type() -> int:
	var n : int = 0
	
	for key in BirdSpot.TYPE.keys():
		var value = BirdSpot.TYPE[key]
		if land_spots & value:
			n += 1
	
	return n


func _get_bird_line_spot(bird_line_group: String) -> BirdSpot:
	var bird_lines_array = get_tree().get_nodes_in_group(bird_line_group) as Array[BirdLine]
	var bird_line : BirdLine = bird_lines_array.pick_random()
	
	return bird_line.get_land_bird_spot()
