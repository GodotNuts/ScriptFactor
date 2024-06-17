extends Node
class_name Errors

enum ScriptFactorErrorSeverity {  }

class Error extends RefCounted:
	func _init(error_text : String, replacer_description : String, severity : ScriptFactorErrorSeverity) -> void:
		pass
