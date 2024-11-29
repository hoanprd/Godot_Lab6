extends Control

@onready var healthBar = $HealthBar
#@onready var health_label = $HealthBar
@onready var pointsLabel = $PointsLabel

var hurtPanel: Panel
var exitGameTimer: Timer
var gameOver: bool
#var health_label: Label
#var points_label: Label
#var winLose_panel: Panel
#var winLose_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthBar.value = Global.health
	#hurtPanel = get_node("HurtPanel")
	#exitGameTimer = get_node("ExitGameTimer")
	#gameOver = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateUI()
	HealthUpdate()

func HealthUpdate():
	if Global.getHurt == true or Global.getHealth == true:
		healthBar.value = Global.health
		Global.getHealth = false

func updateUI():
	pointsLabel.text = str(Global.points)
