extends CharacterBody2D


@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
# Constants
const SPEED = 200          # Speed for horizontal movement
const JUMP_FORCE = -250    # Jump force (negative because Y-axis goes down)
const GRAVITY = 900        # Gravity applied when the player is in the air

# Variable to handle vertical velocity
var vertical_velocity = 0.0  # Vertical speed (gravity, jumping, falling)
var attackAction = false
var delayAction = false
var delayAttackTimer: Timer

# Reference to UI labels
var health_label: Label
var points_label: Label
var winLose_panel: Panel
var winLose_label: Label

func _ready():
	# Get the UI labels from the scene
	health_label = get_node("../CanvasLayer/UI/HealthLabel")
	points_label = get_node("../CanvasLayer/UI/PointsLabel")
	winLose_panel = get_node("../CanvasLayer/UI/WinLosePanel")
	winLose_label = get_node("../CanvasLayer/UI/WinLosePanel/WinLoseLabel")
	delayAttackTimer = get_node("DelayAttackTimer")

func _process(delta):
	if (Global.stopGame == true && Global.health > 0):
		pass
	elif (Global.health <= 0):
		Global.stopGame = true
		winLose_label.text = "YOU LOSE"
		winLose_panel.visible = true
		Global.stopGame = true
	elif (Global.stopGame == false && Global.health > 0):
		handle_movement(delta)
		handle_gravity_and_jump(delta)

# Function to handle player movement (horizontal)
func handle_movement(delta):
	var direction = Vector2.ZERO
	
	# Left and Right Movement
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	if Input.is_action_just_pressed("ui_attack"):
		attackAction = true
	
	# Set the horizontal movement velocity
	velocity.x = direction.x * SPEED
	
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
	#sprite.position.x = horizontal_direction * 4

func update_animations(horizontal_direction):
	if is_on_floor():
		if horizontal_direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
	else:
		pass

# Function to handle jumping, gravity, and falling
func handle_gravity_and_jump(delta):
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			vertical_velocity = JUMP_FORCE
		else:
			vertical_velocity = 0
	else:
		vertical_velocity += GRAVITY * delta

	# Update the vertical component of the velocity
	velocity.y = vertical_velocity

	# Move the player using the velocity vector
	move_and_slide()  # Call this without parameters


func _on_delay_attack_timer_timeout() -> void:
	attackAction = false
	delayAction = false
