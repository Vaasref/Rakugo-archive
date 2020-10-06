extends RichTextLabel

var _type: int
var add_text := false
var typing := false
var ui_accept := false

onready var allowed_statement_types = [
	Rakugo.StatementType.SAY,
	Rakugo.StatementType.ASK,
	Rakugo.StatementType.MENU
]

func _ready() -> void:
	bbcode_enabled = true
	Rakugo.connect("exec_statement", self, "_on_statement")

func _unhandled_input(event: InputEvent) -> void:
	ui_accept = event.is_action_pressed("ui_accept")
	_on_ui_accept(ui_accept)

func _on_ui_accept(value: bool) -> void:
	ui_accept = value

	if not ui_accept:
		return

	ui_accept = false

	if typing: # if typing completed
		typing = false
		Rakugo.dialog_timer.reset()
		return

	elif _type == Rakugo.StatementType.SAY: # else exit statement
		Rakugo.exit_statement()

func _on_statement(type: int, parameters: Dictionary) -> void:
	_type = type

	if not( _type in allowed_statement_types):
		return

	if "what" in parameters:
		var _typing = Rakugo.get_value("typing_text")

		if "typing" in parameters:
			_typing = parameters.typing

		var dtime = Rakugo.get_value("text_time", 0.2)

		if "type_speed" in parameters:
			_typing = true
			var ts = parameters.type_speed
			dtime = abs(1 - ts)

			if dtime > 1:
				dtime = 1

			if dtime == 0:
				typing = false
				dtime = 0.01

		Rakugo.dialogue_timer.wait_time = dtime

		add_text = false

		if "add" in parameters:
			add_text = parameters.add
		
		write_dialog(parameters.what, _typing)

	if Rakugo.skipping:
		typing = false
		return

	return


func write_dialog(new_text: String, _typing: bool) -> void:
	typing = _typing

	if Rakugo.skipping:
		typing = false

	if add_text:
		bbcode_text += new_text
	
	else:
		bbcode_text = new_text

	if typing:
		visible_characters = 0
	else:
		visible_characters = -1
		return
	
	var markup = false

	for letter in text:
		visible_characters += 1
		if letter == "[":
			markup = true
			continue

		if new_text.ends_with("[img]"):
			markup = true
			continue

		if letter == "]":
			markup = false

		if new_text.ends_with("[/img]"):
			markup = false

		if markup:
			continue

		Rakugo.dialog_timer.wait_time = Rakugo.get_value("text_time")

		if letter in ",;.!?":
			var p = ProjectSettings.get_setting(
		"application/rakugo/punctuation_pause")
			Rakugo.dialog_timer.wait_time *= int(p)

		Rakugo.dialog_timer.start()

		yield(Rakugo.dialog_timer, "timeout")
