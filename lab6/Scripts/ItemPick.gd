extends Area2D

@export var itemId : int

var _itemId
var valueIncrease
var targetPos
var label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_itemId = itemId
	targetPos = get_tree().current_scene.get_node("CanvasLayer/UI").global_position
	label = get_tree().current_scene.get_node("CanvasLayer/UI")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if (_itemId == 0):
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", targetPos + Vector2(1200, 10), 0.5).set_ease(Tween.EASE_IN)
			tween.chain().tween_property(self, "visible", false, 0.0)
			tween.tween_property(label, "scale", Vector2(1.9,1.1), 0.05)
			tween.chain().tween_property(label, "scale", Vector2(1.0,1.0), 0.05)
			Global.points += 1
			tween.chain().tween_callback(queue_free)
		elif (_itemId == 1):
			Global.health += 20
			if Global.health > 100:
				Global.health = 100
			Global.getHealth = true
			queue_free()
		#queue_free()
