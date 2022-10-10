import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

/// Форматтер процентов
class PercentInputFormatter extends CurrencyInputFormatter {
  PercentInputFormatter({
    required this.defaultValue,
    int mantissaLength = 0,
  }) : super(
          trailingSymbol: '%',
          useSymbolPadding: true,
          mantissaLength: mantissaLength,
        );

  final num defaultValue;

  String get defaultMaskValue => mask(defaultStringValue)!;

  String get defaultStringValue => defaultValue.toString();

  String? mask(String? value) {
    if (value == null || value.isEmpty == true) {
      return null;
    }

    return toCurrencyString(
      value,
      trailingSymbol: '%',
      useSymbolPadding: true,
      mantissaLength: mantissaLength,
    );
  }

  String? unMask(String? value) {
    if (value == null || value.isEmpty == true) {
      return null;
    }

    final String stringNumber = value.replaceAll(RegExp('[%]'), '').trim();
    final num number = num.tryParse(stringNumber) ?? defaultValue;

    return number.toString();
  }
}
