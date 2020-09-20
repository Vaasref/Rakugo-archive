extends Node2D

export var skip := false
export var rollback_speed := 2.0
var state := -1
var state_delta := 0.0

var thread = Thread.new()
var sem = Semaphore.new()

func _ready():
	Rakugo.connect("begin", self, "run_dialog_thread")
	Rakugo.connect("story_step", self, "continue_dialog")

	# Rakugo.add_dialog(self, "test_dialog")
	Rakugo.current_dialogs[self] = []
	Rakugo.current_dialogs[self].append("test_dialog")


func set_dialog(dialog_name:String):
	Rakugo.current_node_name = name
	Rakugo.current_dialog_name = dialog_name

func say(kwords:Dictionary) -> void:
	prints( state, Rakugo.story_state)
	if state == Rakugo.story_state:
		Rakugo.say(kwords)
		sem.wait()


func run_dialog_thread():
	thread.start(self, "test_dialog", 2)


func continue_dialog(arg1 = "", arg2 = ""):
	# prints(arg1, arg2)
	if state + 1 >= Rakugo.story_state:
		state = Rakugo.story_state
		sem.post()


func end_dialog():
	thread.call_deferred("wait_to_finish")


func _exit_tree():
	end_dialog()


func test_dialog(userdata):
	set_dialog("test_dialog")

	say({"what":
			"This is test for {code}Thread{/code}"
			+ " and {code}Semaphore{/code} approach"})
	prints(state, "what",
			"This is test for {code}Thread{/code}",
			"and {code}Semaphore{/code} approach")

	say({"what": "Second Step."})
	prints("what", "Second Step.")

	say({"what": "Third Step."})
	prints("what", "Third Step.")
	
	end_dialog()


