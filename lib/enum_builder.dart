// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'super_validation.dart';

typedef SuperValidationEnumBuilderFunction<T> = Widget Function(
    BuildContext context, T? value);

class SuperValidationEnumBuilder<T> extends StatelessWidget {
  final SuperValidationEnum<T> superValidation;
  final SuperValidationEnumBuilderFunction<T> builder;
  const SuperValidationEnumBuilder({
    Key? key,
    required this.superValidation,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
        stream: superValidation.streamValue,
        initialData: superValidation.value,
        builder: (context, snapshot) {
          return builder(context, superValidation.value);
        });
  }
}
