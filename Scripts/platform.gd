extends CharacterBody2D

var f = true
var below_screen = false

func _process(_delta):
	if f:
		if Globals.pos.y < self.position.y:
			Globals.score += 1
			f = false
	if not f:
		below_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	if below_screen:
		self.queue_free()
