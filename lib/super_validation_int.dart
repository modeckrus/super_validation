import 'package:super_validation/super_validation.dart';
import 'package:super_validation/super_validation_a.dart';

class SuperValidationInt extends SuperValidation {
  SuperValidationInt({super.validateFunc, super.store});

  factory SuperValidationInt.minMax(
      {int min = 0,
      int max = 9007199254740991,
      String? Function(String?)? validateFunc,
      String? minMessage,
      String? maxMessage,
      SuperValidationStore<String>? store}) {
    return SuperValidationInt(
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
      required int? value,
      required int min,
      required int max}) {
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

  int? get numValue {
    //Remove all non-numeric and dot characters
    return parseValue(value);
  }

  set numValue(int? n) {
    if (n == null) {
      value = null;
      return;
    }
    value = n.toString();
  }

  static int? parseValue(String? text) {
    if (text == null) return null;
    //Remove all non-numeric characters
    final cleanStr = text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleanStr) ?? 0;
  }
}
