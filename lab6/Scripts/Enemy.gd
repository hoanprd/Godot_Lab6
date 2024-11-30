extends CharacterBody2D

@export var id : int
@export var damageDeal : int
@export var enemySpeed : float
@export var rangeLeft : float
@export var rangeRight : float

var timer: Timer
var hurtTimer: Timer
var sprite: Sprite2D

var _id
var _speed
var move_direction : Vector2
var left_limit
var right_limit
var _damageDeal
var start_position: Vector2

func _ready():
	hurtTimer = get_node("HurtTimer")
	timer = get_node("Timer")
	sprite = get_node("Sprite2D")
	
	# Store the initial position of the goblin
	start_position = position
	
	_id = id
	_damageDeal = damageDeal
	_speed = enemySpeed
	left_limit = rangeLeft
	right_limit = rangeRight
	if _id == 0:
		move_direction = Vector2(1, 0)
	elif _id == 1:
		move_direction = Vector2(0, 1)

func _process(delta):
	move_enemy(delta)

func move_enemy(delta):
	if _id == 0:
		position += move_direction * _speed * delta
	
		if position.x <= start_position.x + left_limit:
			move_direction.x = 1
			flip_sprite()
		elif position.x >= start_position.x + right_limit:
			move_direction.x = -1
			flip_sprite()
	elif _id == 1:
		position += move_direction * _speed * delta
	
		if position.y <= start_position.y + left_limit:
			move_direction.y = 1
			flip_sprite()
		elif position.y >= start_position.y + right_limit:
			move_direction.y = -1
			flip_sprite()

func flip_sprite():
	if _id == 0:
		if move_direction.x == 1:
			sprite.scale.x = -abs(sprite.scale.x)
		else:
			sprite.scale.x = abs(sprite.scale.x)
	elif _id == 1:
		if move_direction.y == 1:
			sprite.scale.x = -abs(sprite.scale.x)
		else:
			sprite.scale.x = abs(sprite.scale.x)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and Global.health <= 100 and Global.health > 0:
		Global.health -= _damageDeal
		Global.getHurt = true
		hurtTimer.start()
		timer.start()

func _on_timer_timeout() -> void:
	if Global.health <= 100 and Global.health > 0:
		Global.health -= _damageDeal
		Global.getHurt = true
		hurtTimer.start()
	else:
		timer.stop()

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" and Global.health <= 100:
		Global.getHurt = false
		hurtTimer.stop()
		timer.stop()

func _on_hurt_timer_timeout() -> void:
	Global.getHurt = false
