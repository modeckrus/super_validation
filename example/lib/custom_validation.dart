import 'package:super_validation/super_validation_string.dart';

typedef ValidationAddress = String? Function(
    String value, bool isSelectedFromSuggestion,
    [String? houseNumber]);

class SuperValidationAddress extends SuperValidation {
  final ValidationAddress validationAddress;
  SuperValidationAddress(this.validationAddress) : super() {
    validationFunc =
        (_) => validationAddress(text, isSelectedFromSuggestion, houseNumber);
  }
  bool isSelectedFromSuggestion = false;
  String? houseNumber;
  void address(String value, bool isSelectedFromSuggestion,
      [String? houseNumber]) {
    this.isSelectedFromSuggestion = isSelectedFromSuggestion;
    this.houseNumber = houseNumber;
    internalText = value;
  }

  @override
  void controllerSetText(String text) {
    internalText = text;
    isSelectedFromSuggestion = false;
    houseNumber = null;
    internalValidation = validationFunc?.call(text);
    internalController
        .add(SuperValidationHelper(text: text, validation: validation));
  }
}
