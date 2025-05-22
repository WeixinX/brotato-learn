extends Node2D

@onready var enemy = preload("res://enemy/enemy.tscn")
var tilemap = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 找到分组为 map 的节点，其实就是我们手动分组的 bg_map 中的 TileMap
	tilemap = get_tree().get_first_node_in_group("map")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var num = randi_range(0, len(tilemap.get_used_cells(0)) - 1) # 获取 TileMap 第 0 层的单元格数
	var local_position = tilemap.map_to_local(tilemap.get_used_cells(0)[num]) # 将瓦片集的坐标转为场景中的坐标
	var enemy_temp = enemy.instantiate()
	enemy_temp.position = local_position * Vector2(6, 6) # 这个系数是 TileMap 的缩放倍数
	self.add_child(enemy_temp)
	
func delete_enemies():
	for n in self.get_children():
		if n.name != 'Timer':
			self.remove_child(n)
			n.queue_free()
