extends Area2D

signal attack
signal hit

# Declare member variables here. Examples:
export var speed = 200
var screen_size
var back = true
var forward = false
var colliding = true
var hp = 1000
var battle = false
var playing = true


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if battle == true:
		if Input.is_action_just_pressed("attack_sword"):
			emit_signal("attack")
		else:
			if playing == true:
				hp -= 5
				emit_signal("hit")
			if hp <= 0:
				$CollisionShape2D.set_deferred("disabled", true)
				playing = false
	elif battle == false:
		if hp < 1000:
			hp += 1
	var velocity = Vector2.ZERO
	if playing == true:
		if Input.is_action_pressed("move_right"):
			back = false
			forward = false
			$AnimatedSprite.play("side")
			$AnimatedSprite.flip_h = false
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			back = false
			forward = false
			$AnimatedSprite.play("side")
			$AnimatedSprite.flip_h = true
			velocity.x -= 1
		if Input.is_action_pressed("move_up"):
			back = true
			forward = false
			$AnimatedSprite.play("back")
	#		$AnimatedSprite.flip_h = false
	#		forward = true
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			back = false
			forward = true
	#		$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("forward")
			velocity.y += 1
		
		if velocity.length() > 0:
			if velocity.x != 0 && forward == true:
				$AnimatedSprite.play("45")
			velocity = velocity.normalized() * speed
			position += velocity * delta
			position.x = clamp(position.x, 0, screen_size.x)
			position.y = clamp(position.y, 0, screen_size.y)
		
func start(pos):
#	$CollisionShape2D.set_deferred("disabled", true)
#	playing = false
	$AnimatedSprite.play("back")
	position = pos
	show()

func get_hp():
	return hp

func _on_Player_area_entered(area):
	battle = true

func _on_Player_area_exited(area):
	battle = false


func _on_Main_invaded_relay():
	$CollisionShape2D.set_deferred("disabled", true)
	playing = false
