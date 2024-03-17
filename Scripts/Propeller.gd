extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var collected = false
var can_delete = false


func _physics_process(_delta):
	if get_node("../Character").global_position.y < self.position.y:
		can_delete = true
	if collected:
		self.position = get_node("../Character/PropellerMarker").global_position
		
func _process(_delta):
	var bodies = $PickUpArea.get_overlapping_bodies()
	for body in bodies:
		if body.name == "Character" and Globals.can_pick:
			$PowerUpTimer.start(2)
			$AnimatedSprite2D.play("Picked")
			collected = true
			Globals.can_pick = false
			Globals.emit_signal("flying")
		if collected:
			body.velocity.y = JUMP_VELOCITY
			
func _on_power_up_timer_timeout():
	Globals.can_pick = true
	Globals.emit_signal("done_flying")
	self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	if can_delete:
		self.queue_free()
