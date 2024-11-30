extends CharacterBody2D

@export var hp : int
@export var damageDeal : int
@export var enemySpeed : float
@export var rangeLeft : float
@export var rangeRight : float

var timer: Timer
var hurtTimer: Timer
var sprite: Sprite2D

var _hp
var _speed
var move_direction: Vector2 = Vector2(1, 0)
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
	
	_hp = hp
	_damageDeal = damageDeal
	_speed = enemySpeed
	left_limit = rangeLeft
	right_limit = rangeRight

func _process(delta):
	move_enemy(delta)

func move_enemy(delta):
	position += move_direction * _speed * delta
	
	if position.x <= start_position.x + left_limit:
		move_direction.x = 1
		flip_sprite()
	elif position.x >= start_position.x + right_limit:
		move_direction.x = -1
		flip_sprite()

func flip_sprite():
	if move_direction.x == 1:
		sprite.scale.x = -abs(sprite.scale.x)
	else:
		sprite.scale.x = abs(sprite.scale.x)

func CheckEnemyStatus():
	if _hp <= 0:
		queue_free()
	else:
		sprite.self_modulate = Color(0, 1, 0)

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
