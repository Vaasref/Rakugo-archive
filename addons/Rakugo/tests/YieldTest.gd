extends Node2D

var state := 0

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


func update_sate() -> void:
	state += 1


func can_step() -> bool:
	return state == Rakugo.story_state


## test rollback
func _input(event):
	if event.is_action_pressed("rollback"):
		Rakugo.story_state -= 1
		
		if Rakugo.story_state < 0:
			Rakugo.story_state = 0
			
		test_dialog()


func test_dialog():
	set_dialog("test_dialog")

	if first_state():
		Rakugo.say({"what":
			"This is test for {code}yield{/code}"
			+ " and {code}resume{/code} approach"})

		yield(Rakugo, "story_step")
		update_sate()

	if can_step():
		Rakugo.say({"what": "Second Step."})
		yield(Rakugo, "story_step")
		update_sate()

	if can_step():
		Rakugo.say({"what": "Third Step."})
		yield(Rakugo, "story_step")
		update_sate()

