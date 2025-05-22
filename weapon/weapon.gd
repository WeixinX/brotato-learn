extends Node2D

var bullet_shoot_time = 0.1
var bullet_speed = 2000
var bullet_hurt = 1

@onready var weapon_ani: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_pos: Marker2D = $shoot_pos
@onready var timer: Timer = $Timer

@onready var bullet = preload("res://bullet/bullet.tscn")

const weapon_level = {
	level_1 = "#b0c3d9",
	level_2 = "#4b69ff",
	level_3 = "#d32ce6",
	level_4 = "#8847ff",
	level_5 = "#eb4b4b",
}

var attack_enemies = []

func _ready() -> void:
	# 在 Material/Resource 打开 Local to Scenes，使得效果对单场景生效 
	# 就不需要对 weapon_ani 进行 duplicated 了
	weapon_ani.material.set_shader_parameter("color", Color(weapon_level['level_' + str(randi_range(1, 5))]))

func _process(delta: float) -> void:
	# 设置武器朝向数组中的第一个敌人
	if attack_enemies.size() != 0:
		self.look_at(attack_enemies[0].position)
	else:
		rotation_degrees = 0
	
func _on_timer_timeout() -> void:
	if attack_enemies.size() != 0:	
		var now_bullet = bullet.instantiate()
		now_bullet.position = shoot_pos.global_position
		now_bullet.speed = bullet_speed
		now_bullet.hurt = bullet_hurt
		now_bullet.dir = (attack_enemies[0].global_position - now_bullet.position).normalized()
		get_tree().root.add_child(now_bullet) # 将子弹实例添加到场景树下作为 root 的子节点

# 敌人进入攻击范围
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and !attack_enemies.has(body):
		attack_enemies.append(body)
		# TODO: 并不需要每次都排序 O(NlogN)，仅需要将最近的敌人放在数组首尾即可 O(N)
		sort_enemies()

# 敌人离开攻击范围
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and attack_enemies.has(body):
		attack_enemies.remove_at(attack_enemies.find(body))
		sort_enemies()

func sort_enemies():
	if attack_enemies.size() != 0:
		attack_enemies.sort_custom(
			func(x, y):
				return x.global_position.distance_to(self.global_position) < y.global_position.distance_to(self.global_position)
		)
