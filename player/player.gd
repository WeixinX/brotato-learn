extends Player

var dir = Vector2.ZERO # 人物移动方向单位向量
var flip = false # 人物是否翻转
var can_move = true # 按住鼠标左键不可移动
var stop = false # 鼠标在人物碰撞体积内时停止

var level_add_num = 0

# TODO: 应该可以实现 UI 信号来进行控制
var ui_obj = null


@onready var player_ani: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	init_attr()
	choose_player("player1")
	ui_obj = get_tree().get_first_node_in_group("ui")
	ui_obj.set_hp_value(self.now_hp, self.max_hp)
	ui_obj.set_exp_value(self.now_exp, self.max_exp, self.level)
	ui_obj.set_gold(gold)
	pass

func init_attr():
	speed = 600
	now_hp = 10
	max_hp = 10
	now_exp = 0
	max_exp = 5
	level = 1
	gold = 0

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var self_pose = position
	
	# 计算人物与鼠标的方向向量
	var dir = (mouse_pos - self_pose).normalized() # normalized 归一化
	
	# 判断人物翻转（mouse_pos.x >= self_pose.x 时默认右边，不翻转）
	if dir.x >= 0:
		flip = false
	else:
		flip = true
	player_ani.flip_h = flip # 设置水平翻转
	
	# 移动
	if can_move and !stop:
		velocity = dir * speed
		move_and_slide()

func _input(event: InputEvent) -> void:
	# 若事件为按下鼠标左键，则不允许人物移动
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		can_move = false
	
	# 若事件为抬起鼠标左键，则不允许人物移动
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
		can_move = true
	
func _on_stop_mouse_entered() -> void:
	stop = true

func _on_stop_mouse_exited() -> void:
	stop = false

# 用于切换角色
func choose_player(type: String):
	# 角色资源路径
	var player_root = "res://player/assets/"
	var full_texture: Texture = load(player_root + type + "/" + type + "-sheet.png")
	
	player_ani.sprite_frames.clear_all() # 清除动画帧
	var sprite_frame_custom = SpriteFrames.new() # 创建自定义动画帧
	sprite_frame_custom.add_animation("custom")
	sprite_frame_custom.set_animation_loop("custom", true) # 设置 custom 动画循环播放 
	
	var texture_size = Vector2(960, 240) # 整张精灵图素材
	var sprite_size = Vector2(240, 240) # 人物一帧的大小
	var num_colums = int(texture_size.x / sprite_size.x)
	var num_row = int(texture_size.y / sprite_size.y)
	
	for x in range(num_colums):
		for y in range(num_row):
			var frame = AtlasTexture.new()
			frame.atlas = full_texture
			# 参数分别是裁切的起点、帧大小
			frame.region = Rect2(Vector2(x, y) * sprite_size, sprite_size) 
			sprite_frame_custom.add_frame("custom", frame)
			
	# 设置人物动画帧
	player_ani.sprite_frames = sprite_frame_custom
	
	# 播放
	player_ani.play("custom")

func _on_drop_item_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("drop_item"):
		body.can_move = true 
		self.gold += (1 + self.gold_get)
		self.now_exp += (1 + self.exp_get)
		if self.now_exp >= self.max_exp:
			self.level += 1
			self.level_add_num += 1
			self.now_exp = 0
			self.max_exp *= 2
		ui_obj.set_exp_value(self.now_exp, self.max_exp, self.level)
		ui_obj.set_gold(self.gold)
	

func _on_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("drop_item"):
		body.queue_free()
		
	if body.is_in_group("enemy"):
		self.now_hp -= 1
		ui_obj.set_hp_value(self.now_hp, self.max_hp)
		# TODO: 应当实现持续掉血 
