extends CanvasLayer

@onready var attr_item_chose: GridContainer = $attr_item_chose
@onready var attr_item_template: Panel = $attr_item_chose/attr_item_template

@onready var attr_list: VBoxContainer = $attr/MarginContainer/ScrollContainer/attr_list
@onready var attr_template: HBoxContainer = $attr/MarginContainer/ScrollContainer/attr_list/attr_template

@onready var update: Label = $update
@onready var refresh: Button = $refresh
@onready var continue_btn: Button = $continue

const ATTR_GROUP = {
	"attack": {
		"name": "攻击力",
		"type1": {
			"name": "基础伤害叠加",
			"img": "basic_hurt"
		},
		"type2": {
			"name": "基础伤害倍数",
			"img": "basic_hurt"
		},
	},
	"speed": {
		"name": "速度",
		"type1": {
			"name": "移动速度",
			"img": "speed"
		}
	},
	"hp": {
		"name": "血量",
		"type1": {
			"name": "最大血量",
			"img": "max_hp"
		}
	},
	"get_add": {
		"name": "获取叠加",
		"type1": {
			"name": "金币获取叠加",
			"img": "gold_get"
		},
		"type2": {
			"name": "经验获取叠加",
			"img": "exp_get"
		}
	},
}

const attr_data = {
	"basic_hurt": {
		"group": ATTR_GROUP.attack,
		"type": "type1",
		"range": "1-5"
	},
	"basic_hurt_multiple": {
		"group": ATTR_GROUP.attack,
		"type": "type2",
		"range": "2-4"
	},
	"speed": {
		"group": ATTR_GROUP.speed,
		"type": "type1",
		"range": "50-200"
	},
	"max_hp": {
		"group": ATTR_GROUP.hp,
		"type": "type1",
		"range": "1-10"
	},
	"gold_get": {
		"group": ATTR_GROUP.get_add,
		"type": "type1",
		"range": "1-5"
	},
	"exp_get": {
		"group": ATTR_GROUP.get_add,
		"type": "type2",
		"range": "1-5"
	}
}

var player = null

signal continue_game

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	attr_item_template.hide()
	attr_template.hide()
	pass
	
func init():
	self.show()
	
	attr_item_chose.show()
	refresh.show()
	update.show()
	continue_btn.show()
	
	if player.level_add_num > 0:
		# 属性加成选择
		gen_attr_choose()
		continue_btn.hide()
	else:
		attr_item_chose.hide()
		refresh.hide()
		update.hide()
		
	# 加载角色属性
	load_player_attr()

func gen_attr_choose():
	for item in attr_item_chose.get_children():
		if item.is_visible():
			attr_item_chose.remove_child(item)
			item.queue_free()
			
	for i in range(4):
		var item = attr_item_template.duplicate()
		
		# 获取一种随机属性 
		var keys = attr_data.keys()
		var num = randi_range(0, keys.size() - 1)
		var k = keys[num]
		var v = attr_data[k]
		
		# 生成属性图片和文字
		var base_path = "MarginContainer/HBoxContainer"
		item.get_node(base_path + "/TextureRect").texture = load("res://scenes/scene_update/assets/" + v.group[v.type].img + ".png")
		item.get_node(base_path + "/VBoxContainer/Label").text = v.group.name
		
		# 生成属性数值
		var range = v.range.split("-")
		var attr_val = randi_range(int(range[0]), int(range[1]))
		item.get_node("RichTextLabel").text = "[color=green]+" + str(attr_val) + "[/color] " + v.group[v.type].name
		
		item.get_node("Button").pressed.connect(choose_attr.bind({
			"key": k,
			"attr": v,
			"val": attr_val
		}))
		
		item.show()
		attr_item_chose.add_child(item)
	pass
	
func choose_attr(attr_info):
	player[attr_info.key] += attr_info.val
	
	player.level_add_num -= 1
	if player.level_add_num > 0:
		# 属性加成选择
		gen_attr_choose()
	else:
		attr_item_chose.hide()
		refresh.hide()
		update.hide()
		continue_btn.show()
		
	load_player_attr()
	

func load_player_attr():
	for item in attr_list.get_children():
		if item.is_visible():
			attr_list.remove_child(item)
			item.queue_free()
			
	# 获取 Player 类的属性
	var prop_list = player.get_script().get_base_script().get_script_property_list()
	print(prop_list)
	# 设置属性
	for prop in prop_list:
		if prop.name.rfind(".gd") == -1:
			var item = attr_template.duplicate()
			item.get_node("name").text = tr(prop.name)
			item.get_node("value").text = str(player[prop.name])
			item.show()
			attr_list.add_child(item)
	pass
	


func _on_refresh_pressed() -> void:
	if player.gold >= 2:
		player.gold -= 2
		player.ui_obj.set_gold(player.gold)
		gen_attr_choose()
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	emit_signal("continue_game")
	pass # Replace with function body.
