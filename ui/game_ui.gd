extends CanvasLayer

@onready var hp_value_bar: ProgressBar = $%hp_value_bar
@onready var exp_value_bar: ProgressBar = $%exp_value_bar
@onready var gold: Label = $%gold

signal round_end
@onready var now_round: Label = $count_down/now_round
@onready var time_show: Label = $count_down/time_show
@onready var timer: Timer = $count_down/Timer
var now_round_num = 0:
	set(val):
		now_round_num = val
		now_round.text = "第 %d 波" % [val]
var round_time = 0:
	set(val):
		round_time = val
		time_show.text = str(val)

func _ready() -> void:
	init_round()
	pass

func init_round():
	now_round_num += 1
	round_time = 10
	timer.start()

func _process(delta: float) -> void:
	pass

# TODO: 通过人物碰到敌人时触发信号实现，UI 逻辑捕获信号实现
func set_hp_value(now_hp, max_hp):
	hp_value_bar.value = now_hp
	hp_value_bar.max_value = max_hp
	hp_value_bar.get_node("Label").text = str(now_hp) + "/" + str(max_hp)

# TODO: 通过掉落物进入人物范围时触发信号，UI 逻辑捕获信号实现
func set_exp_value(now_exp, max_exp, level):
	exp_value_bar.value = now_exp
	exp_value_bar.max_value = max_exp
	exp_value_bar.get_node("Label").text = "LV." + str(level)

# TODO: 通过掉落物进入人物范围时触发信号，UI 逻辑捕获信号实现	
func set_gold(now_gold):
	gold.text = str(now_gold)


func _on_timer_timeout() -> void:
	round_time -= 1
	if round_time <= 0:
		timer.stop()
		emit_signal("round_end")
		
