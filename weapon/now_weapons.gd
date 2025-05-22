extends Node2D

var weapon_radius = 260
var weapon_num = 0

func _ready() -> void:
	weapon_num = self.get_child_count() # 获取 now_weapons 节点下的子节点数量
	var unit = TAU / weapon_num # TAU 是 2*PI，即单位圆周长，unit 为计算的单位弧度
	var weapons = self.get_children()
	
	for i in len(weapons):
		var weapon = weapons[i]
		var weapon_rad = unit * i
		# 后半部分是将 (weapon_radius, 0) 向量旋转 weapon_rad 弧度
		var end_pos = weapon.position + Vector2(weapon_radius, 0).rotated(weapon_rad)
		weapon.position = end_pos


func _process(delta: float) -> void:
	pass
