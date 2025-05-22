extends Node

var duplicate_node = null

var animation_scene = preload("res://animations/animations.tscn")
var animation_scene_obj = null

var drop_item_scene = preload("res://drop_item/drop_item.tscn")
var drop_item_scene_obj = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_duplicate_node()
	
	animation_scene_obj = animation_scene.instantiate()
	add_child(animation_scene_obj)
	
	drop_item_scene_obj = drop_item_scene.instantiate()
	add_child(drop_item_scene_obj)
	
func init_duplicate_node():
	if duplicate_node != null:
		duplicate_node.queue_free()
	var node2d = Node2D.new()
	node2d.name = "deplicate_node"
	# 将这个 deplicate_node 放在最外层，保证能看到动画，但似乎直接 add_child 也能看到
	get_window().add_child.call_deferred(node2d)
	# add_child(node2d)
	duplicate_node = node2d

func _process(delta: float) -> void:
	pass
