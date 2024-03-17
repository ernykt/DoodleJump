extends CharacterBody2D

@onready var player = $CharacterSprite

@export var kill_timer = 10

var SPEED = 300.0
var JUMP_VELOCITY = -750

var jumped = false
var flying = false
var has_boots = false

func _ready():
	rotate_degrees(360)
	Globals.connect("test",_is_jumped)
	Globals.connect("flying",_is_flying)
	Globals.connect("done_flying",_done_flying)
	Globals.connect("has_boots",_has_boots)
	Globals.connect("lost_boots",_lost_boots)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	Globals.pos = player.global_position
	if not is_on_floor():
		velocity.y += gravity * delta
		if Globals.can_pick:
			player.play("jump")
			$"../KillPlayer".start(kill_timer)
	# Handle Jump.
	if velocity.y > 0:
		player.play("Falling")
	if is_on_floor():
		if not has_boots:
			velocity.y = JUMP_VELOCITY
		$"../KillPlayer".stop()
	#if jumped or has_boots:
		#$"../KillPlayer".start(kill_timer)
		#jumped = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction == -1:
			$CharacterSprite.flip_h = true
		else:
			$CharacterSprite.flip_h = false
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#check borders
	if self.global_position.x < 0:
		self.position.x = 800
	if self.global_position.x > 800:
		self.position.x = 0

	move_and_slide()

func rotate_degrees(degree):
	var twe = create_tween()
	twe.tween_property(self, "rotation", deg_to_rad(degree), 1)
	
func _is_jumped():
	jumped = true
func _is_flying():
	flying = true
func _done_flying():
	flying = false
func _has_boots():
	has_boots = true
func _lost_boots():
	has_boots = false
func _on_kill_player_timeout():
	Globals.score = 0
	get_tree().reload_current_scene()
