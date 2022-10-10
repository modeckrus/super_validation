import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZeroPercentFormatter extends TextInputFormatter {
  ZeroPercentFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    //replace all non-digit except dot characters with empty string
    var newText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    final num newInt = num.tryParse(newText) ?? 0;
    var text = newValue.text;
    var selection = newValue.selection;

    if (newInt == 0 && selection.extentOffset == 1) {
      text = '.0%';

      selection = TextSelection.collapsed(offset: 0);
    }
    return TextEditingValue(
      text: text,
      selection: selection,
    );
  }
}
