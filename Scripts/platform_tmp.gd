extends CharacterBody2D
var anim_play = false

func _on_platform_area_body_entered(body):
	if body.name == "Character":
		anim_play = true
		$PlatformSprite.play("Break")

func _on_platform_sprite_animation_finished():
	if anim_play:
		self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	if not anim_play:
		self.queue_free()
