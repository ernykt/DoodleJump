extends CharacterBody2D

var can_delete = false
var jumped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
func _process(_delta):
	if Globals.pos.y < self.position.y:
		can_delete = true
		
func _on_jumping_area_body_entered(body):
	if body.name == "Character" and Globals.can_pick:
		body.velocity.y = -950
		Globals.emit_signal("test")
		jumped = true
		$SpringSprite.play("jumped")
		
func _on_jumping_area_body_exited(body):
	if body.name == "Character":
		$SpringSprite.play("idle")

func _on_visible_on_screen_enabler_2d_screen_exited():
	if can_delete:
		self.queue_free()
