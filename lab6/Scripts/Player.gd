extends RigidBody2D

@onready var move_right_force = Vector2(20, 0)
@onready var move_left_force = Vector2(-20, 0)
@onready var jump_force = Vector2(0, -300)
@onready var move_speed_max = 180
@onready var ray_right_foot = $RayCast_right
@onready var ray_left_foot = $RayCast_left
@onready var ap = $AnimationPlayer
@onready var musicBus = AudioServer.get_bus_index("Music")
@onready var sfxBus = AudioServer.get_bus_index("SFX")
@onready var sprite = $Sprite2D
@onready var jumpSound = $JumpFX
@onready var attackSound = $AttackFX
@onready var hurtSound = $HurtFX
@onready var can_jump = false

var attackAction = false
var delayAction = false
var delayAttackTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delayAttackTimer = get_node("DelayAttackTimer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.win == false:
		if Global.loseArea == false and Global.loseKill == false:
			if Global.getHurt == true:
				AudioServer.set_bus_mute(sfxBus, false)
				hurtSound.play()
			set_state()
			process_input()
	else:
		AudioServer.set_bus_mute(musicBus, true)
	if Global.loseArea == true:
		#queue_free()
		AudioServer.set_bus_mute(musicBus, true)
		linear_velocity = Vector2(0, 0)
	elif Global.health <= 0:
		if Global.loseKill == false:
			Global.loseKill = true
			AudioServer.set_bus_mute(musicBus, true)
			ap.play("die")

func set_state():
	if ray_left_foot.is_colliding() or ray_right_foot.is_colliding():
		can_jump = true
	else:
		can_jump = false

func process_input():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right") and attackAction == false:
		if self.linear_velocity.x < move_speed_max:
			self.apply_impulse(move_right_force, Vector2(0,0))
		direction.x += 1
	if Input.is_action_pressed("ui_left") and attackAction == false:
		if self.linear_velocity.x > -move_speed_max:
			self.apply_impulse(move_left_force, Vector2(0,0))
		direction.x -= 1
		
	if Input.is_action_just_pressed("ui_accept") and can_jump == true and attackAction == false:
		AudioServer.set_bus_mute(sfxBus, false)
		jumpSound.play()
		#if self.linear_velocity.y < jump_limit_max
		self.apply_impulse(jump_force, Vector2(0, 0))
	
	if Input.is_action_just_pressed("ui_attack"):
		attackAction = true
	
	if direction.x != 0:
		switch_direction(direction.x)
	
	if attackAction == false && delayAction == false:
		update_animations(direction.x)
	elif attackAction == true && delayAction == false:
		AudioServer.set_bus_mute(sfxBus, false)
		attackSound.play()
		ap.play("attack")
		delayAction = true
		delayAttackTimer.start()

func switch_direction(horizontal_direction):
	sprite.flip_h = (horizontal_direction == -1)

func update_animations(horizontal_direction):
	if can_jump == true:
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		pass

func _on_delay_attack_timer_timeout() -> void:
	attackAction = false
	delayAction = false
	AudioServer.set_bus_mute(sfxBus, true)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
