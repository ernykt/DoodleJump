extends CharacterBody2D

var f = true
var below_screen = false
var move_right = true
var move_left = false
var speed = 200

func _process(delta):
	var pos = int(global_position.x)
	if f:
		if Globals.pos.y < self.position.y:
			Globals.score += 1
			f = false
	if move_right:
		move_local_x(delta * speed)
	if pos == 700:
		move_right = false
		move_left = true
	if move_left:
		move_local_x(delta * -speed)
	if pos == 100:
		move_left = false
		move_right = true
	if not f:
		below_screen = true
	
func _on_visible_on_screen_notifier_2d_2_screen_exited():
		if below_screen:
			self.queue_free()
