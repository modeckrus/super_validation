import 'package:flutter/material.dart';
import 'package:super_validation/super_validation.dart';

typedef SuperValidationBuilderFunc = Widget Function(
    BuildContext context, String? validation, bool isValid);

class SuperValidationBuilder extends StatelessWidget {
  final SuperValidation superValidation;
  final SuperValidationBuilderFunc builder;
  const SuperValidationBuilder(
      {super.key, required this.superValidation, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: superValidation.streamValidation,
        builder: (context, snapshot) {
          return builder(
              context, superValidation.validation, superValidation.isValid);
        });
  }
}
