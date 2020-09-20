extends Node2D

export var skip := false
export var rollback_speed := 2.0
var state := 0
var state_delta := 0.0

var thread = Thread.new();
var semaphore = Semaphore.new()

func _ready():
	Rakugo.connect("begin", self, "run_dialog_thread")
	Rakugo.connect("story_step", self, "continue_dialog")

	# Rakugo.add_dialog(self, "test_dialog")
	Rakugo.current_dialogs[self] = []
	Rakugo.current_dialogs[self].append("test_dialog")


func set_dialog(dialog_name:String):
	Rakugo.current_node_name = name
	Rakugo.current_dialog_name = dialog_name
	semaphore.post()


func first_state() -> bool:
	return Rakugo.story_state == 0


func say(kwords:Dictionary) -> void:
	if state == Rakugo.story_state:
		Rakugo.say(kwords)
		state += 1
		semaphore.wait()
		print("semaphore.wait()")


func run_dialog_thread():
	thread.start(self, "test_dialog")
	print("start_dialog")


func continue_dialog(arg1 = "", arg2 = ""):
	# prints(arg1, arg2)
	semaphore.post()
	print("semaphore.post()") 


func end_dialog():
	thread.call_deferred("wait_to_finish")
	print("end dialog")


func test_dialog(userdata):
	set_dialog("test_dialog")

	say({"what":
			"This is test for {code}Thread{/code}"
			+ " and {code}Semaphore{/code} approach"})
	prints(state, "state")

	say({"what": "Second Step."})
	prints(state, "state")

	say({"what": "Third Step."})
	prints(state, "state")
	
	end_dialog()


