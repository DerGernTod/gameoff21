extends Node2D

const MIN_DIST: int = 750		# between starting flowers
const RETRIES: int = 30 		# number of attemps to look for a new flower position around a reference point
const STARTING_FIELD_RECT := Rect2(Vector2(-2000, -2000), Vector2(4000, 4000))
const TRANSPOSE: Vector2 = - STARTING_FIELD_RECT.position
const ANNULUS_RADIUS: int = 140
const FLOWERS_PER_ANNULUS: int = 4
const NUM_OF_ANNULI: int = 3


onready var Flower = preload("res://flower_field/flower/Flower.tscn")
onready var _viewport_size = get_viewport().size


func _ready() -> void:
	print("viewport size is %s " % _viewport_size)
	randomize()
	_add_starting_flowers()


func add_flower(pos: Vector2) -> void:
	var inst = Flower.instance()
	inst.position = pos
	#print("generating flower at %s" % inst.position)
	add_child(inst)


func add_flower_group(pos: Vector2) -> void:
	var rng = RandomNumberGenerator.new()
	# TODO: define base flower stats for this group
	for i in NUM_OF_ANNULI:
		for j in FLOWERS_PER_ANNULUS:
			for k in RETRIES:
				var r:float = ANNULUS_RADIUS * (i + 1) * sqrt(rng.randf_range(i / (i + 1), 1.0))	# get random radius
				var theta:float = randf() * 2 * PI													# get random angle
				var x:float = pos.x + r * cos(theta)
				var y:float = pos.y + r * sin(theta)
				var point := Vector2(x, y)
				if _is_valid_flower_spawn_point(point):
					# TODO: define slight variation for each flower
					add_flower(point)
					break


func _add_starting_flowers() -> void:
	# algorithm used for finding starting positions: poisson disc sampling
	var start_pos := Vector2(STARTING_FIELD_RECT.position.x + STARTING_FIELD_RECT.size.x * randf(), STARTING_FIELD_RECT.position.y + STARTING_FIELD_RECT.size.y * randf())

	var cell_size: float = MIN_DIST / sqrt(2)
	var cols: int = max(floor(STARTING_FIELD_RECT.size.x / cell_size), 1)
	var rows: int = max(floor(STARTING_FIELD_RECT.size.y / cell_size), 1)
	
	var cell_size_scaled := Vector2(STARTING_FIELD_RECT.size.x / cols, STARTING_FIELD_RECT.size.y / rows)
	
	var grid: Array = []
	for i in cols:
		grid.append([])
		for j in rows:
			grid[i].append(-1)
	
	var points: Array = []
	var spawn_points: Array = []
	spawn_points.append(start_pos)
	
	while spawn_points.size() > 0:
		var spawn_index: int = randi() % spawn_points.size()
		var spawn_center: Vector2 = spawn_points[spawn_index]
		var sample_accepted: bool = false
		
		for i in RETRIES:
			var angle: float = 2 * PI * randf()
			var point: Vector2 = spawn_center + Vector2(cos(angle), sin(angle)) * (MIN_DIST + MIN_DIST * randf())
			if _is_valid_group_spawn_point(point, cell_size_scaled, cols, rows, grid, points):
				grid[int((TRANSPOSE.x + point.x) / cell_size_scaled.x)][int((TRANSPOSE.y + point.y) / cell_size_scaled.y)] = points.size()
				points.append(point)
				spawn_points.append(point)
				add_flower_group(point)
				sample_accepted = true
				break
		
		if not sample_accepted:
			spawn_points.remove(spawn_index)


func _is_valid_group_spawn_point(point: Vector2, cell_size_scaled: Vector2, cols: int, rows: int, grid: Array, points: Array) -> bool:
	if STARTING_FIELD_RECT.has_point(point):
		var cell := Vector2(int((TRANSPOSE.x + point.x) / cell_size_scaled.x), int((TRANSPOSE.y + point.y) / cell_size_scaled.y))
		var cell_start := Vector2(max(0, cell.x - 2), max(0, cell.y - 2))
		var cell_end := Vector2(min(cell.x + 2, cols - 1), min(cell.y + 2, rows -1))
		
		for i in range(cell_start.x, cell_end.x + 1):
			for j in range(cell_start.y, cell_end.y + 1):
				var search_index: int = grid[i][j]
				if search_index != -1:
					var dist: float = points[search_index].distance_to(point)
					if dist < MIN_DIST:
						return false
		
		return true
	
	return false


func _is_valid_flower_spawn_point(point: Vector2) -> bool:
	var intersections = get_world_2d().direct_space_state.intersect_point(point, 10, [], 0b10, false, true)
	return intersections.size() == 0
