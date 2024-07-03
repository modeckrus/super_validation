import 'package:super_validation/super_validation_string.dart';

class SuperValidationAddress extends SuperValidation {
  SuperValidationAddress({
    super.validateFunc,
    super.store,
  });

  List<String> suggestion = ['Ленина 45', 'Ленина 46', 'Ленина 47'];

  bool isSelectedFromSuggestion = false;
  String? houseNumber;
  void address(String address, bool isSelectedFromSuggestion,
      [String? houseNumber]) {
    this.isSelectedFromSuggestion = isSelectedFromSuggestion;
    this.houseNumber = houseNumber;
    text = address;
  }

  @override
  void controllerSetText(String controllerText) {
    text = controllerText;
    isSelectedFromSuggestion = false;
    houseNumber = null;
    validation = validateFunc?.call(text);
    super.controllerSetText(controllerText);
  }
}
