extends PanelContainer

var _type: int
var ui_accept := false

onready var allowed_statement_types = [
	Rakugo.StatementType.SAY,
	Rakugo.StatementType.ASK,
	Rakugo.StatementType.MENU
]

func _ready():
	Rakugo.connect("exec_statement", self, "_on_statement")
	Rakugo.connect("hide_ui", self, "_on_Hide_toggled")

func _process(delta: float) -> void:
	ui_accept = Input.is_action_just_pressed("ui_accept")
	_on_ui_accept(ui_accept)

func _on_ui_accept(value: bool) -> void:
	var ui_accept = value or ui_accept

	if not ui_accept:
		return

	ui_accept = false

	if not visible:
		visible = true
		return

	if not Rakugo.active:
		return

	Rakugo.debug(["story_state", Rakugo.story_state])

	if Rakugo.skip_auto:
		Rakugo.auto_timer.stop_loop()
		Rakugo.skip_timer.stop_loop()
		Rakugo.skip_auto = false
		return

func _on_statement(type: int, parameters: Dictionary) -> void:
	_type = type

	if not( _type in allowed_statement_types):
		return

func _on_Hide_toggled(button_pressed: bool) -> void:
	visible = !button_pressed