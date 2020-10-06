extends RichTextLabel

var _type: int

onready var allowed_statement_types = [
	Rakugo.StatementType.SAY,
	Rakugo.StatementType.ASK,
	Rakugo.StatementType.MENU
]

func _ready() -> void:
	bbcode_enabled = true
	Rakugo.connect("exec_statement", self, "_on_statement")

func _on_statement(type: int, parameters: Dictionary) -> void:
	_type = type

	if not( _type in allowed_statement_types):
		return
	
	if "who" in parameters:
		bbcode_text = parameters.who