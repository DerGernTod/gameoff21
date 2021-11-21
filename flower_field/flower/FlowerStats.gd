class_name FlowerStats

var _stats = {
	color = Color.white,
	size = 1.0
}
var _main_deviation = "color"


func _init(stats = null) -> void:
	if stats:
		_stats = stats._stats.duplicate(true)
	else:
		_stats.color = Color(randf(), randf(), randf())
		_stats.size = 1.0 + rand_range(-0.5, 0.5)
		_main_deviation = _stats.keys()[randi() % _stats.keys().size()]


func deviate() -> void:
	for key in _stats.keys():
		var dev_amount = 0.1
		if key == _main_deviation:
			dev_amount = 0.2
		if _stats[key] is Color:
			deviate_color(key, dev_amount * 0.25)
		else:
			deviate_float(key, dev_amount)


func deviate_color(stat: String, dev: float) -> void:
	_stats[stat].h = _stats[stat].h + rand_range(-dev, dev)


func deviate_float(stat: String, dev: float) -> void:
	_stats[stat] = _stats[stat] + rand_range(-dev, dev)
