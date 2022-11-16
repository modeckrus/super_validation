import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_validation/super_validation.dart';

import '../utils/percent_input_formatter.dart';

class PercentFormNum extends StatelessWidget {
  final SuperValidationNum superValidation;
  final num defaultValue;
  final num maxValue;
  final int mantissaLength;
  final String labelText;
  PercentFormNum({
    Key? key,
    this.defaultValue = 0,
    this.mantissaLength = 1,
    required this.labelText,
    required this.superValidation,
    this.maxValue = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldSuperValidationWithIcon(
      superValidation: superValidation,
      errorIcon: Icon(Icons.error, color: Colors.red, size: 20),
      errorSuffix: Icon(Icons.error, color: Colors.red, size: 20),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        PercentInputFormatter(
            defaultValue: defaultValue, mantissaLength: mantissaLength),
      ],
    );
  }
}
