extends Area2D

signal invaded
signal score_increase

var threat = false
export var speed = 100
var mob_health = 5
var defeated = false
var attacking = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mob_health <= 0:
		emit_signal("score_increase")
		queue_free()
		defeated = true
	if threat == true:
		pass
	elif threat == false:
		var velocity = Vector2.ZERO
		velocity.y += 1
		velocity = velocity * speed
		position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	if defeated == false:
		emit_signal("invaded")
		queue_free()


func _on_Mob_area_entered(area):
	threat = true


func _on_Mob_area_exited(area):
	threat = false

func attack_handler():
	if threat == true:
		mob_health -= 1
