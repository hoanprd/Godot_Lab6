extends Area2D

@export var id : int

var _id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_id = id


func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		if _id == 0:
			Global.win = true
			Global.stopGame = true
		elif _id == 1:
			Global.loseArea = true
			Global.stopGame = true
