extends Node2D

var plat = preload("res://Scenes/platform.tscn")
var plat_tmp = preload("res://Scenes/platform_tmp.tscn")
var plat_move = preload("res://Scenes/platform_moving.tscn")
var spr = preload("res://Scenes/spring.tscn")
var propel = preload("res://Scenes/propeller.tscn")
var boots = preload("res://Scenes/spring_boots.tscn")

var arr : Array
var test_arr : Array
var gap = 50
var spawnBuffer = 800
var f = false

func _ready():
	test_arr = [plat, plat_tmp, plat_move]
	spawn_platforms(test_arr, 5, $"../Character".position.y)

func _process(_delta):
	#print(arr.size())
	if $"../Character".position.y < arr[arr.size() - 1].position.y + spawnBuffer:
		spawn_platforms(test_arr, 5, arr[arr.size() - 1].position.y)
		
func spawn_platforms(platforms : Array, platform_count, last_platform_pos_y):
	var tmp_count = 0
	for i in range(0, platform_count):
		var platform_scene
		var chance_moving = randi_range(1,5)
		var chance_tmp = randi_range(1,10)
		var chance_pro = randi_range(1,20)
		var chance_spr = randi_range(1,10)
		#var chance_boots = randi_range(0,1)
		if chance_moving == 5:
			platform_scene = platforms[2]
		elif chance_tmp == 9 and tmp_count < 2:
			platform_scene = platforms[1]
			tmp_count += 1
		else:
			platform_scene = platforms[0]
		var tmp = platform_scene.instantiate()
		var t = Vector2(randi_range(50, 750), last_platform_pos_y - (i + 1) * gap)
		tmp.position = t
		arr.append(tmp)
		add_child(tmp)
		if chance_spr == 2 and chance_moving != 5 and chance_tmp != 9:
			spawn_powerup(spr, tmp.position,10)
		elif chance_pro == 4 and chance_moving != 5 and chance_tmp != 9:
			spawn_powerup(propel, tmp.position,20)
		#elif chance_boots == 0 and chance_moving != 5 and chance_tmp != 9:
			#spawn_powerup(boots, tmp.position,10)

func _on_deleter_body_entered(body):
	body.queue_free()

func spawn_powerup(power_up, pos, offset):
	var t = power_up.instantiate()
	t.position.y = pos.y - offset
	t.position.x = pos.x
	$"..".add_child.call_deferred(t)
