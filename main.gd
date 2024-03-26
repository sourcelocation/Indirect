extends Node

@export var spike_scene: PackedScene
@export var player_scene: PackedScene
@export var coin_scene: PackedScene
@export var chocolate_scene: PackedScene

var score = 0
var ground_touches = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_game()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hit_ground():
	_remove_spikes()
	_remove_chocolates()
	
	# troll for cheaters
	if score < 0:
		for n in 100:
			$HUD.show_cheater_message()
			_create_spike()
	
	
	for n in min(abs(score) / 15 + 1, 2):
		_create_spike()
	
	
	score += 1
	$HUD.update_score(score)
	
	ground_touches += 1
	if get_tree().get_nodes_in_group("Coin").size() <= 0:
		var coin = coin_scene.instantiate()
		coin.position = Vector2(10 + 115 * randf(), 80 + 100 * randf())
		coin.body_entered.connect(_on_Coin_body_entered.bind(coin))
		coin.get_node("AnimationPlayer").play("Appear")
		add_child(coin)
		
	
	if get_tree().get_nodes_in_group("Chocolate").size() <= 0 and randi_range(0,7) == 0:
		var chocolate = chocolate_scene.instantiate()
		chocolate.position = Vector2(10 + 115 * randf(), 80 + 100 * randf())
		chocolate.body_entered.connect(_on_Chocolate_body_entered.bind(chocolate))
		chocolate.get_node("AnimationPlayer").play("Appear")
		add_child(chocolate)

func _on_Spikes_body_entered(body):
	if body.is_in_group("Player"):
		_game_over()
#		_reset_game()
		
func _on_Coin_body_entered(body, coin):
	if body.is_in_group("Player"):
		coin.queue_free()
		score += 3
		$HUD.update_score(score)
		
func _on_Chocolate_body_entered(body, chocolate):
	if body.is_in_group("Player"):
		chocolate.queue_free()
		score += 20
		$HUD.update_score(score)

func spawn_player():
	var player = player_scene.instantiate()
	player.hit_ground.connect(_on_player_hit_ground)
	add_child(player)

func _create_spike():
	var spike = spike_scene.instantiate()
	spike.position = Vector2(int(135 / 7 * randf()) * 8 + 3, 208)
	call_deferred("add_child", spike)
	spike.get_node("AnimationPlayer").play("Appear")
	spike.body_entered.connect(_on_Spikes_body_entered)

func _remove_spikes():
	for spike in get_tree().get_nodes_in_group("Spikes"):
		spike.get_node("AnimationPlayer").play("Disappear")
		
func _remove_chocolates():
	for chocolate in get_tree().get_nodes_in_group("Chocolate"):
		chocolate.get_node("AnimationPlayer").play("Disappear")

func _game_over():
	$HUD.game_over()
	for player in get_tree().get_nodes_in_group("Player"):
		player.destroy()
	
func _reset_game():
	for player in get_tree().get_nodes_in_group("Player"):
		player.destroy()
	spawn_player()
	_remove_spikes()
	score = 0
	$HUD.update_score(score)
