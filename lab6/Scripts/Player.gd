extends RigidBody2D

@onready var move_right_force = Vector2(20, 0)
@onready var move_left_force = Vector2(-20, 0)
@onready var jump_force = Vector2(0, -300)
@onready var move_speed_max = 180
@onready var ray_right_foot = $RayCast_right
@onready var ray_left_foot = $RayCast_left
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var can_jump = false

var attackAction = false
var delayAction = false
var delayAttackTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	delayAttackTimer = get_node("DelayAttackTimer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_state()
	process_input()

func set_state():
	if ray_left_foot.is_colliding() or ray_right_foot.is_colliding():
		can_jump = true
	else:
		can_jump = false

func process_input():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		if self.linear_velocity.x < move_speed_max:
			self.apply_impulse(move_right_force, Vector2(0,0))
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		if self.linear_velocity.x > -move_speed_max:
			self.apply_impulse(move_left_force, Vector2(0,0))
		direction.x -= 1
		
	if Input.is_action_just_pressed("ui_accept") and can_jump:
		self.apply_impulse(jump_force, Vector2(0, 0))
	
	if Input.is_action_just_pressed("ui_attack"):
		attackAction = true
	
	if direction.x != 0:
		switch_direction(direction.x)
	
	if attackAction == false && delayAction == false:
		update_animations(direction.x)
	elif attackAction == true && delayAction == false:
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
