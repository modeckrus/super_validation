import 'package:super_validation/super_validation.dart';

class SuperValidationInt extends SuperValidation {
  SuperValidationInt([ValidationFunc? validationFunc])
      : super(validationFunc: validationFunc);

  factory SuperValidationInt.minMax(
      {int min = 0,
      int max = 9007199254740991,
      ValidationFunc? validationFunc,
      String? minMessage,
      String? maxMessage}) {
    return SuperValidationInt((value) {
      final firstValidation = getMinMaxMessage(
          min: min,
          max: max,
          value: parseValue(value),
          minMessage: minMessage,
          maxMessage: maxMessage);
      return firstValidation ?? validationFunc?.call(value);
    });
  }
  static String? getMinMaxMessage(
      {String? minMessage,
      String? maxMessage,
      required int value,
      required int min,
      required int max}) {
    if (value < min) {
      return minMessage;
    } else if (value > max) {
      return maxMessage;
    }
    return null;
  }

  int get numValue {
    //Remove all non-numeric and dot characters
    return parseValue(text);
  }

  static int parseValue(String text) {
    //Remove all non-numeric characters
    final cleanStr = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }
}
