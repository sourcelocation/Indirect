extends CanvasLayer

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_score(score):
	$ScoreLabel.text = str(score)
	$AnimationPlayer.play("BounceScore")

func game_over():
	$AnimationPlayer.play("GameOver")

func show_cheater_message():
	$HighscoreLabel.text = "We know what you're doing..."
