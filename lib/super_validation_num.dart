import 'package:super_validation/super_validation.dart';
import 'package:super_validation/super_validation_a.dart';

class SuperValidationNum extends SuperValidation {
  SuperValidationNum({super.validateFunc, super.store});

  factory SuperValidationNum.minMax({
    num min = 0,
    num max = double.infinity,
    String? Function(String?)? validateFunc,
    String? nullMessage,
    String? minMessage,
    String? maxMessage,
    SuperValidationStore<String>? store,
  }) {
    return SuperValidationNum(
        validateFunc: (value) {
          final firstValidation = getMinMaxMessage(
              min: min,
              max: max,
              value: parseValue(value),
              minMessage: minMessage,
              maxMessage: maxMessage);
          return firstValidation ?? validateFunc?.call(value);
        },
        store: store);
  }
  static String? getMinMaxMessage(
      {String? minMessage,
      String? maxMessage,
      String? nullMessage,
      num? value,
      required num min,
      required num max}) {
    if (value == null) {
      return nullMessage;
    }
    if (value < min) {
      return minMessage;
    } else if (value > max) {
      return maxMessage;
    }
    return null;
  }

  num? get numValue {
    //Remove all non-numeric and dot characters
    return parseValue(value);
  }

  set numValue(num? n) {
    if (n == null) {
      value = null;
      return;
    }
    value = n.toString();
  }

  static num? parseValue(String? text) {
    if (text == null) return null;
    final cleanStr = text.replaceAll(RegExp(r'[^\d.]'), '');
    return num.tryParse(cleanStr) ?? 0;
  }
}
