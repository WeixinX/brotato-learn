extends Node2D

@onready var tile_map: TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random_tile()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func random_tile():
	tile_map.clear_layer(1) # 清除 tile map 图层 1，也就是 bg1
	var bg1_cells = tile_map.get_used_cells(0) # 获取 bg0 的单元块集合
	var ran = RandomNumberGenerator.new()
	
	for cell_pos in bg1_cells:
		# 为随机的单元块设置 tile
		var num = ran.randi_range(0, 100)
		if num <= 5:
			# set_cell 的参数分别是：图层、cell 坐标、素材（源） ID、tile 的图集坐标
			tile_map.set_cell(1, cell_pos, 1, Vector2i(18, 1))
			
	for cell_pos in bg1_cells:
		var num = ran.randi_range(0, 100)
		if num <= 1:
			tile_map.set_cell(1, cell_pos, 1, Vector2i(9, 3))
			
	for cell_pos in bg1_cells:
		var num = ran.randi_range(0, 200)
		if num <= 1:
			tile_map.set_cell(1, cell_pos, 1, Vector2i(5, 2))


func _on_game_ui_round_end() -> void:
	get_tree().paused = true # 游戏暂停
	$scene_update.init() # 打开会和结束的属性页面
	pass


func _on_scene_update_continue_game() -> void:
	get_tree().paused = false
	$scene_update.hide()
	$player.now_hp = $player.max_hp
	$player.ui_obj.set_hp_value($player.now_hp, $player.max_hp)
	$game_ui.init_round()
	
	# 清空场上的敌人和金币
	$now_enemies.delete_enemies()
	var drop_items = get_tree().get_nodes_in_group("drop_item")
	for di in drop_items:
		if di.get_collision_layer_value(5): # 使得基础 drop_item 不被清除
			self.remove_child(di)
			di.queue_free()
	
	# 人物复位
	$player.global_position = Vector2(1218, 938)
	
	pass
