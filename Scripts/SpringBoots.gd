extends CharacterBody2D

var jump = -950
var can_delete = false
var collected = false

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _physics_process(_delta):
	if get_node("../Character").global_position.y < self.position.y:
		can_delete = true
	if collected:
		self.position = get_node("../Character/BootsMarker").global_position
func _process(_delta):
	if Globals.pos.y < self.position.y:
		can_delete = true
	if not collected:
		$SpringBootSprite.play("notCollected")
	if collected:
		$SpringBootSprite.flip_h = not get_node("../Character/CharacterSprite").flip_h
	if get_node("../Character").velocity.y > 0:
		$SpringBootSprite.play("idle")

func _on_visible_on_screen_enabler_2d_screen_exited():
	if can_delete:
		self.queue_free()

func _on_spring_boots_jumping_body_entered(body):
	get_node("../Character").JUMP_VELOCITY = jump
	if body.name == "Character" and Globals.can_pick:
		$BootTimer.start(5)
		collected = true
		Globals.can_pick = false
		Globals.emit_signal("has_boots")

func _on_boot_timer_timeout():
	Globals.can_pick = true
	Globals.emit_signal("lost_boots")
	self.queue_free()
