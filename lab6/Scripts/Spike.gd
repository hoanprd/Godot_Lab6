extends Area2D

@export var damageDeal : int

var timer: Timer
var hurtTimer: Timer
var _damageDeal

func _ready():
	hurtTimer = get_node("HurtTimer")
	timer = get_node("Timer")
	_damageDeal = damageDeal

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player" && Global.health <= 100 && Global.health > 0):
		Global.health -= _damageDeal
		Global.getHurt = true
		hurtTimer.start()
		timer.start()


func _on_timer_timeout() -> void:
	if (Global.health <= 100 && Global.health > 0):
		Global.health -= _damageDeal
		Global.getHurt = true
		hurtTimer.start()
	else:
		timer.stop()


func _on_body_exited(body: Node2D) -> void:
	if (body.name == "Player" && Global.health <= 100):
		Global.getHurt = false
		hurtTimer.stop()
		timer.stop()


func _on_hurt_timer_timeout() -> void:
	Global.getHurt = false
