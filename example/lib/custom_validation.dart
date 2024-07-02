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
  void address(String address, bool isSelectedFromSuggestion,
      [String? houseNumber]) {
    this.isSelectedFromSuggestion = isSelectedFromSuggestion;
    this.houseNumber = houseNumber;
    text = address;
  }

  @override
  void controllerSetText(String address) {
    text = address;
    isSelectedFromSuggestion = false;
    houseNumber = null;
    validation = validationFunc?.call(text);
    super.controllerSetText(address);
  }
}
