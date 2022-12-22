extends CanvasLayer

signal start_game
var game_ended = false
signal complete_reset_game
var message_iteration = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthLabel.hide()
	$ScoreLabel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(message):
	game_ended = true
	show_message(message)
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$StartButton.text = ("Play Again")
	
func update_healthlabel(health):
	$HealthLabel.text = str(health)

func _on_MessageTimer_timeout():
	if game_ended != true:
		if message_iteration == 0:
			message_iteration = 1
			show_message("You Must Protect the Inhabitants")
		elif message_iteration == 1:
			message_iteration = 2
			show_message("Use The Arrow Keys to Move")
		elif message_iteration == 2:
			message_iteration = 3
			show_message("And Use the Space Bar to Attack")
		elif message_iteration == 3:
			show_message("Good Luck Warrior")
			$Message.hide()

func _on_StartButton_pressed():
	if game_ended == false:
		$StartButton.hide()
		emit_signal("start_game")
	elif game_ended == true:
		emit_signal("complete_reset_game")

func show_health_label():
	$HealthLabel.show()

func update_scorelabel(score):
	$ScoreLabel.text = str(score)
	
func show_score_label():
	$ScoreLabel.show()
