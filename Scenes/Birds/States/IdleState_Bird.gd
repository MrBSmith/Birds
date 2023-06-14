@tool
extends StateMachine

var current_spot : BirdSpot = null

const NO_MOVABLE_ERROR = "This node doesn't have any usable MoveComponent, it can't perform any movement"

@onready var default_move_component : MoveComponent = _fetch_default_move_component()

@export var fly_component : MoveComponent
@export var walk_component : MoveComponent
@export var swim_component : MoveComponent

@export var seek_spot_component : SeekLandSpotComponent

@export var wait_timer : Timer

@export_range(0.0, 99.0) var avg_wait_time : float
@export_range(0.0, 99.0) var wait_time_variance : float


func _ready() -> void:
	if wait_timer:
		wait_timer.timeout.connect(_on_wait_timer_timeout)


func enter_state() -> void:
	if wait_timer:
		wait_timer.start(randfn(avg_wait_time, wait_time_variance))
	
	if !default_state:
		return
	
	if current_spot:
		if current_spot.type & BirdSpot.TYPE.WATER:
			set_state("Water")
		else:
			set_state("Floor")


func _fetch_default_move_component() -> MoveComponent:
	for comp in [fly_component, walk_component, swim_component]:
		if comp != null:
			return comp
	return null


func _on_wait_timer_timeout() -> void:
	if is_current_state() and seek_spot_component:
		var spot = seek_spot_component.seek_spot()
		var move_comp : MoveComponent
		
		if current_spot and spot.type == current_spot.type:
			if spot.type & BirdSpot.TYPE.WATER and swim_component:
				move_comp = swim_component
			
			elif spot.type & BirdSpot.TYPE.GROUND and walk_component:
				move_comp = walk_component
		
		if move_comp == null:
			if default_move_component:
				move_comp = default_move_component
			else:
				push_error(NO_MOVABLE_ERROR)
				return
		
		current_spot = spot
		move_comp.move_to_spot(spot)
