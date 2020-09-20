extends Node2D

export var skip := false
export var rollback_speed := 2.0
var state := 0
var state_delta := 0.0

func _ready():
	Rakugo.connect("begin", self, "test_dialog")

	# Rakugo.add_dialog(self, "test_dialog")
	Rakugo.current_dialogs[self] = []
	Rakugo.current_dialogs[self].append("test_dialog")


func set_dialog(dialog_name:String):
	Rakugo.current_node_name = name
	Rakugo.current_dialog_name = dialog_name


	
func first_state() -> bool:
	return Rakugo.story_state == 0

func say(kwords:Dictionary) -> void:
	if state == Rakugo.story_state:
		Rakugo.say(kwords)
		state += 1

	else:
		Rakugo.emit_signal("story_step")


func test_dialog():
	set_dialog("test_dialog")

	say({"what":
			"This is test for {code}yield{/code}"
			+ " and {code}resume{/code} approach"})

	yield(Rakugo, "story_step")

	say({"what": "Second Step."})
	yield(Rakugo, "story_step")

	say({"what": "Third Step."})
	yield(Rakugo, "story_step")


