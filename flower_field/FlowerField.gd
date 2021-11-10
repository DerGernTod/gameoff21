extends Node2D

# determine which flowers should grow or die
# Flowers get pollinated by bees --> new flowers are a crossbreed between all the flowers that a bee pollinated.
# New flowers grow in a specific range of their ancestors.

onready var Flower = preload("res://flower_field/flower/Flower.tscn")
onready var _viewport_size = get_viewport().size


func _ready() -> void:
	print("viewport size is %s " % _viewport_size)
	randomize()
	for x in 5:
		add_flower()


func add_flower() -> void:
	var inst = Flower.instance()
	inst.position.x = randi() % int(_viewport_size.x)
	inst.position.y = randi() % int(_viewport_size.y)
	print("generating flower at %s" % inst.position)
	add_child(inst)
