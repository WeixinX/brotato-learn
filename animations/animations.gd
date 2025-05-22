extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
'''
options.box 动画父级
options.ani_name 动画名称
options.position 动画生成坐标
options.scale 动画缩放等级
'''
func run_animation(options):
	if !options.has("box"):
		options.box = GameMain.duplicate_node

	var ani_temp = self.duplicate()
	options.box.add_child.call_deferred(ani_temp)
	ani_temp.show.call_deferred()
	# 三目运算，相当于 options.has("scale")?options.scale:Vector2(1, 1)
	ani_temp.scale = options.scale if options.has("scale") else Vector2(1, 1)
	ani_temp.position = options.position
	
	ani_temp.get_node("all_animations").play(options.ani_name)
	

func _on_all_animations_animation_finished() -> void:
	self.queue_free()
	pass # Replace with function body.
