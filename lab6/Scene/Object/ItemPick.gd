extends Area2D

@export var itemId : int

var _itemId
var valueIncrease

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_itemId = itemId


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (_itemId == 0):
		Global.gold += 1
	elif (_itemId == 1):
		Global.health += 20
	queue_free()
