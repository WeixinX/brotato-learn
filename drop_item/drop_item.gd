extends CharacterBody2D

var speed = 1000
var can_move = false
var player = null

func _ready() -> void:
	self.hide()
	self.set_collision_layer_value(5, false) # 防止全局 drop_item 节点被当做掉落物吸取
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if can_move:
		var dir = (player.global_position - self.global_position).normalized()
		velocity = dir * speed
		move_and_slide()

# TODO：与敌人受击、死亡动画逻辑一致，可进一步抽象封装
'''
options.box 掉落物父级
options.ani_name 掉落物名称
options.position 掉落物生成坐标
options.scale 掉落物缩放等级
'''
func gen_drop_item(options):
	if !options.has("box"):
		options.box = GameMain.duplicate_node

	var di_temp = self.duplicate()
	options.box.add_child.call_deferred(di_temp)
	di_temp.set_collision_layer_value.call_deferred(5, true)
	di_temp.show.call_deferred()
	di_temp.scale = options.scale if options.has("scale") else Vector2(1, 1)
	di_temp.position = options.position
	
	di_temp.get_node("all_animations").play(options.ani_name)
