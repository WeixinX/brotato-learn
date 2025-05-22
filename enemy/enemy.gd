extends CharacterBody2D

var dir = Vector2.ZERO
var speed = 300
var target = null
var hp = 4

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if target:
		dir = (target.global_position - self.global_position).normalized()
		velocity = dir * speed
		move_and_slide()
		
func enemy_hurt(hurt):
	self.hp -= ((hurt + target.basic_hurt) * target.basic_hurt_multiple)
	enemy_flash()
	GameMain.animation_scene_obj.run_animation({
		"box": self,
		"ani_name": "enemies_hurt",
		"position": Vector2(0, 0),
		"scale": Vector2(1.1, 1.1),
	})
	if self.hp <= 0:
		enemy_dead()
		
func enemy_dead():
	GameMain.animation_scene_obj.run_animation({
		"box": GameMain.duplicate_node,
		"ani_name": "enemies_dead",
		"position": self.global_position,
		"scale": Vector2(0.9, 0.9),
	})
	
	GameMain.drop_item_scene_obj.gen_drop_item({
		"box": GameMain.duplicate_node,
		"ani_name": "gold",
		"position": self.global_position,
		"scale": Vector2(3, 3),
	})
	self.queue_free()
	
func enemy_flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_opacity", 1)
	await get_tree().create_timer(0.1).timeout
	# 暂停当前函数执行，异步等待 timeout 后继续执行
	$AnimatedSprite2D.material.set_shader_parameter("flash_opacity", 0)
