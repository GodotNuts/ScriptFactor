extends Node
class_name Validators

class Validator extends RefCounted:
    func validate(value : String) -> bool:
        assert(false) # Just for the base obvs
        return false

class NameValidator extends Validator:
    func validate(value : String) -> bool:
        return value.is_valid_identifier()

class NoValidator extends Validator:
    func validate(value : String) -> bool:
        return true # All things are valid with NoValidator
