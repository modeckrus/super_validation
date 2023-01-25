import 'package:super_validation/super_validation.dart';

class SuperValidationNum extends SuperValidation {
  SuperValidationNum([ValidationFunc? validationFunc])
      : super(validationFunc: validationFunc);

  factory SuperValidationNum.minMax(
      {num min = 0,
      num max = double.infinity,
      ValidationFunc? validationFunc,
      String? minMessage,
      String? maxMessage}) {
    return SuperValidationNum((value) {
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
      required num value,
      required num min,
      required num max}) {
    if (value < min) {
      return minMessage;
    } else if (value > max) {
      return maxMessage;
    }
    return null;
  }

  num get numValue {
    //Remove all non-numeric and dot characters
    return parseValue(text);
  }

  set numValue(num value) {
    text = value.toString();
  }

  static num parseValue(String text) {
    final cleanStr = text.replaceAll(RegExp(r'[^\d.]'), '');
    return num.tryParse(cleanStr) ?? 0;
  }
}
