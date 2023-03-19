extends Label

class_name ScoreLabel

var score = 0

func on_mob_squashed(mob: Mob):
	score += 1
	text = "Score: %s" % score
