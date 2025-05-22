extends CharacterBody2D

var dir = Vector2.ZERO
var speed = 2000
var hurt = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = dir * speed
	move_and_slide()


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("enemy"):
		self.queue_free() # 子弹消失
		body.enemy_hurt(hurt)
	
	# 当子弹碰到墙壁时进行销毁，节省资源
	if body is TileMap:
		var coords = body.get_coords_for_body_rid(body_rid) # 获取 body_rid 坐标
		var title_data = body.get_cell_tile_data(2, coords)
		var isWall = title_data.get_custom_data("isWall")
		if isWall:
			self.queue_free()
