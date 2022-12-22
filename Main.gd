extends Node

export(PackedScene) var mob_scene
export var mob_speed = 200
var score = 0
var hp
var updating_hp = true
signal invaded_relay
var message = "You Were Knocked Out"
var playclash = false

func _ready():
	randomize()
	$ClashSound.stream.loop = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if updating_hp == true:
		hp = $Player.get_hp()
		$HUD.update_healthlabel("HP: " + str(hp/10))
		$HUD.update_scorelabel("Score: " + str(score))
		if hp == 0:
			updating_hp = false
			game_over()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	mob.position = mob_spawn_location.position
	mob.connect("invaded", self, "invaded_handler")
	mob.connect("score_increase", self, "score_increase_handler")
	$Player.connect("attack", mob, "attack_handler")
	add_child(mob)

func _on_StartTimer_timeout():
	$MobTimer.start()
	
func new_game():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_healthlabel("HP: 500")
	$HUD.show_health_label()
	$HUD.update_scorelabel("Score: " + str(score))
	$HUD.show_score_label()
	$HUD.show_message("The Castle is Under Attack")

func game_over():
	$MobTimer.stop()
	$HUD.show_game_over(message)
	emit_signal("invaded_relay")
	
	
func _on_HUD_complete_reset_game():
	get_tree().reload_current_scene()

func score_increase_handler():
	score += 1

func invaded_handler():
	message = "The Castle Was Breached"
	game_over()
	
func sound_hit_handler():
	if playclash == false:
		playclash = true
		$ClashSound.play()

func _on_ClashSound_finished():
	playclash = false
