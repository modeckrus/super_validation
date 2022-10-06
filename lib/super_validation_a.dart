abstract class SuperValidationA {
  Stream<String?> get streamValidation;
  Stream<bool> get streamIsValid;
  String? get validation;
  set validation(String? validation);
  bool get isValid => validation == null;
}
